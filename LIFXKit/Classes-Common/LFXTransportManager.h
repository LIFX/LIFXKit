//
//  LFXTransportManager.h
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXMessageObservationDescriptor.h"
#import "LFXObserverProxy.h"
#import "LFXTypes.h"
@class LFXNetworkContext, LFXGatewayDescriptor, LFXTransportManager;
@protocol LFXTransportManagerObserver;


@interface LFXTransportManager : NSObject

// Designated Initializer
- (id)initWithNetworkContext:(LFXNetworkContext *)networkContext;

@property (nonatomic, weak) LFXNetworkContext *networkContext;


@property (nonatomic, readonly) LFXConnectionState connectionState;

@property (nonatomic) BOOL isEnabled;


- (void)sendMessage:(LFXMessage *)message NS_REQUIRES_SUPER;


// Observer Based subscriptions
- (void)addMessageObserverObject:(id)observingObject withCallback:(LFXMessageObserverCallback)callback;
- (void)removeMessageObserversForObject:(id)anObserverObject;	// This will remove all observations created with the above method

// Called by -[LFXNetworkContext resetAllCaches]
- (void)reset;


- (void)addTransportManagerObserver:(id <LFXTransportManagerObserver>)observer;
- (void)removeTransportManagerObserver:(id <LFXTransportManagerObserver>)observer;

@end



@interface LFXTransportManager (Subclasses)

// Methods for subclasses to override
- (void)didSetIsEnabled:(BOOL)isEnabled;

// Methods for subclasses to call on self
- (void)didChangeConnectionState:(LFXConnectionState)connectionState;
- (void)didDisconnectWithError:(NSError *)error;
- (void)didConnectToGateway:(LFXGatewayDescriptor *)gatewayDescriptor;

- (void)didSendMessage:(LFXMessage *)message;
- (void)didReceiveMessage:(LFXMessage *)message;

@end



@protocol LFXTransportManagerObserver <NSObject>

- (void)transportManager:(LFXTransportManager *)transportManager didConnectToGateway:(LFXGatewayDescriptor *)gatewayDescriptor;

- (void)transportManager:(LFXTransportManager *)transportManager didChangeConnectionState:(LFXConnectionState)connectionState;
- (void)transportManager:(LFXTransportManager *)transportManager didDisconnectWithError:(NSError *)error;

@end
