//
//  LFXUDPGatewayConnection.m
//  LIFX
//
//  Created by Nick Forge on 6/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXUDPGatewayConnection.h"
#import "GCDAsyncUdpSocket.h"
#import "LFXClientDevice.h"
#import "LXProtocol.h"
#import "LFXExtensions.h"
#import "LFXMessageRateManager.h"
#import "LFXWeakObjectProxy.h"

@interface LFXUDPGatewayConnection () <GCDAsyncUdpSocketDelegate, LFXMessageRateManagerObserver>
{
}

@property (nonatomic) GCDAsyncUdpSocket *socket;

// FIFO Message Outbox
@property (nonatomic) NSMutableArray *messageOutbox;
@property (nonatomic) NSTimer *outboxTimer;


// Used to avoid NSTimer retain cycles
@property (nonatomic) LFXWeakObjectProxy *weakProxy;


// This will fire off a DeviceGetPanGateway periodically
@property (nonatomic) NSTimer *heartbeatTimer;

// Every time we receive a message on this connection, a timer will be reset. If
// it fires, the connection is considered "dead".
@property (nonatomic) NSTimer *idleTimeoutTimer;


// Returns YES if host is 255.255.255.255
- (BOOL)isBroadcastConnection;

@end

@implementation LFXUDPGatewayConnection

- (id)initWithGatewayDescriptor:(LFXGatewayDescriptor *)gateway messageRateManager:(LFXMessageRateManager *)messageRateManager delegate:(id<LFXGatewayConnectionDelegate>)delegate
{
	if ((self = [super initWithGatewayDescriptor:gateway messageRateManager:messageRateManager delegate:delegate]))
	{
		self.weakProxy = [LFXWeakObjectProxy proxyWithObject:self];
		self.messageOutbox = [NSMutableArray new];
		self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:LFXUDPHeartbeatInterval target:self.weakProxy selector:@selector(heartbeatTimerDidFire) userInfo:nil repeats:YES];
		[self resetIdleTimeoutTimer];
		[messageRateManager addMessageRateObserver:self];
		[self setupOutboxTimerWithInterval:messageRateManager.messageRate];
	}
	return self;
}

- (void)dealloc
{
	[self.outboxTimer invalidate];
	[self.heartbeatTimer invalidate];
	[self.idleTimeoutTimer invalidate];
    [self.messageRateManager removeMessageRateObserver:self];
}

- (void)setupOutboxTimerWithInterval:(NSTimeInterval)interval
{
	if (self.outboxTimer)
	{
		if (self.outboxTimer.timeInterval == interval)
		{
			return;
		}
		LFXLogInfo(@"Changing message rate on %@ to %0.0fms", self, interval * 1000.0);
		[self.outboxTimer invalidate];
		self.outboxTimer = nil;
	}
	
	self.outboxTimer = [NSTimer timerWithTimeInterval:interval target:self.weakProxy selector:@selector(sendNextMessageFromOutbox) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:self.outboxTimer forMode:NSRunLoopCommonModes];
}

- (void)messageRateManager:(LFXMessageRateManager *)manager didChangeMessageRate:(NSTimeInterval)messageRate
{
	[self setupOutboxTimerWithInterval:messageRate];
}

- (BOOL)isBroadcastConnection
{
	return [self.gatewayDescriptor.host isEqualToString:@"255.255.255.255"];
}

- (void)heartbeatTimerDidFire
{
	if ([self isBroadcastConnection]) return;
	
	if (self.connectionState == LFXConnectionStateConnected)
	{
		LFXMessageDeviceGetPanGateway *getInfo = [LFXMessageDeviceGetPanGateway messageWithBinaryPath:self.gatewayDescriptor.path];
		[self sendMessage:getInfo];
	}
}

- (void)connect
{
	if (self.connectionState != LFXConnectionStateNotConnected)
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

	self.connectionState = LFXConnectionStateConnected;
	[self.delegate gatewayConnectionDidConnect:self];
}

