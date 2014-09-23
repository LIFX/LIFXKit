//
//  UIColor+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 13/10/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LFXExtensions)

+ (UIColor *)lfx_colorWithHexString:(NSString *)hexString;	// alpha = 1.0
+ (UIColor *)lfx_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

// Kelvin: ºK, Brightness: [0, 1]
+ (UIColor *)lfx_colorWithKelvin:(float)kelvin brightness:(float)brightness;

@end
