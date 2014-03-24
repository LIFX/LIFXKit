//
//  LFXTCPGatewayConnection.m
//  LIFX
//
//  Created by Nick Forge on 14/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXTCPGatewayConnection.h"
#import "GCDAsyncSocket.h"
#import "LFXMessage.h"
#import "LXProtocol.h"
#import "LFXExtensions.h"
#import <netinet/tcp.h>
#import <netinet/in.h>

#define TCPOverLANConnectionTimeout 3
#define TCPOverLANSocketWriteTimeout 1
#define TCPOverLANSocketReadStartOfFrameTimeout -1
#define TCPOverLANSocketReadTimeout 3

@interface LFXTCPGatewayConnection () <GCDAsyncSocketDelegate>
{
}

@property (nonatomic) GCDAsyncSocket *socket;


@property (nonatomic) NSData *sizeHeaderData; // This stores the uint16_t which describes how big the message will be
@property (nonatomic) uint16_t sizeOfRemainingData;	// This is set to be whatever the .sizeHeaderData dictates, minus the 2 bytes that the size field takes up


// FIFO Message Outbox
@property (nonatomic) NSMutableArray *messageOutbox;
@property (nonatomic) NSTimer *outboxTimer;


// This will fire off a DeviceGetPanGateway periodically
@property (nonatomic) NSTimer *heartbeatTimer;

// Every time we receive a message on this connection, a timer will be reset. If
// it fires, the connection is considered "dead".
@property (nonatomic) NSTimer *idleTimeoutTimer;

@end

@implementation LFXTCPGatewayConnection

- (id)initWithGatewayDescriptor:(LFXGatewayDescriptor *)gateway delegate:(id<LFXGatewayConnectionDelegate>)delegate
{
	if ((self = [super initWithGatewayDescriptor:gateway delegate:delegate]))
	{
		self.connectionState = LFXGatewayConnectionStateNotConnected;
		self.messageOutbox = [NSMutableArray new];
		self.outboxTimer = [NSTimer timerWithTimeInterval:LFXTCPMessageSendRateLimitInterval target:self selector:@selector(sendNextMessageFromOutbox) userInfo:nil repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:self.outboxTimer forMode:NSRunLoopCommonModes];
		self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:LFXTCPHeartbeatInterval target:self selector:@selector(heartbeatTimerDidFire) userInfo:nil repeats:YES];
	}
	return self;
}

- (void)heartbeatTimerDidFire
{
	// We don't do heartbeats on SoftAP, since it can kill the network stack
	if (self.gatewayDescriptor.isSoftAPGateway) return;
	
	if (self.connectionState == LFXGatewayConnectionStateConnected)
	{
		LFXMessageDeviceGetPanGateway *getInfo = [LFXMessageDeviceGetPanGateway messageWithBinaryPath:self.gatewayDescriptor.path];
		[self sendMessage:getInfo];
	}
}

- (void)connect
{
	if (self.connectionState != LFXGatewayConnectionStateNotConnected)
	{
		return;
	}
	
	LFXLogVerbose(@"Connecting TCP Socket %@:%hu", self.gatewayDescriptor.host, self.gatewayDescriptor.port);
	
	self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	self.connectionState = LFXGatewayConnectionStateConnecting;
	
	NSError *error = nil;
	[self.socket connectToHost:self.gatewayDescriptor.host onPort:self.gatewayDescriptor.port withTimeout:TCPOverLANConnectionTimeout error:&error];
	if (error)
	{
		self.connectionState = LFXGatewayConnectionStateNotConnected;
		[self.delegate gatewayConnection:self didDisconnectWithError:error];
	}
}

- (void)disconnect
{
	[self.socket disconnect];
	self.connectionState = LFXGatewayConnectionStateNotConnected;
}

- (void)sendMessage:(LFXMessage *)message
{
	for (NSUInteger outboxIndex = 0; outboxIndex < self.messageOutbox.count; outboxIndex ++)
	{
		if ([LFXGatewayConnection newMessage:message makesQueuedMessageRedundant:self.messageOutbox[outboxIndex]])
		{
			self.messageOutbox[outboxIndex] = message;
			[self logMessageOutboxSize];
			return;
		}
	}
	[self.messageOutbox addObject:message];
	[self logMessageOutboxSize];
}

- (void)sendNextMessageFromOutbox
{
	LFXMessage *nextMessage = self.messageOutbox.firstObject;
	if (!nextMessage) return;
	
	[self.messageOutbox removeObjectAtIndex:0];
	[self logMessageOutboxSize];
	NSData *messageData = [nextMessage messageDataRepresentation];
	LFXLogVerbose(@"Sending message on %@ on connection %@:%hu: %@", self.gatewayDescriptor.protocolString, self.gatewayDescriptor.host, self.gatewayDescriptor.port, nextMessage.niceLoggingDescription);
	[self.socket writeData:messageData withTimeout:TCPOverLANSocketWriteTimeout tag:0];
}

