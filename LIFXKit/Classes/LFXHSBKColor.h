//
//  LFXHSBKColor.h
//  LIFX
//
//  Created by Nick Forge on 13/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define LFXHSBKColorMaxHue			360.0
#define LFXHSBKColorDefaultKelvin	3500

@interface LFXHSBKColor : NSObject <NSCopying>

+ (LFXHSBKColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness kelvin:(uint16_t)kelvin;

// Convenience factory method with default Kelvin value (3500)
+ (LFXHSBKColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness;



@property (nonatomic) CGFloat hue;			// [0, 360]
@property (nonatomic) CGFloat saturation;	// [0, 1]
@property (nonatomic) CGFloat brightness;	// [0, 1]
@property (nonatomic) uint16_t kelvin;		// [0, 10,000]

// Returns YES if saturation = 0.0;
- (BOOL)isWhite;


// The conversion from HSBK to UIColor is currently quite crude - e.g. the Kelvin component is ignored
- (UIColor *)UIColor;


- (NSString *)stringValue;	// "HSBK: (0.1, 0.4, 0.2, 5000)"


// Note: the algorithm used to "average" an array of colors isn't always very perceptually accurate
+ (LFXHSBKColor *)averageOfColors:(NSArray *)colors;	// <colors> is an array of LFXHSBKColors

@end
