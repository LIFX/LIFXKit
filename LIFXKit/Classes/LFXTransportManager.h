//
//  LFXTransportManager.h
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXMessageObservationDescriptor.h"
@class LFXNetworkContext, LFXGatewayDescriptor, LFXTransportManager;

@protocol LFXTransportManagerDelegate <NSObject>

- (void)transportManagerDidConnect:(LFXTransportManager *)transportManager;
- (void)transportManagerDidDisconnect:(LFXTransportManager *)transportManager;

- (void)transportManager:(LFXTransportManager *)transportManager didConnectToGateway:(LFXGatewayDescriptor *)gatewayDescriptor;
- (void)transportManager:(LFXTransportManager *)transportManager didDisconnectFromGateway:(LFXGatewayDescriptor *)gatewayDescriptor;

@end


@interface LFXTransportManager : NSObject

@property (nonatomic, weak) LFXNetworkContext *networkContext;
@property (nonatomic, weak) id <LFXTransportManagerDelegate> delegate;

// May have no meaning for some Network Contexts
- (void)connect;
- (void)disconnect;

@property (nonatomic, readonly) BOOL isConnected;

// Should be overriden by subclasses.

// After sending, -sendObserverCallbacksForMessage: should be called with the message.
- (void)sendMessage:(LFXMessage *)message;



// Token Based subscriptions
- (id)addMessageObserverWithCallback:(LFXMessageObserverCallback)callback;	// returns an observer "token"
- (void)removeMessageObserverToken:(id)observerToken;	// This will remove the single observation created with the above method

// Observer Based subscriptions
- (void)addMessageObserverObject:(id)observingObject withCallback:(LFXMessageObserverCallback)callback;
- (void)removeMessageObserversForObject:(id)anObserverObject;	// This will remove all observations created with the above method



@end

@interface LFXTransportManager (Subclasses)


// This should be called (not overriden) for every incoming _and_ outgoing message
- (void)sendObserverCallbacksForMessage:(LFXMessage *)message;


// Calling the setter will result - transportManagedDid(Dis)Connect: being sent to the delegate NC, which will result
// in the NC's did(Dis)connect callbacks being sent.
@property (nonatomic) BOOL isConnected;

@end



