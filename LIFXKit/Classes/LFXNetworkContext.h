//
//  LFXNetworkContext.h
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXTypes.h"
@class LFXClient, LFXLightCollection, LFXTaggedLightCollection;
@protocol LFXNetworkContextObserver;


@interface LFXNetworkContext : NSObject

@property (nonatomic, readonly, weak) LFXClient *client;
@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) BOOL isConnected;


//
// Lights
//

@property (nonatomic, readonly) LFXLightCollection *allLightsCollection;



//
// Tags
//

// Querying Tags
@property (nonatomic, readonly) NSArray *taggedLightCollections;			// Contains LFXTaggedLightCollection objects
- (LFXTaggedLightCollection *)taggedLightCollectionForTag:(NSString *)tag;	// Convenience method

// Manipulating Tags
- (LFXTaggedLightCollection *)addTaggedLightCollectionWithTag:(NSString *)tag;
- (void)deleteTaggedLightCollection:(LFXTaggedLightCollection *)taggedLightCollection;



// Observers

- (void)addNetworkContextObserver:(id <LFXNetworkContextObserver>)observer;
- (void)removeNetworkContextObserver:(id <LFXNetworkContextObserver>)observer;

@end



@protocol LFXNetworkContextObserver <NSObject>

@optional
- (void)networkContextDidConnect:(LFXNetworkContext *)networkContext;
- (void)networkContextDidDisconnect:(LFXNetworkContext *)networkContext;

- (void)networkContext:(LFXNetworkContext *)networkContext didAddTaggedLightCollection:(LFXTaggedLightCollection *)collection;
- (void)networkContext:(LFXNetworkContext *)networkContext didRemoveTaggedLightCollection:(LFXTaggedLightCollection *)collection;

@end
