//
//  LFXAdHocLightCollection.m
//  LIFXKit
//
//  Created by Nick Forge on 20/06/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXAdHocLightCollection.h"
#import "LFXLightCollection+Private.h"
#import "LFXLight.h"
#import "LFXObserverProxy.h"
#import "LFXTarget.h"
#import "NSArray+LFXExtensions.h"

@interface LFXAdHocLightCollection ()

@property (nonatomic) LFXTarget *target;

@property (nonatomic) NSString *label;

@end

@implementation LFXAdHocLightCollection

- (LFXTarget *)target
{
	// This is kinda hacky, but works around the fact that there's no easy hook for the factory method
	// that we _should_ use to call -updateTarget (which would ensure that there's always a valid .target)
	if (_target == nil) [self updateTarget];
	return _target;
}

- (void)updateTarget
{
	self.target = [LFXTarget compositeTargetWithTargets:[self.lights lfx_arrayByMapping:^id(LFXLight *light) {return light.target;}]];
}

- (BOOL)labelIsEditable
{
	return YES;
}

- (void)addLight:(LFXLight *)light
{
	[self lfx_addLight:light];
	[self updateTarget];
}

- (void)removeLight:(LFXLight *)light
{
	[self lfx_removeLight:light];
	[self updateTarget];
}

- (void)removeAllLights
{
	[self lfx_removeAllLights];
}

- (void)setLabel:(NSString *)label
{
	_label = label;
	[self.lightCollectionObserverProxy lightCollection:self didChangeLabel:label];
}

- (void)setColor:(LFXHSBKColor *)color
{
	[self setColor:color overDuration:0.25];
}

- (void)setColor:(LFXHSBKColor *)color overDuration:(NSTimeInterval)duration
{
	for (LFXLight *aLight in self)
	{
		[aLight setColor:color overDuration:duration];
	}
}

- (void)setPowerState:(LFXPowerState)powerState
{
	for (LFXLight *aLight in self)
	{
		[aLight setPowerState:powerState];
	}
}

@end
