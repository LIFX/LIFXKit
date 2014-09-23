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
#import "LFXDevice+Private.h"
#import "LFXPeriodicTask.h"
#import "NSDate+LFXExtensions.h"

NSTimeInterval const kSetStateMessageOverlapTime = 3.0;

@interface LFXLight ()

@property (nonatomic) LFXTarget *target;

@property (nonatomic) NSString *label;
@property (nonatomic) LFXHSBKColor *color;
@property (nonatomic) LFXPowerState powerState;

@property (nonatomic) NSString *meshFirmwareVersion;
@property (nonatomic) NSString *wifiFirmwareVersion;
@property (nonatomic) NSDate *meshFirmwareBuild;
@property (nonatomic) NSDate *wifiFirmwareBuild;

@property (nonatomic) LFXObserverProxy <LFXLightObserver> *lightObserverProxy;

@end

@implementation LFXLight

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(deviceID), SelfKey(label), SelfKey(color), SelfKey(powerState), SelfKey(tags), SelfKey(clockDelta)]];
}

- (void)didChangeReachability:(LFXDeviceReachability)reachability
{
	[self.lightObserverProxy light:self didChangeReachability:reachability];
}

- (void)lfx_updateLabel
{
	NSString *label = [self propertyValueForKey:SelfKey(label)];
	if ([label isEqual:_label]) return;
	
	[self willChangeValueForKey:SelfKey(label)];
	_label = label;
	[self didChangeValueForKey:SelfKey(label)];
	[self.lightObserverProxy light:self didChangeLabel:label];
}

- (void)lfx_updateColor
{
	LFXHSBKColor *color = [self propertyValueForKey:SelfKey(color)];
	if ([color isEqual:_color]) return;
	
	[self willChangeValueForKey:SelfKey(color)];
	_color = color;
	[self didChangeValueForKey:SelfKey(color)];
	[self.lightObserverProxy light:self didChangeColor:color];
}

- (void)lfx_updatePowerState
{
	LFXPowerState powerState = [[self propertyValueForKey:SelfKey(powerState)] integerValue];
	if (powerState == _powerState) return;
	
	[self willChangeValueForKey:SelfKey(powerState)];
	_powerState = powerState;
	[self didChangeValueForKey:SelfKey(powerState)];
	[self.lightObserverProxy light:self didChangePowerState:powerState];
}

- (void)lfx_updateMeshFirmwareVersion
{
	NSString *meshFirmwareVersion = [self propertyValueForKey:SelfKey(meshFirmwareVersion)];
	if ([meshFirmwareVersion isEqualToString:_meshFirmwareVersion]) return;
	
	self.meshFirmwareVersion = meshFirmwareVersion;
	[self.lightObserverProxy light:self didChangeMeshFirmwareVersion:meshFirmwareVersion];
}

- (void)lfx_updateWifiFirmwareVersion
{
	NSString *wifiFirmwareVersion = [self propertyValueForKey:SelfKey(wifiFirmwareVersion)];
	if ([wifiFirmwareVersion isEqualToString:_wifiFirmwareVersion]) return;
	
	self.wifiFirmwareVersion = wifiFirmwareVersion;
	[self.lightObserverProxy light:self didChangeWifiFirmwareVersion:wifiFirmwareVersion];
}

- (BOOL)meshFirmwareVersionIsAtLeast:(NSString *)version
{
	return self.meshFirmwareVersion != nil && [self.meshFirmwareVersion compare:version options:NSNumericSearch] != NSOrderedAscending;
}

- (BOOL)wifiFirmwareVersionIsAtLeast:(NSString *)version
{
	return self.wifiFirmwareVersion != nil && [self.wifiFirmwareVersion compare:version options:NSNumericSearch] != NSOrderedAscending;
}

- (NSDate *)meshFirmwareBuild
{
	return [self propertyValueForKey:SelfKey(meshFirmwareBuild)];
}

