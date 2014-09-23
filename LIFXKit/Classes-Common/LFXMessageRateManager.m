//
//  LFXMessageRateManager.m
//  LIFXKit
//
//  Created by Nick Forge on 22/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXMessageRateManager.h"
#import "LIFXKit.h"
#import "LFXNetworkContext.h"
#import "LFXLightCollection.h"
#import "LFXLight.h"
#import "LFXMacros.h"
#import "LFXObserverProxy.h"

@interface LFXMessageRateManager () <LFXLightCollectionObserver, LFXLightObserver>

@property (nonatomic) NSTimeInterval messageRate;

@property (nonatomic) LFXObserverProxy <LFXMessageRateManagerObserver> *messageRateManagerObserverProxy;

@end

@implementation LFXMessageRateManager

- (id)initWithNetworkContext:(LFXNetworkContext *)networkContext
{
	if ((self = [super init]))
	{
		[self updateMessageRate];
		_messageRateManagerObserverProxy = LFXCreateObserverProxy(LFXMessageRateManagerObserver);
		_networkContext = networkContext;
	}
	return self;
}

- (void)dealloc
{
	for (LFXLight *aLight in _networkContext.allLightsCollection)
	{
		[aLight removeLightObserver:self];
	}
	[_networkContext.allLightsCollection removeLightCollectionObserver:self];
}

- (void)startObserving
{
	[_networkContext.allLightsCollection addLightCollectionObserver:self];
	for (LFXLight *aLight in _networkContext.allLightsCollection)
	{
		[aLight addLightObserver:self];
	}
	[self updateMessageRate];
}

- (void)addMessageRateObserver:(id <LFXMessageRateManagerObserver>)observer
{
	[self.messageRateManagerObserverProxy addObserver:observer];
}

- (void)removeMessageRateObserver:(id <LFXMessageRateManagerObserver>)observer
{
	[self.messageRateManagerObserverProxy removeObserver:observer];
}


#pragma mark - LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
	[light addLightObserver:self];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
	[light removeLightObserver:self];
}


#pragma mark - LFXLightObserver

- (void)light:(LFXLight *)light didChangeMeshFirmwareVersion:(NSString *)meshFirmwareVersion
{
	[self updateMessageRate];
}

- (void)light:(LFXLight *)light didChangeWifiFirmwareVersion:(NSString *)wifiFirmwareVersion
{
	[self updateMessageRate];
}


- (void)updateMessageRate
{
	int oldFWCount = 0;
	int unknownFWCount = 0;
	int newFWCount = 0;
	
	for (LFXLight *aLight in self.networkContext.allLightsCollection)
	{
		if (aLight.meshFirmwareVersion == nil || aLight.wifiFirmwareVersion == nil)
		{
			unknownFWCount ++;
		}
		else
		{
			if ([@"1.1" compare:aLight.meshFirmwareVersion options:NSNumericSearch] == NSOrderedAscending &&
				[@"1.1" compare:aLight.wifiFirmwareVersion options:NSNumericSearch] == NSOrderedAscending)
			{
				newFWCount ++;
			}
			else
			{
				oldFWCount ++;
			}
		}
	}
		
	NSTimeInterval const kSlowMessageRate = 0.2;
	NSTimeInterval const kFastMessageRate = 0.05;
	
	NSTimeInterval newMessageRate;
	if (unknownFWCount > 0)
	{
		newMessageRate = kSlowMessageRate;
	}
	else if (oldFWCount > 0)
	{
		newMessageRate = kSlowMessageRate;
	}
	else if (newFWCount > 0)
	{
		newMessageRate = kFastMessageRate;
	}
	else	// There are no devices visible
	{
		newMessageRate = kSlowMessageRate;
	}
	
	LFXLogVerbose(@"Message Rate: %0.0fms  (FW versions: %i > 1.1, %i = 1.1, %i = unknown)", newMessageRate * 1000.0, newFWCount, oldFWCount, unknownFWCount);
	
	if (newMessageRate == self.messageRate) return;
	self.messageRate = newMessageRate;
	[self.messageRateManagerObserverProxy messageRateManager:self didChangeMessageRate:newMessageRate];
}

@end
