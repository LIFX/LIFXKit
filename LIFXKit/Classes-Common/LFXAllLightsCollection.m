//
//  LFXAllLightsCollection.m
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXAllLightsCollection.h"
#import "LXProtocol.h"
#import "LFXNetworkContext+Private.h"
#import "LFXBinaryTypes.h"

@interface LFXAllLightsCollection ()

@property (nonatomic, readonly) LFXTarget *target;

@end

@implementation LFXAllLightsCollection

- (NSString *)label
{
	return @"All Lights";
}

- (LFXTarget *)target
{
	return [LFXTarget broadcastTarget];
}

// Setters

- (void)setLabel:(NSString *)label
{
	NSLog(@"Error: you can't change the label on an All Lights Collection");
}

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

@end
