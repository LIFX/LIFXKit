//
//  LFXLight.h
//  LIFX
//
//  Created by Nick Forge on 12/12/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXNetworkContext;
@protocol LFXLightObserver;
#import "LFXDevice.h"
#import "LFXTypes.h"


@interface LFXLight : LFXDevice <LFXLightTarget>

// Tags
@property (nonatomic, readonly) NSArray /* NSString */ *tags;
@property (nonatomic, readonly) NSArray /* LFXTaggedLightCollection */ *taggedCollections;


// Most of these Light State and Light Control methods are declared in LFXLightTarget,
// so you can use the same methods on both LFXLight and LFXLightCollection objects.

// Light State
- (NSString *)label;
- (LFXHSBKColor *)color;
- (LFXPowerState)powerState;
- (LFXFuzzyPowerState)fuzzyPowerState;


// Light Control
- (void)setLabel:(NSString *)label;
- (void)setColor:(LFXHSBKColor *)color;
- (void)setColor:(LFXHSBKColor *)color overDuration:(NSTimeInterval)duration;
- (void)setPowerState:(LFXPowerState)powerState;


// Firmware Versions
- (NSString *)meshFirmwareVersion;
- (NSString *)wifiFirmwareVersion;
- (BOOL)meshFirmwareVersionIsAtLeast:(NSString *)version;
- (BOOL)wifiFirmwareVersionIsAtLeast:(NSString *)version;


// Observers
- (void)addLightObserver:(id <LFXLightObserver>)observer;
- (void)removeLightObserver:(id <LFXLightObserver>)observer;

@end


@protocol LFXLightObserver <NSObject>

@optional
- (void)light:(LFXLight *)light didChangeLabel:(NSString *)label;
- (void)light:(LFXLight *)light didChangeColor:(LFXHSBKColor *)color;
- (void)light:(LFXLight *)light didChangePowerState:(LFXPowerState)powerState;
- (void)light:(LFXLight *)light didChangeReachability:(LFXDeviceReachability)reachability;

- (void)light:(LFXLight *)light didChangeMeshFirmwareVersion:(NSString *)meshFirmwareVersion;
- (void)light:(LFXLight *)light didChangeWifiFirmwareVersion:(NSString *)wifiFirmwareVersion;

@end

