//
//  LFXNetworkContext+Private.h
//  LIFX SDK
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXNetworkContext.h"
@class LFXTransportManager, LFXTaggedLightCollection, LFXLight;

@interface LFXNetworkContext (Private)

@property (nonatomic, readonly) LFXTransportManager *transportManager;

- (void)logEverything;

- (instancetype)initWithClient:(LFXClient *)client transportManager:(LFXTransportManager *)transportManager name:(NSString *)name;

// Removes all cached lights, light collections, and resets the routing table
- (void)resetAllCaches;


// Message Routing
- (void)sendMessage:(LFXMessage *)message;


// Tag Management
- (void)addLight:(LFXLight *)light toTaggedLightCollection:(LFXTaggedLightCollection *)taggedLightCollection;
- (void)removeLight:(LFXLight *)light fromTaggedLightCollection:(LFXTaggedLightCollection *)taggedLightCollection;

// Will return NO if there's already a tag with that name
- (BOOL)renameTaggedLightCollection:(LFXTaggedLightCollection *)collection withNewTag:(NSString *)newTag;


// Light Handling
- (void)scanNetworkForLightStates;

@end
