//
//  LFXGateway.m
//  LIFX
//
//  Created by Nick Forge on 30/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXGatewayDescriptor.h"
#import "LFXExtensions.h"

@implementation LFXGatewayDescriptor

+ (LFXGatewayDescriptor *)gatewayDescriptorWithHost:(NSString *)host port:(uint16_t)port path:(LFXBinaryPath *)path service:(LXProtocolDeviceService)service
{
	LFXGatewayDescriptor *gatewayDescriptor = [LFXGatewayDescriptor new];
	gatewayDescriptor->_host = host;
	gatewayDescriptor->_port = port;
	gatewayDescriptor->_path = path;
	gatewayDescriptor->_service = service;
	return gatewayDescriptor;
}

+ (LFXGatewayDescriptor *)broadcastGatewayDescriptor
{
	return [LFXGatewayDescriptor gatewayDescriptorWithHost:@"255.255.255.255" port:56700 path:nil service:LX_PROTOCOL_DEVICE_SERVICE_UDP];
}

+ (LFXGatewayDescriptor *)clientPeerToPeerGatewayDescriptor
{
	return [LFXGatewayDescriptor gatewayDescriptorWithHost:@"255.255.255.255" port:56750 path:nil service:LX_PROTOCOL_DEVICE_SERVICE_UDP];
}

+ (LFXGatewayDescriptor *)softAPGatewayDescriptor
{
	return [LFXGatewayDescriptor gatewayDescriptorWithHost:@"172.16.0.1" port:56700 path:nil service:LX_PROTOCOL_DEVICE_SERVICE_TCP];
}

- (BOOL)isBroadcastGateway
{
	return [self isEqual:[LFXGatewayDescriptor broadcastGatewayDescriptor]];
}

- (BOOL)isClientPeerToPeerGateway
{
	return [self isEqual:[LFXGatewayDescriptor clientPeerToPeerGatewayDescriptor]];
}

- (BOOL)isSoftAPGateway
{
	return [self isEqual:[LFXGatewayDescriptor softAPGatewayDescriptor]];
}

- (NSString *)protocolString
{
	switch (self.service)
	{
		case LX_PROTOCOL_DEVICE_SERVICE_TCP: return @"TCP";
		case LX_PROTOCOL_DEVICE_SERVICE_UDP: return @"UDP";
	}
}

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(host), SelfKey(port), SelfKey(path), SelfKey(protocolString)]];
}

- (BOOL)isEqual:(id)object
{
	if (![object isKindOfClass:[LFXGatewayDescriptor class]]) return NO;
	LFXGatewayDescriptor *gatewayDescriptor = object;
	if (![gatewayDescriptor.host isEqualToString:self.host]) return NO;
	if (gatewayDescriptor.port != self.port) return NO;
	if (gatewayDescriptor.service != self.service) return NO;
	return YES;
}

- (NSUInteger)hash
{
	return _host.hash ^ _port ^ _path.hash ^ _service;
}

- (id)copyWithZone:(NSZone *)zone
{
	LFXGatewayDescriptor *newGatewayDescriptor = [LFXGatewayDescriptor new];
	newGatewayDescriptor.host = self.host;
	newGatewayDescriptor.port = self.port;
	newGatewayDescriptor.path = self.path;
	newGatewayDescriptor.service = self.service;
	return newGatewayDescriptor;
}

@end
