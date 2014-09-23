//
//  LFXLightCollection.h
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXTypes.h"
@class LFXNetworkContext, LFXLight, LFXHSBKColor;
@protocol LFXLightCollectionObserver;

@interface LFXLightCollection : NSObject <LFXLightTarget, NSFastEnumeration>

@property (nonatomic, readonly, weak) LFXNetworkContext *networkContext;


@property (nonatomic, readonly) NSArray /* LFXLight */ *lights;

// Query Methods (these will often be faster than performing the same actions on the result of -lights)
- (BOOL)containsLight:(LFXLight *)light;
- (LFXLight *)lightForDeviceID:(NSString *)deviceID;

// note: There may be more than one light with a particular label
- (LFXLight *)firstLightForLabel:(NSString *)label;
- (NSArray /* LFXLight */ *)lightsForLabel:(NSString *)label;



// Light State
- (NSString *)label;
- (LFXHSBKColor *)color;
- (LFXFuzzyPowerState)fuzzyPowerState;

// Light Control
- (void)setLabel:(NSString *)label;
- (void)setColor:(LFXHSBKColor *)color;
- (void)setColor:(LFXHSBKColor *)color overDuration:(NSTimeInterval)duration;
- (void)setPowerState:(LFXPowerState)powerState;


// Observers
- (void)addLightCollectionObserver:(id <LFXLightCollectionObserver>)observer;
- (void)removeLightCollectionObserver:(id <LFXLightCollectionObserver>)observer;

@end



@protocol LFXLightCollectionObserver <NSObject>

@optional

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light;
- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light;

- (void)lightCollection:(LFXLightCollection *)lightCollection didChangeLabel:(NSString *)label;
- (void)lightCollection:(LFXLightCollection *)lightCollection didChangeColor:(LFXHSBKColor *)color;
- (void)lightCollection:(LFXLightCollection *)lightCollection didChangeFuzzyPowerState:(LFXFuzzyPowerState)fuzzyPowerState;

@end
