//
//  LFXGateway.h
//  LIFX
//
//  Created by Nick Forge on 30/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXTypes.h"
#import "LFXMessage.h"
@class LFXGatewayDescriptor, LFXBinaryPath;

@interface LFXGatewayDescriptor : NSObject <NSCopying>

+ (LFXGatewayDescriptor *)gatewayDescriptorWithHost:(NSString *)host port:(uint16_t)port path:(LFXBinaryPath *)path service:(LXProtocolDeviceService)service;

+ (LFXGatewayDescriptor *)broadcastGatewayDescriptor;
+ (LFXGatewayDescriptor *)clientPeerToPeerGatewayDescriptor;
+ (LFXGatewayDescriptor *)softAPGatewayDescriptor;

- (BOOL)isBroadcastGateway;
- (BOOL)isClientPeerToPeerGateway;
- (BOOL)isSoftAPGateway;

@property (nonatomic) NSString *host;
@property (nonatomic) uint16_t port;
@property (nonatomic) LFXBinaryPath *path;
@property (nonatomic) LXProtocolDeviceService service;

- (NSString *)protocolString;

@end
