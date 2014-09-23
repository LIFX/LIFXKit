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
#import "LFXMessageRateManager.h"
#import "LFXWeakObjectProxy.h"

#define TCPOverLANConnectionTimeout 5
#define TCPOverLANSocketWriteTimeout 5
#define TCPOverLANSocketReadStartOfFrameTimeout -1
#define TCPOverLANSocketReadTimeout 5

NSString * const LFXTCPGatewayConnectionErrorDomain = @"LFXTCPGatewayConnectionErrorDomain";

@interface LFXTCPGatewayConnection () <GCDAsyncSocketDelegate, LFXMessageRateManagerObserver>
{
}

@property (nonatomic) GCDAsyncSocket *socket;


@property (nonatomic) NSData *sizeHeaderData; // This stores the uint16_t which describes how big the message will be
@property (nonatomic) uint16_t sizeOfRemainingData;	// This is set to be whatever the .sizeHeaderData dictates, minus the 2 bytes that the size field takes up


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


@property (nonatomic) BOOL TLSHandshakeIsComplete;

@end

@implementation LFXTCPGatewayConnection

- (id)initWithGatewayDescriptor:(LFXGatewayDescriptor *)gateway messageRateManager:(LFXMessageRateManager *)messageRateManager delegate:(id<LFXGatewayConnectionDelegate>)delegate
{
	if ((self = [super initWithGatewayDescriptor:gateway messageRateManager:messageRateManager delegate:delegate]))
	{
		self.weakProxy = [LFXWeakObjectProxy proxyWithObject:self];
		self.connectionState = LFXConnectionStateNotConnected;
		self.messageOutbox = [NSMutableArray new];
		self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:LFXTCPHeartbeatInterval target:self.weakProxy selector:@selector(heartbeatTimerDidFire) userInfo:nil repeats:YES];
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

- (void)heartbeatTimerDidFire
{
	// We don't do heartbeats on SoftAP, since it can kill the network stack
	if (self.gatewayDescriptor.isSoftAPGateway) return;
	
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
	
	LFXLogVerbose(@"Connecting TCP Socket %@:%hu", self.gatewayDescriptor.host, self.gatewayDescriptor.port);
	
	self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	self.connectionState = LFXConnectionStateConnecting;
	
	NSError *error = nil;
	[self.socket connectToHost:self.gatewayDescriptor.host onPort:self.gatewayDescriptor.port withTimeout:TCPOverLANConnectionTimeout error:&error];
	if (error)
	{
		self.connectionState = LFXConnectionStateNotConnected;
		[self.delegate gatewayConnection:self didDisconnectWithError:error];
	}
}

- (void)disconnect
{
	[self.socket disconnect];
	self.connectionState = LFXConnectionStateNotConnected;
}

- (void)startTLS
{
	LFXLogInfo(@"Starting TLS for %@:%hu", self.gatewayDescriptor.host, self.gatewayDescriptor.port);
	NSMutableDictionary *parameters = [NSMutableDictionary new];
	if (self.shouldSkipTLSVerification)
	{
		parameters[(id)kCFStreamSSLValidatesCertificateChain] = @NO;
	}
	if (self.trustedTLSRootCertificate)
	{
		parameters[(id)kCFStreamSSLValidatesCertificateChain] = @NO;
	}
	[self.socket startTLS:parameters];
}

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
	// Don't send anything on a TLS connection until the TLS handshake is complete
	if (self.useTLS == YES && self.TLSHandshakeIsComplete == NO) return;
	
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
	if (self.idleTimeoutTimer) [self.idleTimeoutTimer invalidate];
	self.idleTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:LFXTCPIdleTimeoutInterval target:self.weakProxy selector:@selector(idleTimeoutTimerDidFire) userInfo:nil repeats:NO];
}