- (NSDate *)wifiFirmwareBuild
{
	return [self propertyValueForKey:SelfKey(wifiFirmwareBuild)];
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

- (void)addLightObserver:(id <LFXLightObserver>)observer
{
	[self.lightObserverProxy addObserver:observer];
}

- (void)removeLightObserver:(id <LFXLightObserver>)observer
{
	[self.lightObserverProxy removeObserver:observer];
}

- (BOOL)labelIsEditable
{
	return YES;
}

@end

@implementation LFXLight (Private)

+ (instancetype)lightWithDeviceID:(NSString *)deviceID networkContext:(LFXNetworkContext *)networkContext;
{
	LFXLight *light = [LFXLight new];
	light.networkContext = networkContext;
	light.deviceID = deviceID;
	light->_target = [LFXTarget deviceTargetWithDeviceID:deviceID];
	light->_lightObserverProxy = LFXCreateObserverProxy(LFXLightObserver);
	light->_tags = @[];
	light->_taggedCollections = @[];
	[light addScanTasks];
	return light;
}

- (void)addScanTasks
{
	[self addPeriodicTask:[LFXPeriodicTask taskWithTaskID:@"Get LightState" runsWhenDeviceIsUnreachable:NO taskBlock:^(LFXDevice *device) {
		LFXLight *light = CastObject(LFXLight, device);
		if ([light bestPropertySourceForKey:SelfKey(color)] != LFXPropertySourceDevice || [[light propertyTimestampForKey:SelfKey(color) source:LFXPropertySourceDevice] lfx_timeIntervalUpToNow] > 25.0)
		{
			[light.networkContext sendMessage:[LFXMessageLightGet messageWithTarget:light.target]];
		}
	}]];
	[self addPeriodicTask:[LFXPeriodicTask taskWithTaskID:@"Get Mesh Firmware" runsWhenDeviceIsUnreachable:NO taskBlock:^(LFXDevice *device) {
		LFXLight *light = CastObject(LFXLight, device);
		if ([light bestPropertySourceForKey:SelfKey(meshFirmwareVersion)] != LFXPropertySourceDevice || [[light propertyTimestampForKey:SelfKey(meshFirmwareVersion) source:LFXPropertySourceDevice] lfx_timeIntervalUpToNow] > lfx_NSTimeIntervalWithMinutes(10))
		{
			[light.networkContext sendMessage:[LFXMessageDeviceGetMeshFirmware messageWithTarget:light.target qosPriority:LFXMessageQosPriorityLow]];
		}
	}]];
	[self addPeriodicTask:[LFXPeriodicTask taskWithTaskID:@"Get Wifi Firmware" runsWhenDeviceIsUnreachable:NO taskBlock:^(LFXDevice *device) {
		LFXLight *light = CastObject(LFXLight, device);
		if ([light bestPropertySourceForKey:SelfKey(wifiFirmwareVersion)] != LFXPropertySourceDevice || [[light propertyTimestampForKey:SelfKey(wifiFirmwareVersion) source:LFXPropertySourceDevice] lfx_timeIntervalUpToNow] > lfx_NSTimeIntervalWithMinutes(10))
		{
			[light.networkContext sendMessage:[LFXMessageDeviceGetWifiFirmware messageWithTarget:light.target qosPriority:LFXMessageQosPriorityLow]];
		}
	}]];
	[self addPeriodicTask:[LFXPeriodicTask taskWithTaskID:@"Get Time" runsWhenDeviceIsUnreachable:NO taskBlock:^(LFXDevice *device) {
		LFXLight *light = CastObject(LFXLight, device);
		if ([light bestPropertySourceForKey:SelfKey(clockDelta)] != LFXPropertySourceDevice || [[light propertyTimestampForKey:SelfKey(clockDelta) source:LFXPropertySourceDevice] lfx_timeIntervalUpToNow] > lfx_NSTimeIntervalWithMinutes(1))
		{
			[light queryClock];
		}
	}]];
}

- (void)handleMessage:(LFXMessage *)message
{
	[super handleMessage:message];
	switch (message.messageType)
	{
		case LX_PROTOCOL_LIGHT_SET_COLOR:
		{
			LFXMessageLightSetColor *lightSetColor = CastObject(LFXMessageLightSetColor, message);
			
			[self setPropertyValue:LFXHSBKColorFromLXProtocolLightHsbk(lightSetColor.payload.color) forKey:SelfKey(color) source:LFXPropertySourceClient];
			[self lfx_updateColor];
			
			break;
		}
		case LX_PROTOCOL_LIGHT_STATE:
		{
			LFXMessageLightState *lightState = CastObject(LFXMessageLightState, message);
			
			[self setPropertyValue:lightState.payload.label forKey:SelfKey(label) source:LFXPropertySourceDevice];
			[self lfx_updateLabel];

			[self setPropertyValue:LFXHSBKColorFromLXProtocolLightHsbk(lightState.payload.color) forKey:SelfKey(color) source:LFXPropertySourceDevice];
			[self lfx_updateColor];

			[self setPropertyValue:@(LFXPowerStateFromLFXProtocolPowerLevel(lightState.payload.power)) forKey:SelfKey(powerState) source:LFXPropertySourceDevice];
			[self lfx_updatePowerState];

			if (lightState.payload.dim != 0)
			{
				[self clearDimValue];
			}
			
			break;
		}
		case LX_PROTOCOL_DEVICE_SET_LABEL:
		{
			LFXMessageDeviceSetLabel *setLabel = CastObject(LFXMessageDeviceSetLabel, message);
			
			[self setPropertyValue:setLabel.payload.label forKey:SelfKey(label) source:LFXPropertySourceClient];
			[self lfx_updateLabel];
			
			break;
		}
		case LX_PROTOCOL_DEVICE_STATE_LABEL:
		{
			LFXMessageDeviceStateLabel *stateLabel = CastObject(LFXMessageDeviceStateLabel, message);
			
			[self setPropertyValue:stateLabel.payload.label forKey:SelfKey(label) source:LFXPropertySourceDevice];
			[self lfx_updateLabel];
			
			break;
		}
		case LX_PROTOCOL_DEVICE_SET_POWER:
		{
			LFXMessageDeviceSetPower *setPower = CastObject(LFXMessageDeviceSetPower, message);
			
			[self setPropertyValue:@(LFXPowerStateFromLFXProtocolPowerLevel(setPower.payload.level)) forKey:SelfKey(powerState) source:LFXPropertySourceClient];
			[self lfx_updatePowerState];
			
			break;
		}
		case LX_PROTOCOL_DEVICE_STATE_POWER:
		{
			LFXMessageDeviceStatePower *statePower = CastObject(LFXMessageDeviceStatePower, message);
			
			[self setPropertyValue:@(LFXPowerStateFromLFXProtocolPowerLevel(statePower.payload.level)) forKey:SelfKey(powerState) source:LFXPropertySourceDevice];
			[self lfx_updatePowerState];
			
			break;
		}
		case LX_PROTOCOL_DEVICE_STATE_MESH_FIRMWARE:
		{
			LFXMessageDeviceStateMeshFirmware *meshFirmware = CastObject(LFXMessageDeviceStateMeshFirmware, message);
			
			[self setPropertyValue:NSStringFromLFXProtocolFirmwareVersionUInt32(meshFirmware.payload.version) forKey:SelfKey(meshFirmwareVersion) source:LFXPropertySourceDevice];
			[self lfx_updateMeshFirmwareVersion];
			
			[self setPropertyValue:NSDateFromLFXProtocolFirmwareBuild(meshFirmware.payload.build) forKey:SelfKey(meshFirmwareBuild) source:LFXPropertySourceDevice];
			
			break;
		}
		case LX_PROTOCOL_DEVICE_STATE_WIFI_FIRMWARE:
		{
			LFXMessageDeviceStateWifiFirmware *wifiFirmware = CastObject(LFXMessageDeviceStateWifiFirmware, message);
			
			[self setPropertyValue:NSStringFromLFXProtocolFirmwareVersionUInt32(wifiFirmware.payload.version) forKey:SelfKey(wifiFirmwareVersion) source:LFXPropertySourceDevice];
			[self lfx_updateWifiFirmwareVersion];
			
			[self setPropertyValue:NSDateFromLFXProtocolFirmwareBuild(wifiFirmware.payload.build) forKey:SelfKey(wifiFirmwareBuild) source:LFXPropertySourceDevice];
			
			break;
		}
		default:
			break;
	}
}

- (void)clearDimValue
{
	LFXMessageLightSetDimAbsolute *setDimAbsolute = [LFXMessageLightSetDimAbsolute messageWithTarget:self.target];
	setDimAbsolute.payload.brightness = 0;
	[self.networkContext sendMessage:setDimAbsolute];
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
	LFXMessageLightSetColor *lightSetColor = [LFXMessageLightSetColor messageWithTarget:self.target];
	lightSetColor.payload.color = LXProtocolLightHsbkFromLFXHSBKColor(color);
	lightSetColor.payload.duration = LFXProtocolDurationFromNSTimeInterval(duration);
	lightSetColor.atTime = LFXProtocolUnixTimeFromNSDate(atTime);
	[self.networkContext sendMessage:lightSetColor];
}

@end


