//
//  LFXNetworkContext+Private.h
//  LIFX SDK
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXNetworkContext.h"
@class LFXTransportManager, LFXTaggedLightCollection, LFXLight, LFXRoutingTable, LFXMessageRateManager, LFXMessage;

@interface LFXNetworkContext (Private)

@property (nonatomic, readonly) LFXTransportManager *transportManager;

@property (nonatomic, readonly) LFXMessageRateManager *messageRateManager;

@property (nonatomic, readonly) LFXRoutingTable *routingTable;

- (void)logEverything;


// For subclasses
- (instancetype)initWithClient:(LFXClient *)client;
+ (Class)transportManagerClass;



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


// Synchronized Updates

// To do synchronized updates, e.g. to change the color on different lights simultaneously, either call the appropriate
// LFXLight/LFXLightCollection methods between calls to -beginSynchronizedUpdates and -commitSynchronizedUpdates, or call
// -performSynchronizedUpdates: and call them in the block
- (void)beginSynchronizedUpdates;
- (void)commitSynchronizedUpdates;

- (void)performSynchronizedUpdates:(void(^)())block;

@end
