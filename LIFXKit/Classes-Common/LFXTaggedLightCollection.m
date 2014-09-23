//
//  LFXTaggedLightCollection.m
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXTaggedLightCollection.h"
#import "LFXLightCollection+Private.h"
#import "LFXNetworkContext.h"
#import "LXProtocol.h"
#import "LFXNetworkContext+Private.h"
#import "LFXBinaryTypes.h"
#import "LFXExtensions.h"
#import "LFXRoutingTable.h"
#import "LFXObserverProxy.h"

@interface LFXTaggedLightCollection ()

@property (nonatomic, readonly) LFXTarget *target;

@end

@implementation LFXTaggedLightCollection

- (LFXTarget *)target
{
	return [LFXTarget tagTargetWithTag:self.tag];
}

- (void)addLight:(LFXLight *)light
{
	[self.networkContext addLight:light toTaggedLightCollection:self];
}

- (void)removeLight:(LFXLight *)light
{
	[self.networkContext removeLight:light fromTaggedLightCollection:self];
}

- (void)removeAllLights
{
	for (LFXLight *aLight in self)
	{
		[self removeLight:aLight];
	}
}

- (BOOL)renameWithNewTag:(NSString *)newTag
{
	BOOL success = [self.networkContext renameTaggedLightCollection:self withNewTag:newTag];
	if (success)
	{
		[self.lightCollectionObserverProxy lightCollection:self didChangeLabel:newTag];
	}
	return success;
}


// Getters

- (NSString *)label
{
	return self.tag;
}

// Setters

- (void)setColor:(LFXHSBKColor *)color
{
	[self setColor:color overDuration:0.25];
}

- (void)setColor:(LFXHSBKColor *)color overDuration:(NSTimeInterval)duration
{
	LFXMessageLightSetColor *lightSetColor = [LFXMessageLightSetColor messageWithTarget:self.target];
	lightSetColor.payload.color = LXProtocolLightHsbkFromLFXHSBKColor(color);
	lightSetColor.payload.duration = LFXProtocolDurationFromNSTimeInterval(duration);
	[self.networkContext sendMessage:lightSetColor];
}

- (void)setPowerState:(LFXPowerState)powerState
{
	LFXMessageDeviceSetPower *setPower = [LFXMessageDeviceSetPower messageWithTarget:self.target];
	setPower.payload.level = LFXProtocolPowerLevelFromLFXPowerState(powerState);
	[self.networkContext sendMessage:setPower];
}

- (void)setLabel:(NSString *)label
{
	[self renameWithNewTag:label];
}

@end


@implementation LFXTaggedLightCollection (Private)

- (void)setLfx_tag:(NSString *)tag
{
	_tag = tag;
}

@end