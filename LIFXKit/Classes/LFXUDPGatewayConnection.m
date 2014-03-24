//
//  LFXUDPGatewayConnection.m
//  LIFX
//
//  Created by Nick Forge on 6/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXUDPGatewayConnection.h"
#import "GCDAsyncUdpSocket.h"
#import "LXProtocol.h"
#import "LFXExtensions.h"

@interface LFXUDPGatewayConnection () <GCDAsyncUdpSocketDelegate>
{
}

@property (nonatomic) GCDAsyncUdpSocket *socket;

// FIFO Message Outbox
@property (nonatomic) NSMutableArray *messageOutbox;
@property (nonatomic) NSTimer *outboxTimer;



// This will fire off a DeviceGetPanGateway periodically
@property (nonatomic) NSTimer *heartbeatTimer;

// Every time we receive a message on this connection, a timer will be reset. If
// it fires, the connection is considered "dead".
@property (nonatomic) NSTimer *idleTimeoutTimer;


// Returns YES if host is 255.255.255.255
- (BOOL)isBroadcastConnection;

@end

@implementation LFXUDPGatewayConnection

- (id)initWithGatewayDescriptor:(LFXGatewayDescriptor *)gateway delegate:(id<LFXGatewayConnectionDelegate>)delegate
{
	if ((self = [super initWithGatewayDescriptor:gateway delegate:delegate]))
	{
		self.messageOutbox = [NSMutableArray new];
		self.outboxTimer = [NSTimer timerWithTimeInterval:LFXUDPMessageSendRateLimitInterval target:self selector:@selector(sendNextMessageFromOutbox) userInfo:nil repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:self.outboxTimer forMode:NSRunLoopCommonModes];
		self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:LFXUDPHeartbeatInterval target:self selector:@selector(heartbeatTimerDidFire) userInfo:nil repeats:YES];
		[self resetIdleTimeoutTimer];
	}
	return self;
}

- (BOOL)isBroadcastConnection
{
	return [self.gatewayDescriptor.host isEqualToString:@"255.255.255.255"];
}

- (void)heartbeatTimerDidFire
{
	if ([self isBroadcastConnection]) return;
	
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
	
	LFXLogVerbose(@"Connecting UDP Socket %@:%hu", self.gatewayDescriptor.host, self.gatewayDescriptor.port);
	NSError *error;
	
	error = nil;
    [self.socket bindToPort:self.gatewayDescriptor.port error:&error];
	if (error)
	{
		[self.delegate gatewayConnection:self didDisconnectWithError:error];
		return;
	}
	
	error = nil;
    [self.socket beginReceiving:&error];
	if (error)
	{
		[self.delegate gatewayConnection:self didDisconnectWithError:error];
		return;
	}
	
	if ([[self.gatewayDescriptor.host componentsSeparatedByString:@"."].lastObject isEqualToString:@"255"])
	{
		error = nil;
		[self.socket enableBroadcast:YES error:nil];
		if (error)
		{
			[self.delegate gatewayConnection:self didDisconnectWithError:error];
			return;
		}
	}

	self.connectionState = LFXGatewayConnectionStateConnected;
	[self.delegate gatewayConnectionDidConnect:self];
}

- (BOOL)shouldIgnoreDataFromHost:(NSString *)host
{
    NSString *localHost = [[UIDevice currentDevice] lfx_bestIPAddress];
	return [localHost isEqualToString:host];
}

#pragma mark - LFXGatewayConnection

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
	LFXLogVerbose(@"Sending message on %@ on connection %@:%hu %@", self.gatewayDescriptor.protocolString, self.gatewayDescriptor.host, self.gatewayDescriptor.port, nextMessage.niceLoggingDescription);
	[self.socket sendData:messageData toHost:self.gatewayDescriptor.host port:self.gatewayDescriptor.port withTimeout:-1 tag:0];
}

- (void)logMessageOutboxSize
{
	if (self.messageOutbox.count > 10)
	{
		LFXLogWarn(@"Warning: UDP Message Outbox backlog is %u", (uint32_t)self.messageOutbox.count);
	}
}

#pragma mark - Idle Timeout

- (void)resetIdleTimeoutTimer
{
	if ([self isBroadcastConnection]) return;
	
	if (self.idleTimeoutTimer) [self.idleTimeoutTimer invalidate];
	self.idleTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:LFXUDPIdleTimeoutInterval target:self selector:@selector(idleTimeoutTimerDidFire) userInfo:nil repeats:NO];
}

- (void)idleTimeoutTimerDidFire
{
	LFXLogWarn(@"Idle timeout occured on UDP Connection %@, disconnecting", self);
	self.connectionState = LFXGatewayConnectionStateNotConnected;
	[self.delegate gatewayConnection:self didDisconnectWithError:nil];
}


#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
	NSString *host = [GCDAsyncUdpSocket hostFromAddress:address].lfx_IPv4StringByStrippingIPv6Prefix;

	if (![host isEqualToString:self.gatewayDescriptor.host] && !self.isBroadcastConnection) return;
	
    if ([self shouldIgnoreDataFromHost:host])
	{
//        LFXLogVerbose(@"Ignoring Loopback Message");
        return;
    }
    
//	LFXLogVerbose(@"Network Connection Did Receive Data: %@", data);
	
	LFXMessage *message = [LFXMessage messageWithMessageData:data];
	if (!message)
	{
		LFXLogError(@"Error: couldn't create message from data: %@", data);
		return;
	}
	
    if (self.delegate)
	{
		// NOTE: this is here to get rid of the duplicates that occur due to both the broadcast
		// UDP listener and gateway specific UDP listeners "receiving" the message.
		if ([self.gatewayDescriptor.host isEqualToString:@"255.255.255.255"])
		{
			LFXLogVerbose(@"Received message on %@ on connection %@:%hu %@", self.gatewayDescriptor.protocolString, self.gatewayDescriptor.host, self.gatewayDescriptor.port, message.niceLoggingDescription);
			[self.delegate gatewayConnection:self didReceiveMessage:message fromHost:[GCDAsyncUdpSocket hostFromAddress:address]];
		}
    }
	
	[self resetIdleTimeoutTimer];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
	self.connectionState = LFXGatewayConnectionStateNotConnected;
	[self.delegate gatewayConnection:self didDisconnectWithError:error];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
	self.connectionState = LFXGatewayConnectionStateNotConnected;
	[self.delegate gatewayConnection:self didDisconnectWithError:error];
}

@end
