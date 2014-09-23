//
//  LFXTransportManager.m
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXTransportManager.h"
#import "LFXExtensions.h"
#import "LFXNetworkContext.h"
#import "LFXMessage.h"
#import "LFXObserverProxy.h"

@interface LFXTransportManager ()

@property (nonatomic) NSMutableArray *observationDescriptors;

@property (nonatomic) LFXObserverProxy <LFXTransportManagerObserver> *transportManagerObserverProxy;

@property (nonatomic) LFXConnectionState connectionState;

@end

@implementation LFXTransportManager

- (id)initWithNetworkContext:(LFXNetworkContext *)networkContext
{
	if ((self = [super init]))
	{
		_networkContext = networkContext;
		_observationDescriptors = [NSMutableArray new];
		_transportManagerObserverProxy = LFXCreateObserverProxy(LFXTransportManagerObserver);
	}
	return self;
}

- (BOOL)isConnected
{
	return self.connectionState == LFXConnectionStateConnected;
}

- (void)setIsEnabled:(BOOL)isEnabled
{
	_isEnabled = isEnabled;
	[self didSetIsEnabled:isEnabled];
}

- (void)didChangeConnectionState:(LFXConnectionState)connectionState
{
	self.connectionState = connectionState;
	[self.transportManagerObserverProxy transportManager:self didChangeConnectionState:connectionState];
}

- (void)didConnectToGateway:(LFXGatewayDescriptor *)gatewayDescriptor
{
	[self.transportManagerObserverProxy transportManager:self didConnectToGateway:gatewayDescriptor];
}

- (void)didDisconnectWithError:(NSError *)error
{
	[self.transportManagerObserverProxy transportManager:self didDisconnectWithError:error];
}

- (void)didSendMessage:(LFXMessage *)message
{
	[self sendObserverCallbacksForMessage:message];
}

- (void)didReceiveMessage:(LFXMessage *)message
{
	[self sendObserverCallbacksForMessage:message];	
}

- (void)sendMessage:(LFXMessage *)message
{
	if (![NSThread isMainThread]) LFXLogError(@"Error: %s is not thread-safe, please ensure it is only called from the main thread", __PRETTY_FUNCTION__);
	if (message.path == nil) LFXLogError(@"Error: sending message from %@ with a nil Binary Path", self);
}

- (void)reset
{
	
}

//=======================================================================
//
#pragma mark - Observers
//
//=======================================================================

- (void)addTransportManagerObserver:(id<LFXTransportManagerObserver>)observer
{
	[self.transportManagerObserverProxy addObserver:observer];
}

- (void)removeTransportManagerObserver:(id<LFXTransportManagerObserver>)observer
{
	[self.transportManagerObserverProxy removeObserver:observer];
}

// Observer Based subscriptions
- (void)addMessageObserverObject:(id)observingObject withCallback:(LFXMessageObserverCallback)callback
{
	LFXMessageObservationDescriptor *observationDescriptor = [LFXMessageObservationDescriptor new];
	observationDescriptor.callback = callback;
	observationDescriptor.observingObject = observingObject;
	[self.observationDescriptors addObject:observationDescriptor];
}

- (void)removeMessageObserversForObject:(id)anObserverObject
{
	for (LFXMessageObservationDescriptor *observationDescriptor in self.observationDescriptors.copy)
	{
		if ([observationDescriptor observingObjectWasEqualTo:anObserverObject])
		{
			[self.observationDescriptors removeObject:observationDescriptor];
		}
	}
}

- (void)sendObserverCallbacksForMessage:(LFXMessage *)message
{
	for (LFXMessageObservationDescriptor *observationDescriptor in self.observationDescriptors.copy)
	{
		observationDescriptor.callback(message);
	}
}

@end