- (BOOL)shouldIgnoreDataFromHost:(NSString *)host
{
    NSString *localHost = [LFXClientDevice bestIPAddress];
    return [localHost isEqualToString:host];
}

#pragma mark - LFXGatewayConnection

- (void)sendMessage:(LFXMessage *)message
{
	for (NSUInteger outboxIndex = 0; outboxIndex < self.messageOutbox.count; outboxIndex ++)
	{
		if ([LFXGatewayConnection newMessage:message shouldReplaceQueuedMessage:self.messageOutbox[outboxIndex]])
		{
			self.messageOutbox[outboxIndex] = message;
			[self logMessageOutboxSize];
			return;
		}
	}
	
	// Search from the end, and find the first message with the same or higher priority, and
	// insert the new message after that. If there's messages with the same or higher priority,
	// insert it at the start.
	NSUInteger indexToInsert = 0;
	for (NSInteger messageIndex = self.messageOutbox.count - 1; messageIndex >= 0; messageIndex --)
	{
		LFXMessage *existingMessage = self.messageOutbox[messageIndex];
		if (message.qosPriority <= existingMessage.qosPriority)
		{
			indexToInsert = messageIndex + 1;
			break;
		}
	}
	[self.messageOutbox insertObject:message atIndex:indexToInsert];
	
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
	LFXRunBlockWithDelay(0.005, ^{
		[self.socket sendData:messageData toHost:self.gatewayDescriptor.host port:self.gatewayDescriptor.port withTimeout:-1 tag:0];
	});
	LFXRunBlockWithDelay(0.010, ^{
		[self.socket sendData:messageData toHost:self.gatewayDescriptor.host port:self.gatewayDescriptor.port withTimeout:-1 tag:0];
	});
}

- (void)logMessageOutboxSize
{
	// Only log a warning if there's more than 10 messages of normal or higher QoS priority
	NSInteger const outboxWarningSize = 10;
	if (self.messageOutbox.count > outboxWarningSize && [[self.messageOutbox objectAtIndex:outboxWarningSize] qosPriority] >= LFXMessageQosPriorityNormal)
	{
		LFXLogWarn(@"Warning: %@ Message Outbox backlog is %u", self.gatewayDescriptor.protocolString, (uint32_t)self.messageOutbox.count);
	}
}

#pragma mark - Idle Timeout

- (void)resetIdleTimeoutTimer
{
	if (self.ignoresIdleTimeout) return;
	if ([self isBroadcastConnection]) return;
	
	if (self.idleTimeoutTimer) [self.idleTimeoutTimer invalidate];
	self.idleTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:LFXUDPIdleTimeoutInterval target:self.weakProxy selector:@selector(idleTimeoutTimerDidFire) userInfo:nil repeats:NO];
}

- (void)idleTimeoutTimerDidFire
{
	LFXLogWarn(@"Idle timeout occured on UDP Connection %@, disconnecting", self);
	self.connectionState = LFXConnectionStateNotConnected;
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
			message.gatewayDescriptor = [LFXGatewayDescriptor gatewayDescriptorWithHost:host port:sock.connectedPort path:self.gatewayDescriptor.path service:LX_PROTOCOL_DEVICE_SERVICE_UDP];
			LFXLogVerbose(@"Received message on %@ on connection %@:%hu %@", message.gatewayDescriptor.protocolString, message.gatewayDescriptor.host, message.gatewayDescriptor.port, message.niceLoggingDescription);
			[self.delegate gatewayConnection:self didReceiveMessage:message fromHost:host];
		}
    }
	
	[self resetIdleTimeoutTimer];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
	self.connectionState = LFXConnectionStateNotConnected;
	[self.delegate gatewayConnection:self didDisconnectWithError:error];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
	self.connectionState = LFXConnectionStateNotConnected;
	[self.delegate gatewayConnection:self didDisconnectWithError:error];
}

@end
