//
//  LFXLight.m
//  LIFX
//
//  Created by Nick Forge on 12/12/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXLight.h"
#import "LXProtocol.h"
#import "LFXNetworkContext+Private.h"
#import "LFXLight+Private.h"
#import "LFXBinaryTypes.h"
#import "LFXExtensions.h"
#import "LFXHSBKColor.h"
#import "LFXObserverProxy.h"

@interface LFXLight ()

@property (nonatomic) LFXTarget *target;

@property (nonatomic) NSString *label;
@property (nonatomic) LFXHSBKColor *color;
@property (nonatomic) LFXPowerState powerState;

@property (nonatomic) NSDate *mostRecentMessageTimestamp;

@property (nonatomic) LFXObserverProxy <LFXLightObserver> *lightObserverProxy;

@property (nonatomic) NSDate *timeStampOfLastLightSet;

@end

@implementation LFXLight

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(deviceID), SelfKey(label), SelfKey(color), SelfKey(powerState), SelfKey(tags)]];
}

- (void)lfx_setLabel:(NSString *)label
{
	if ([label isEqual:_label]) return;
	
	[self willChangeValueForKey:SelfKey(label)];
	_label = label;
	[self didChangeValueForKey:SelfKey(label)];
	[self.lightObserverProxy light:self didChangeLabel:label];
}

- (void)lfx_setColor:(LFXHSBKColor *)color
{
	if ([color isEqual:_color]) return;
	
	[self willChangeValueForKey:SelfKey(color)];
	_color = color;
	[self didChangeValueForKey:SelfKey(color)];
	[self.lightObserverProxy light:self didChangeColor:color];
}

- (void)lfx_setPowerState:(LFXPowerState)powerState
{
	if (powerState == _powerState) return;
	
	[self willChangeValueForKey:SelfKey(powerState)];
	_powerState = powerState;
	[self didChangeValueForKey:SelfKey(powerState)];
	[self.lightObserverProxy light:self didChangePowerState:powerState];
}

- (LFXDeviceReachability)reachability
{
	if ([self.mostRecentMessageTimestamp lfx_timeIntervalUpToNow] < 35) return LFXDeviceReachabilityReachable;
	return LFXDeviceReachabilityUnreachable;
}

- (NSArray *)lights
{
	return @[self];
}

- (LFXFuzzyPowerState)fuzzyPowerState
{
	return LFXFuzzyPowerStateFromPowerState(self.powerState);
}

- (void)setLabel:(NSString *)label
{
	LFXMessageDeviceSetLabel *setLabel = [LFXMessageDeviceSetLabel messageWithTarget:self.target];
	setLabel.payload.label = label;
	[self.networkContext sendMessage:setLabel];
}

- (void)setColor:(LFXHSBKColor *)color
{
	[self setColor:color overDuration:0.25];
}

- (void)setColor:(LFXHSBKColor *)color overDuration:(NSTimeInterval)duration
{
	LFXMessageLightSet *lightSet = [LFXMessageLightSet messageWithTarget:self.target];
	lightSet.payload.color = LXProtocolLightHsbkFromLFXHSBKColor(color);
	lightSet.payload.duration = LFXProtocolDurationFromNSTimeInterval(duration);
	[self.networkContext sendMessage:lightSet];
}

- (void)setPowerState:(LFXPowerState)powerState
{
	LFXMessageDeviceSetPower *setPower = [LFXMessageDeviceSetPower messageWithTarget:self.target];
	setPower.payload.level = LFXProtocolPowerLevelFromLFXPowerState(powerState);
	[self.networkContext sendMessage:setPower];
}

- (void)addLightObserver:(id <LFXLightObserver>)observer
{
	[self.lightObserverProxy addObserver:observer];
}

- (void)removeLightObserver:(id <LFXLightObserver>)observer
{
	[self.lightObserverProxy removeObserver:observer];
}

@end

@implementation LFXLight (Private)

