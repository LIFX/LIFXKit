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

@interface LFXTransportManager ()

@property (nonatomic) NSMutableArray *observationDescriptors;

@property (nonatomic) BOOL isConnected;

@end

@implementation LFXTransportManager

- (instancetype)init
{
	if ((self = [super init]))
	{
		_observationDescriptors = [NSMutableArray new];
	}
	return self;
}

- (void)connect
{
	LFXLogImplementMethod();
}

- (void)disconnect
{
	LFXLogImplementMethod();
}

- (void)sendMessage:(LFXMessage *)message
{
	LFXLogImplementMethod();
}

- (void)setIsConnected:(BOOL)isConnected
{
	if (_isConnected == isConnected) return;
	
	_isConnected = isConnected;
	
	if (isConnected)
	{
		[self.delegate transportManagerDidConnect:self];
	}
	else
	{
		[self.delegate transportManagerDidDisconnect:self];
	}
}


//=======================================================================
//
#pragma mark - Observers
//
//=======================================================================

// Token Based subscriptions
- (id)addMessageObserverWithCallback:(LFXMessageObserverCallback)callback
{
	LFXMessageObservationDescriptor *observationDescriptor = [LFXMessageObservationDescriptor new];
	observationDescriptor.callback = callback;
	[self.observationDescriptors addObject:observationDescriptor];
	return observationDescriptor;
}

- (void)removeMessageObserverToken:(id)observerToken
{
	[self.observationDescriptors removeObject:observerToken];
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
