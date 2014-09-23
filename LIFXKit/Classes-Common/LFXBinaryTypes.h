//
//  LFXBinaryTypes.h
//  LIFX SDK
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXTypes.h"
#import "LXProtocol.h"


/*
 
 Contains types used in the LIFX Binary Protocol
 
 */


// Tag Fields

typedef uint64_t tagField_t;


// Protocol Power Level (0-65535) <-> LFXPowerState
uint16_t LFXProtocolPowerLevelFromLFXPowerState(LFXPowerState powerState);
LFXPowerState LFXPowerStateFromLFXProtocolPowerLevel(uint16_t powerLevel);

// Protocol Duration (ms) <-> NSTimeInterval
NSTimeInterval NSTimeIntervalFromLFXProtocolDuration(uint32_t duration);
uint32_t LFXProtocolDurationFromNSTimeInterval(NSTimeInterval timeInterval);


// Protocol Unix Time (ns) <-> NSDate
NSDate *NSDateFromLFXProtocolUnixTime(uint64_t protocolUnixTime);
uint64_t LFXProtocolUnixTimeFromNSDate(NSDate *date);

// Firmware Versions
NSString *NSStringFromLFXProtocolFirmwareVersionUInt32(uint32_t version);
NSDate *NSDateFromLFXProtocolFirmwareBuild(uint64_t build);


// Protocol HSBK Color (LXProtocolLightHsbk) <-> LFXHSBKColor
LFXHSBKColor *LFXHSBKColorFromLXProtocolLightHsbk(LXProtocolLightHsbk *protocolHsbk);
LXProtocolLightHsbk *LXProtocolLightHsbkFromLFXHSBKColor(LFXHSBKColor *color);
