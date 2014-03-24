//
//  LFXTypes.h
//  LIFX
//
//  Created by Nick Forge on 23/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXHSBKColor, LFXTarget;

// Device Reachability

typedef NS_ENUM(NSUInteger, LFXDeviceReachability) {
	LFXDeviceReachabilityReachable,
	LFXDeviceReachabilityUnreachable,
};


// Power States

typedef NS_ENUM(NSUInteger, LFXFuzzyPowerState) {
	LFXFuzzyPowerStateOff = 0,
	LFXFuzzyPowerStateOn = 1,
	LFXFuzzyPowerStateMixed = 2,
};

typedef NS_ENUM(NSUInteger, LFXPowerState) {
	LFXPowerStateOff = 0,
	LFXPowerStateOn = 1,
};


// LFXPowerState <-> LFXFuzzyPowerState <-> NSString Conversions
LFXFuzzyPowerState LFXFuzzyPowerStateFromPowerState(LFXPowerState powerState);

NSString *NSStringFromLFXPowerState(LFXPowerState powerState);
NSString *NSStringFromLFXFuzzyPowerState(LFXFuzzyPowerState fuzzyPowerState);



// Light Targets

@protocol LFXLightTarget <NSObject>

- (LFXTarget *)target;

- (NSArray *)lights;	// Returns all of the lights "in" the target

// Light State
- (NSString *)label;
- (LFXHSBKColor *)color;
- (LFXFuzzyPowerState)fuzzyPowerState;

// Light Control
- (void)setLabel:(NSString *)label;
- (void)setColor:(LFXHSBKColor *)color;
- (void)setColor:(LFXHSBKColor *)color overDuration:(NSTimeInterval)duration;
- (void)setPowerState:(LFXPowerState)powerState;

@end

