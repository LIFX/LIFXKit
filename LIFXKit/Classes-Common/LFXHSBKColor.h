//
//  LFXHSBKColor.h
//  LIFX
//
//  Created by Nick Forge on 13/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


// Ranges of HSBK components

extern CGFloat const LFXHSBKColorMinHue;			// 0.0
extern CGFloat const LFXHSBKColorMaxHue;			// 360.0

extern CGFloat const LFXHSBKColorMinSaturation;		// 0.0
extern CGFloat const LFXHSBKColorMaxSaturation;		// 1.0

extern CGFloat const LFXHSBKColorMinBrightness;		// 0.0
extern CGFloat const LFXHSBKColorMaxBrightness;		// 1.0

extern uint16_t const LFXHSBKColorMinKelvin;		// 2500
extern uint16_t const LFXHSBKColorMaxKelvin;		// 9000

extern uint16_t const LFXHSBKColorDefaultKelvin;	// 3500



@interface LFXHSBKColor : NSObject <NSCopying>

+ (LFXHSBKColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness kelvin:(uint16_t)kelvin;

// Convenience factory method with default Kelvin value (3500)
+ (LFXHSBKColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness;

// Convenience factory method for whites (hue and saturation will be set to 0.0)
+ (LFXHSBKColor *)whiteColorWithBrightness:(CGFloat)brightness kelvin:(uint16_t)kelvin;


// Limits are also available as constants above
@property (nonatomic) CGFloat hue;			// [0, 360]
@property (nonatomic) CGFloat saturation;	// [0, 1]
@property (nonatomic) CGFloat brightness;	// [0, 1]
@property (nonatomic) uint16_t kelvin;		// [2500, 9000]

// Returns YES if saturation = 0.0;
- (BOOL)isWhite;

// Returns a copy of the color, with the brightness component modified
- (LFXHSBKColor *)colorWithBrightness:(CGFloat)brightnessComponent;


- (NSString *)stringValue;	// "HSBK: (0.1, 0.4, 0.2, 5000)"


// Note: the algorithm used to "average" an array of colors isn't always very perceptually accurate
+ (LFXHSBKColor *)averageOfColors:(NSArray *)colors;	// <colors> is an array of LFXHSBKColors

@end