- (void)idleTimeoutTimerDidFire
{
	if (self.gatewayDescriptor.isSoftAPGateway) return;
	LFXLogWarn(@"Idle timeout occured on TCP Connection %@, disconnecting", self);
	[self.socket disconnect];
	self.connectionState = LFXConnectionStateNotConnected;
	[self.delegate gatewayConnection:self didDisconnectWithError:nil];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(uint16_t)port
{
	if (self.useTLS)
	{
		[self startTLS];
	}
	
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
	self.connectionState = LFXConnectionStateConnected;
	self.sizeHeaderData = nil;
	self.sizeOfRemainingData = 0;
	[self readSizeFromTCPStream];
	[self.delegate gatewayConnectionDidConnect:self];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
	LFXLogInfo(@"Connection %@ didSecure to %@:%hu", self, self.gatewayDescriptor.host, self.gatewayDescriptor.port);
	
#if TARGET_OS_IPHONE
	if (self.trustedTLSRootCertificate)
	{
		// verify the cert, and fail if appropriate
		
		[sock performBlock:^{
			
			NSError *validationError;
			
			CFReadStreamRef readStream = [sock readStream];
			
			// Create SecTrustRef from Stream
			CFTypeRef ref = CFReadStreamCopyProperty(readStream, kCFStreamPropertySSLPeerCertificates);
			NSString *hostnameToVerify = self.shouldVerifyTLSHostname ? self.gatewayDescriptor.host : nil;
			SecPolicyRef policy = SecPolicyCreateSSL(NO, (__bridge CFStringRef)hostnameToVerify);
			SecTrustRef trust = NULL;
			SecTrustCreateWithCertificates(ref, policy, &trust);
			
			// Verify
			SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)@[(__bridge id)self.trustedTLSRootCertificate]);
			CFRelease(ref);
			SecTrustResultType trustResult = kSecTrustResultInvalid;
			OSStatus status = SecTrustEvaluate(trust, &trustResult);
			
			if (status != errSecSuccess)
			{
				LFXLogError(@"Connection %@ TLS validation evaluation error: %i (see SecBase.h)", self, (int)status);
				validationError = [NSError errorWithDomain:LFXTCPGatewayConnectionErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @"TLS Validation Evaluation Error"}];
			}
			else
			{
				if (trustResult == kSecTrustResultUnspecified || trustResult == kSecTrustResultProceed)
				{
					LFXLogInfo(@"Connection %@ TLS validation succeeded", self);
				}
				else
				{
					LFXLogError(@"Connection %@ TLS validation evaluation failed: %i (see SecTrust.h)", self, (int)trustResult);
					validationError = [NSError errorWithDomain:LFXTCPGatewayConnectionErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @"TLS Validation Failed"}];
				}
			}
			
			dispatch_async(dispatch_get_main_queue(), ^{
				if (validationError)
				{
					[self.delegate gatewayConnection:self didDisconnectWithError:validationError];
				}
				else
				{
					LFXRunBlockWithDelay(0.1, ^{
						self.TLSHandshakeIsComplete = YES;
					});
				}
			});
		}];
		
	}
	else
	{
		LFXRunBlockWithDelay(0.1, ^{
			self.TLSHandshakeIsComplete = YES;
		});
	}
#else
	LFXRunBlockWithDelay(0.1, ^{
		self.TLSHandshakeIsComplete = YES;
	});
#endif
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
			LFXLogVerbose(@"Received message on %@ on connection %@:%hu %@", self.gatewayDescriptor.protocolString, self.gatewayDescriptor.host, self.gatewayDescriptor.port, message.niceLoggingDescription);
			[self.delegate gatewayConnection:self didReceiveMessage:message fromHost:self.gatewayDescriptor.host];
		}
		[self readSizeFromTCPStream];
	}
	[self resetIdleTimeoutTimer];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	LFXLogVerbose(@"Connection %@ didDisconnectWithError:%@", self, err);
	self.connectionState = LFXConnectionStateNotConnected;
	[self.delegate gatewayConnection:self didDisconnectWithError:err];
}

@end
