//
//  LFXGatewayConnection.m
//  LIFX
//
//  Created by Nick Forge on 6/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXGatewayConnection.h"
#import "LFXTCPGatewayConnection.h"
#import "LFXUDPGatewayConnection.h"
#import "LFXExtensions.h"

@implementation LFXGatewayConnection

- (instancetype)initWithGatewayDescriptor:(LFXGatewayDescriptor *)gateway messageRateManager:(LFXMessageRateManager *)messageRateManager delegate:(id <LFXGatewayConnectionDelegate>)delegate
{
	if ((self = [super init]))
	{
		_gatewayDescriptor = gateway;
		_delegate = delegate;
		_messageRateManager = messageRateManager;
	}
	return self;
}

+ (instancetype)gatewayConnectionWithGatewayDescriptor:(LFXGatewayDescriptor *)gateway messageRateManager:(LFXMessageRateManager *)messageRateManager delegate:(id <LFXGatewayConnectionDelegate>)delegate
{
	switch (gateway.service)
	{
		case LX_PROTOCOL_DEVICE_SERVICE_TCP:
			return [[LFXTCPGatewayConnection alloc] initWithGatewayDescriptor:gateway messageRateManager:messageRateManager delegate:delegate];
		case LX_PROTOCOL_DEVICE_SERVICE_UDP:
			return [[LFXUDPGatewayConnection alloc] initWithGatewayDescriptor:gateway messageRateManager:messageRateManager delegate:delegate];
	}
}

- (void)connect
{
	
}

- (void)disconnect
{
	
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%p (%@/%@:%hu [%@])>", self, self.gatewayDescriptor.protocolString, self.gatewayDescriptor.host, self.gatewayDescriptor.port, self.gatewayDescriptor.path.targetID.stringValue ?: @"nil"];
}

- (void)sendMessage:(LFXMessage *)message
{
	LFXLogError(@"Warning: override me");
}

+ (BOOL)newMessage:(LFXMessage *)newMessage shouldReplaceQueuedMessage:(LFXMessage *)queuedMessage
{
	if (newMessage.messageType != queuedMessage.messageType) return NO;
	if (![newMessage.path isEqual:queuedMessage.path]) return NO;
	
	// If the message is the same type, and directed at the same target, specific logic to _disable_
	// de-duplication should go here.
	
	// For LightSet and LightSetWaveform messages, messages with non-zero at_time refer to a message
	// that will take effect in the future, so they shouldn't be de-duped
	if (newMessage.messageType == LX_PROTOCOL_LIGHT_SET_COLOR ||
		newMessage.messageType == LX_PROTOCOL_LIGHT_SET_WAVEFORM)
	{
		return newMessage.atTime == 0 ? YES : NO;
	}
	
	return YES;
}

@end
