//
//  LFXNetworkContext.h
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXTypes.h"
@class LFXClient, LFXLightCollection, LFXTaggedLightCollection, LFXAdHocLightCollection;
@protocol LFXNetworkContextObserver;

extern NSString * const LFXNetworkContextErrorDomain;

typedef NS_ENUM(NSInteger, LFXNetworkContextErrorCode) {
	LFXNetworkContextTimeoutError = 1,
	LFXNetworkContextAuthenticationError = 2,
	LFXNetworkContextNetworkDownError = 3,
	LFXNetworkContextNoDevicesFoundError = 4,
};

extern NSString * const LFXNetworkContextTypeLocal;

@interface LFXNetworkContext : NSObject

@property (nonatomic, readonly, weak) LFXClient *client;


@property (nonatomic, readonly) NSString *networkContextType;	// LFXNetworkContextType*
@property (nonatomic, readonly) NSString *name;

@property (nonatomic) BOOL isEnabled;
@property (nonatomic, readonly) LFXConnectionState connectionState;


//
// Lights
//

@property (nonatomic, readonly) LFXLightCollection *allLightsCollection;
@property (nonatomic, readonly) LFXLightCollection *untaggedLightsCollection;


//
// Tags
//

// Querying Tags
@property (nonatomic, readonly) NSArray /* LFXTaggedLightCollection */ *taggedLightCollections;
- (LFXTaggedLightCollection *)taggedLightCollectionForTag:(NSString *)tag;	// Convenience method

// Manipulating Tags
- (LFXTaggedLightCollection *)addTaggedLightCollectionWithTag:(NSString *)tag;
- (void)deleteTaggedLightCollection:(LFXTaggedLightCollection *)taggedLightCollection;



//
// Ad Hoc Collections
//

- (LFXAdHocLightCollection *)createAdHocLightCollection;



// Observers

- (void)addNetworkContextObserver:(id <LFXNetworkContextObserver>)observer;
- (void)removeNetworkContextObserver:(id <LFXNetworkContextObserver>)observer;

@end



@interface LFXNetworkContext (Deprecated)

@property (nonatomic, readonly) BOOL isConnected DEPRECATED_MSG_ATTRIBUTE("use .connectionState instead.");

@end



@protocol LFXNetworkContextObserver <NSObject>

@optional
- (void)networkContext:(LFXNetworkContext *)networkContext didChangeIsEnabled:(BOOL)isEnabled;

- (void)networkContext:(LFXNetworkContext *)networkContext didChangeConnectionState:(LFXConnectionState)connectionState;
- (void)networkContext:(LFXNetworkContext *)networkContext didDisconnectWithError:(NSError *)error;

- (void)networkContext:(LFXNetworkContext *)networkContext didAddTaggedLightCollection:(LFXTaggedLightCollection *)collection;
- (void)networkContext:(LFXNetworkContext *)networkContext didRemoveTaggedLightCollection:(LFXTaggedLightCollection *)collection;

// Deprecated
- (void)networkContextDidConnect:(LFXNetworkContext *)networkContext DEPRECATED_MSG_ATTRIBUTE("use networkContext:didChangeConnectionState: instead");
- (void)networkContextDidDisconnect:(LFXNetworkContext *)networkContext DEPRECATED_MSG_ATTRIBUTE("use networkContext:didChangeConnectionState: instead");

@end