+ (instancetype)lightWithDeviceID:(NSString *)deviceID networkContext:(LFXNetworkContext *)networkContext;
{
	LFXLight *light = [LFXLight new];
	light->_deviceID = deviceID;
	light->_target = [LFXTarget deviceTargetWithDeviceID:deviceID];
	light->_networkContext = networkContext;
	light->_lightObserverProxy = LFXCreateObserverProxy(LFXLightObserver);
	light->_tags = @[];
	light->_taggedCollections = @[];
	return light;
}

- (void)handleMessage:(LFXMessage *)message
{
	if (message.isAResponseMessage)
	{
		self.mostRecentMessageTimestamp = [NSDate new];
	}
	switch (message.messageType)
	{
		case LX_PROTOCOL_LIGHT_SET:
		{
			self.timeStampOfLastLightSet = [NSDate new];
			LFXMessageLightSet *lightSet = CastObject(LFXMessageLightSet, message);
			[self lfx_setColor:LFXHSBKColorFromLXProtocolLightHsbk(lightSet.payload.color)];
			break;
		}
		case LX_PROTOCOL_LIGHT_STATE:
		{
			if (self.timeStampOfLastLightSet != nil && ([self.timeStampOfLastLightSet lfx_timeIntervalUpToNow] < 3.0))
			{
				LFXLogVerbose(@"Ignoring LightState for %@ due to set/get timing overlap (overlap = %0.2fs)", self, [self.timeStampOfLastLightSet lfx_timeIntervalUpToNow]);
			}
			else
			{
				LFXMessageLightState *lightState = CastObject(LFXMessageLightState, message);
				[self lfx_setLabel:lightState.payload.label];
				[self lfx_setColor:LFXHSBKColorFromLXProtocolLightHsbk(lightState.payload.color)];
				[self lfx_setPowerState:LFXPowerStateFromLFXProtocolPowerLevel(lightState.payload.power)];
			}
			break;
		}
		case LX_PROTOCOL_DEVICE_SET_LABEL:
		{
			LFXMessageDeviceSetLabel *setLabel = CastObject(LFXMessageDeviceSetLabel, message);
			[self lfx_setLabel:setLabel.payload.label];
			break;
		}
		case LX_PROTOCOL_DEVICE_STATE_LABEL:
		{
			LFXMessageDeviceStateLabel *stateLabel = CastObject(LFXMessageDeviceStateLabel, message);
			[self lfx_setLabel:stateLabel.payload.label];
			break;
		}
		case LX_PROTOCOL_DEVICE_SET_POWER:
		{
			LFXMessageDeviceSetPower *setPower = CastObject(LFXMessageDeviceSetPower, message);
			[self lfx_setPowerState:LFXPowerStateFromLFXProtocolPowerLevel(setPower.payload.level)];
			break;
		}
		case LX_PROTOCOL_DEVICE_STATE_POWER:
		{
			LFXMessageDeviceStatePower *statePower = CastObject(LFXMessageDeviceStatePower, message);
			[self lfx_setPowerState:LFXPowerStateFromLFXProtocolPowerLevel(statePower.payload.level)];
			break;
		}
		default:
			break;
	}
}

- (void)lfx_setTags:(NSArray *)tags
{
	if ([tags isEqualToArray:_tags]) return;
	[self willChangeValueForKey:SelfKey(tags)];
	_tags = tags;
	[self didChangeValueForKey:SelfKey(tags)];
}

- (void)lfx_setTaggedCollections:(NSArray *)taggedCollections
{
	if ([taggedCollections isEqualToArray:_taggedCollections]) return;
	[self willChangeValueForKey:SelfKey(taggedCollections)];
	_taggedCollections = taggedCollections;
	[self didChangeValueForKey:SelfKey(taggedCollections)];
}

- (void)setColor:(LFXHSBKColor *)color overDuration:(NSTimeInterval)duration atTime:(NSDate *)atTime
{
	LFXMessageLightSet *lightSet = [LFXMessageLightSet messageWithTarget:self.target];
	lightSet.payload.color = LXProtocolLightHsbkFromLFXHSBKColor(color);
	lightSet.payload.duration = LFXProtocolDurationFromNSTimeInterval(duration);
	lightSet.atTime = LFXProtocolUnixTimeFromNSDate(atTime);
	[self.networkContext sendMessage:lightSet];
}

@end