- (void)logMessageOutboxSize
{
	if (self.messageOutbox.count > 10)
	{
		LFXLogWarn(@"Warning: TCP Message Outbox backlog is %u", (uint32_t)self.messageOutbox.count);
	}
}

#pragma mark - Idle Timeout

- (void)resetIdleTimeoutTimer
{
	if (self.idleTimeoutTimer) [self.idleTimeoutTimer invalidate];
	self.idleTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:LFXTCPIdleTimeoutInterval target:self selector:@selector(idleTimeoutTimerDidFire) userInfo:nil repeats:NO];
}

- (void)idleTimeoutTimerDidFire
{
	if (self.gatewayDescriptor.isSoftAPGateway) return;
	LFXLogWarn(@"Idle timeout occured on TCP Connection %@, disconnecting", self);
	[self.socket disconnect];
	self.connectionState = LFXGatewayConnectionStateNotConnected;
	[self.delegate gatewayConnection:self didDisconnectWithError:nil];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(uint16_t)port
{
	LFXLogVerbose(@"Connection %@ didConnectToHost:%@ port:%hu", self, host, port);
	[socket performBlock:^{
		
		int optionValue = 1;
		if (setsockopt(socket.socketFD, IPPROTO_TCP, TCP_NODELAY, &optionValue, sizeof(optionValue)) != 0)
		{
			LFXLogError(@"Error setting IPPROTO_TCP:TCP_NODELAY to %i", optionValue);
		}
		
		optionValue = 512;
		if (setsockopt(socket.socketFD, IPPROTO_TCP, TCP_MAXSEG, &optionValue, sizeof(optionValue)) != 0)
		{
			LFXLogError(@"Error setting IPPROTO_TCP:TCP_MAXSEG to %i", optionValue);
		}
		
		optionValue = 512;
		if (setsockopt(socket.socketFD, SOL_SOCKET, SO_SNDBUF, &optionValue, sizeof(optionValue)) != 0)
		{
			LFXLogError(@"Error setting SOL_SOCKET:SO_SNDBUF to %i", optionValue);
		}
		
	}];
	self.connectionState = LFXGatewayConnectionStateConnected;
	self.sizeHeaderData = nil;
	self.sizeOfRemainingData = 0;
	[self readSizeFromTCPStream];
	[self.delegate gatewayConnectionDidConnect:self];
}

- (void)readSizeFromTCPStream
{
	[self.socket readDataToLength:sizeof(uint16_t) withTimeout:TCPOverLANSocketReadStartOfFrameTimeout tag:0];
}

- (void)readRestOfMessageFromTCPStream
{
	[self.socket readDataToLength:self.sizeOfRemainingData withTimeout:TCPOverLANSocketReadTimeout tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	if (!self.sizeHeaderData)
	{
		if (data.length != sizeof(uint16_t))
		{
			LFXLogError(@"Error: was expecting 2 bytes, received %tu", data.length);
			[self disconnect];
			return;
		}
		uint16_t size = 0;
		[data getBytes:&size length:sizeof(uint16_t)];
		if (size > 200)
		{
			[self disconnect];
			return;
		}
		self.sizeOfRemainingData = size - sizeof(uint16_t);
		self.sizeHeaderData = data;
		[self readRestOfMessageFromTCPStream];
	}
	else
	{
		if (data.length != self.sizeOfRemainingData)
		{
			LFXLogError(@"Error: was expecting %hu bytes, received %tu", self.sizeOfRemainingData, data.length);
			[self disconnect];
			return;
		}
		NSMutableData *messageData = [NSMutableData new];
		[messageData appendData:self.sizeHeaderData];
		[messageData appendData:data];
		
		self.sizeHeaderData = nil;
		self.sizeOfRemainingData = 0;
		
		LFXMessage *message = [LFXMessage messageWithMessageData:messageData];
		if (!message)
		{
			LFXLogError(@"Error: disconnecting %@ since we couldn't create a valid message from data: %@", self, data);
			[self disconnect];
			return;
		}
		else
		{
			LFXLogVerbose(@"Sending message on %@ on connection %@:%hu %@", self.gatewayDescriptor.protocolString, self.gatewayDescriptor.host, self.gatewayDescriptor.port, message.niceLoggingDescription);
			[self.delegate gatewayConnection:self didReceiveMessage:message fromHost:self.gatewayDescriptor.host];
		}
		[self readSizeFromTCPStream];
	}
	[self resetIdleTimeoutTimer];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	LFXLogVerbose(@"Connection %@ didDisconnectWithError:%@", self, err);
	self.connectionState = LFXGatewayConnectionStateNotConnected;
	[self.delegate gatewayConnection:self didDisconnectWithError:err];
}

@end
