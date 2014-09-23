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

NSString *NSStringFromLFXProtocolFirmwareVersionUInt32(uint32_t version)
{
	uint16_t majorVersion = (version & 0xffff0000) >> 16;
	uint16_t minorVersion = (version & 0xffff);
	return [NSString stringWithFormat:@"%hu.%hu", majorVersion, minorVersion];
}

NSDate *NSDateFromLFXProtocolFirmwareBuild(uint64_t build)
{
	// The way that the old and new encodings on the firmware builds were represented means that we can
	// tell which encoding was used by using a simple comparison.
	
	if (build > 1200000000000000000)
	{	// Modern build timestamp representation
		return NSDateFromLFXProtocolUnixTime(build);
	}
	
	// Legacy build timestamp representation
	uint8_t *buildBytes = (uint8_t *)&build;
	NSDateComponents *components = [NSDateComponents new];
	components.year = 2000 + buildBytes[7];
	components.day = buildBytes[3];
	components.hour = buildBytes[2];
	components.minute = buildBytes[1];
	components.second = buildBytes[0];
	
	char month[4];
	month[0] = buildBytes[6];
	month[1] = buildBytes[5];
	month[2] = buildBytes[4];
	month[3] = 0;
	NSDictionary *monthDict = @{@"Jan": @1, @"Feb": @2, @"Mar": @3, @"Apr": @4, @"May": @5, @"Jun": @6, @"Jul": @7, @"Aug": @8, @"Sep": @9, @"Oct": @10, @"Nov": @11, @"Dec": @12};
	components.month = [monthDict[@(month)] integerValue];
	
	return [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] dateFromComponents:components];
}


LFXHSBKColor *LFXHSBKColorFromLXProtocolLightHsbk(LXProtocolLightHsbk *protocolHsbk)
{
	LFXHSBKColor *color = [LFXHSBKColor new];
	color.hue = (float) protocolHsbk.hue * LFXHSBKColorMaxHue / (float) UINT16_MAX;
	color.saturation = (float) protocolHsbk.saturation / (float) UINT16_MAX;
	color.brightness = (float) protocolHsbk.brightness / (float) UINT16_MAX;
	color.kelvin = protocolHsbk.kelvin;
	return color;
}

LXProtocolLightHsbk *LXProtocolLightHsbkFromLFXHSBKColor(LFXHSBKColor *color)
{
	LXProtocolLightHsbk *lightHSBK = [LXProtocolLightHsbk new];
	lightHSBK.hue = (uint16_t)(color.hue / LFXHSBKColorMaxHue * (float)UINT16_MAX);
	lightHSBK.saturation = (uint16_t)(color.saturation * (float)UINT16_MAX);
	lightHSBK.brightness = (uint16_t)(color.brightness * (float)UINT16_MAX);
	lightHSBK.kelvin = color.kelvin;
	return lightHSBK;
}
