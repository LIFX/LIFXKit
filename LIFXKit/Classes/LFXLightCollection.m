//
//  LFXLightCollection.m
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXLightCollection.h"
#import "LFXLightCollection+Private.h"
#import "LFXNetworkContext.h"
#import "LFXLight.h"
#import "LFXMessage.h"
#import "LFXExtensions.h"
#import "LFXHSBKColor.h"
#import "LFXObserverProxy.h"

@interface LFXLightCollection () <LFXLightObserver>

@property (nonatomic) NSMutableArray *lfx_lights;

@property (nonatomic) LFXFuzzyPowerState fuzzyPowerState;
@property (nonatomic) LFXHSBKColor *color;

@property (nonatomic) LFXObserverProxy <LFXLightCollectionObserver> *lightCollectionObserverProxy;

@end

@implementation LFXLightCollection

- (LFXTarget *)target
{
	LFXLogImplementMethod();
	return nil;
}

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(label)]];
}

- (LFXLight *)lightForDeviceID:(NSString *)deviceID
{
	return [self.lfx_lights lfx_firstObjectWhere:^BOOL(LFXLight *light) {
		return [light.deviceID isEqualToString:deviceID];
	}];
}

- (LFXLight *)firstLightForLabel:(NSString *)label
{
	return [self.lfx_lights lfx_firstObjectWhere:^BOOL(LFXLight *light) {
		return [light.label isEqualToString:label];
	}];
}

- (NSArray *)lightsForLabel:(NSString *)label
{
	return [self.lfx_lights lfx_allObjectsWhere:^BOOL(LFXLight *light) {
		return [light.label isEqualToString:label];
	}];
}


- (NSArray *)lights
{
	return self.lfx_lights.copy;
}

// Light State
- (NSString *)label
{
	LFXLogImplementMethod();
	return nil;
}

- (void)updateColor
{
	LFXHSBKColor *color = [self calculateColor];
	if ([color isEqual:_color]) return;
	
	[self willChangeValueForKey:SelfKey(color)];
	_color = color;
	[self didChangeValueForKey:SelfKey(color)];
	[self.lightCollectionObserverProxy lightCollection:self didChangeColor:color];
}

- (LFXHSBKColor *)calculateColor
{
	return [LFXHSBKColor averageOfColors:[self.lights lfx_arrayByMapping:^id(LFXLight *light) {
		return light.color;
	}]];
}

- (void)updateFuzzyPowerState
{
	LFXFuzzyPowerState fuzzyPowerState = [self calculateFuzzyPowerState];
	if (fuzzyPowerState == _fuzzyPowerState) return;
	
	[self willChangeValueForKey:SelfKey(fuzzyPowerState)];
	_fuzzyPowerState = fuzzyPowerState;
	[self didChangeValueForKey:SelfKey(fuzzyPowerState)];
	[self.lightCollectionObserverProxy lightCollection:self didChangeFuzzyPowerState:fuzzyPowerState];
}

- (LFXFuzzyPowerState)calculateFuzzyPowerState
{
	BOOL isOn = NO;
	BOOL isOff = NO;
	for (LFXLight *aLight in self.lights)
	{
		if (aLight.powerState == LFXPowerStateOff) isOff = YES;
		if (aLight.powerState == LFXPowerStateOn) isOn = YES;
	}
	if (isOn && isOff) return LFXFuzzyPowerStateMixed;
	if (isOn) return LFXFuzzyPowerStateOn;
	if (isOff) return LFXFuzzyPowerStateOff;
	return LFXFuzzyPowerStateOff;
}


// Light Control
- (void)setLabel:(NSString *)label
{
	LFXLogImplementMethod();
}

- (void)setColor:(LFXHSBKColor *)color
{
	LFXLogImplementMethod();
}

- (void)setColor:(LFXHSBKColor *)color overDuration:(NSTimeInterval)duration
{
	LFXLogImplementMethod();
}

- (void)setPowerState:(LFXPowerState)powerState
{
	LFXLogImplementMethod();
}

- (void)addLightCollectionObserver:(id <LFXLightCollectionObserver>)observer
{
	[self.lightCollectionObserverProxy addObserver:observer];
}

- (void)removeLightCollectionObserver:(id <LFXLightCollectionObserver>)observer
{
	[self.lightCollectionObserverProxy addObserver:observer];
}

#pragma mark - LFXLightObserver

- (void)light:(LFXLight *)light didChangeColor:(LFXHSBKColor *)color
{
	[self updateColor];
}

- (void)light:(LFXLight *)light didChangePowerState:(LFXPowerState)powerState
{
	[self updateFuzzyPowerState];
}

@end


@implementation LFXLightCollection (Private)

+ (instancetype)lightCollectionWithNetworkContext:(LFXNetworkContext *)networkContext
{
	LFXLightCollection *collection = [self new];
	collection->_networkContext = networkContext;
	collection->_lfx_lights = [NSMutableArray new];
	collection->_lightCollectionObserverProxy = LFXCreateObserverProxy(LFXLightCollectionObserver);
	[collection updateColor];
	[collection updateFuzzyPowerState];
	return collection;
}

- (void)handleMessage:(LFXMessage *)message
{
	LFXLogError(@"Light: %@ received message: %@", self, message);
}

- (void)lfx_addLight:(LFXLight *)light
{
	[self.lfx_lights addObject:light];
	[self.lightCollectionObserverProxy lightCollection:self didAddLight:light];
	[light addLightObserver:self];
	[self updateColor];
	[self updateFuzzyPowerState];
}

- (void)lfx_removeLight:(LFXLight *)light
{
	[self.lfx_lights removeObject:light];
	[self.lightCollectionObserverProxy lightCollection:self didRemoveLight:light];
	[light removeLightObserver:self];
}

- (void)lfx_removeAllLights
{
	[self.lfx_lights removeAllObjects];
}

@end