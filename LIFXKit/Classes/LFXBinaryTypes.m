//
//  LFXBinaryTypes.m
//  LIFX SDK
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXBinaryTypes.h"
#import "LXProtocol.h"
#import "LFXHSBKColor.h"

uint16_t LFXProtocolPowerLevelFromLFXPowerState(LFXPowerState powerState)
{
	switch (powerState)
	{
		case LFXPowerStateOff:	return 0;
		case LFXPowerStateOn:	return 1;
	}
}

LFXPowerState LFXPowerStateFromLFXProtocolPowerLevel(uint16_t powerLevel)
{
	if (powerLevel == 0)
	{
		return LFXPowerStateOff;
	}
	else
	{
		return LFXPowerStateOn;
	}
}

NSTimeInterval NSTimeIntervalFromLFXProtocolDuration(uint32_t duration)
{
	return (NSTimeInterval)duration / 1000.0;
}

uint32_t LFXProtocolDurationFromNSTimeInterval(NSTimeInterval timeInterval)
{
	return timeInterval * 1000.0;
}

NSDate *NSDateFromLFXProtocolUnixTime(uint64_t protocolUnixTime)
{
	return [[NSDate alloc] initWithTimeIntervalSince1970:(double)protocolUnixTime / (double) NSEC_PER_SEC];
}

uint64_t LFXProtocolUnixTimeFromNSDate(NSDate *date)
{
	return date.timeIntervalSince1970 * (double) NSEC_PER_SEC;
}

LFXHSBKColor *LFXHSBKColorFromLXProtocolLightHsbk(LXProtocolLightHsbk *protocolHsbk)
{
	LFXHSBKColor *color = [LFXHSBKColor new];
	color.hue = (float) protocolHsbk.hue * 360.0 / (float) UINT16_MAX;
	color.saturation = (float) protocolHsbk.saturation / (float) UINT16_MAX;
	color.brightness = (float) protocolHsbk.brightness / (float) UINT16_MAX;
	color.kelvin = protocolHsbk.kelvin;
	return color;
}

LXProtocolLightHsbk *LXProtocolLightHsbkFromLFXHSBKColor(LFXHSBKColor *color)
{
	LXProtocolLightHsbk *lightHSBK = [LXProtocolLightHsbk new];
	lightHSBK.hue = (uint16_t)(color.hue / 360.0 * (float)UINT16_MAX);
	lightHSBK.saturation = (uint16_t)(color.saturation * (float)UINT16_MAX);
	lightHSBK.brightness = (uint16_t)(color.brightness * (float)UINT16_MAX);
	lightHSBK.kelvin = color.kelvin;
	return lightHSBK;
}
