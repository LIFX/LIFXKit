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

- (instancetype)initWithGatewayDescriptor:(LFXGatewayDescriptor *)gateway delegate:(id <LFXGatewayConnectionDelegate>)delegate
{
	if ((self = [super init]))
	{
		_gatewayDescriptor = gateway;
		_delegate = delegate;
	}
	return self;
}

+ (instancetype)gatewayConnectionWithGatewayDescriptor:(LFXGatewayDescriptor *)gateway delegate:(id <LFXGatewayConnectionDelegate>)delegate
{
	switch (gateway.service)
	{
		case LX_PROTOCOL_DEVICE_SERVICE_TCP:
			return [[LFXTCPGatewayConnection alloc] initWithGatewayDescriptor:gateway delegate:delegate];
		case LX_PROTOCOL_DEVICE_SERVICE_UDP:
			return [[LFXUDPGatewayConnection alloc] initWithGatewayDescriptor:gateway delegate:delegate];
			break;
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
	return [NSString stringWithFormat:@"<%p (%@/%@:%hu)>", self, self.gatewayDescriptor.protocolString, self.gatewayDescriptor.host, self.gatewayDescriptor.port];
}

- (NSString *)connectionStateString
{
	switch (self.connectionState)
	{
		case LFXGatewayConnectionStateConnected:	return @"connected";
		case LFXGatewayConnectionStateConnecting:	return @"connecting";
		case LFXGatewayConnectionStateNotConnected:	return @"not connected";
	}
}

- (void)sendMessage:(LFXMessage *)message
{
	LFXLogError(@"Warning: override me");
}

+ (BOOL)newMessage:(LFXMessage *)newMessage makesQueuedMessageRedundant:(LFXMessage *)queuedMessage
{
	if (newMessage.messageType != queuedMessage.messageType) return NO;
	if (![newMessage.path isEqual:queuedMessage.path]) return NO;
	
	NSArray *permittedMessageTypes = @[
									   @(LX_PROTOCOL_LIGHT_SET),
									   @(LX_PROTOCOL_LIGHT_SET_DIM_ABSOLUTE),
									   @(LX_PROTOCOL_DEVICE_SET_POWER),
									   @(LX_PROTOCOL_LIGHT_GET),
									   @(LX_PROTOCOL_LIGHT_SET_WAVEFORM),
									   @(LX_PROTOCOL_DEVICE_GET_MESH_FIRMWARE),
									   @(LX_PROTOCOL_DEVICE_GET_WIFI_FIRMWARE),
									   @(LX_PROTOCOL_DEVICE_GET_VERSION)
									   ];
	if (![permittedMessageTypes containsObject:@(newMessage.messageType)]) return NO;
	
	return YES;
}

@end
