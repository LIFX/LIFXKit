//
//  UIColor+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 13/10/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "UIColor+LFXExtensions.h"

@implementation UIColor (LFXExtensions)

+ (UIColor *)lfx_colorWithHexString:(NSString *)hexString
{
	return [UIColor lfx_colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)lfx_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
	NSString *cleanedHexString = [hexString characterAtIndex:0] == '#' ? [hexString substringFromIndex:1] : hexString;
	
	NSAssert([cleanedHexString length] == 1 || [cleanedHexString length] == 2 || [cleanedHexString length] == 3 || [cleanedHexString length] == 6 || [cleanedHexString length] == 8, @"Hex string should be 1, 2, 3, 6 or 8 characters long (with an optional '#' at the front)");
	
	unsigned long int rgbColorValue = strtoul([cleanedHexString cStringUsingEncoding:NSASCIIStringEncoding], NULL, 16);
	
	uint8_t redValue;
	uint8_t greenValue;
	uint8_t blueValue;
	uint8_t alphaValue = 255.0 * alpha;
	
	if ([cleanedHexString length] == 8) {	// This denotes RGBA, where the last component is alpha
		redValue   = (rgbColorValue >> 24) & 0xFF;
		greenValue = (rgbColorValue >> 16) & 0xFF;
		blueValue  = (rgbColorValue >>  8) & 0xFF;
		alphaValue = (rgbColorValue >>  0) & 0xFF;
	}
	else if ([cleanedHexString length] == 6) {
		redValue   = (rgbColorValue >> 16) & 0xFF;
		greenValue = (rgbColorValue >>  8) & 0xFF;
		blueValue  = (rgbColorValue >>  0) & 0xFF;
	}
	else if ([cleanedHexString length] == 3) {	// translate "123" to "112233"
		redValue   = ((rgbColorValue >> 8) & 0xF) * 0x11;
		greenValue = ((rgbColorValue >> 4) & 0xF) * 0x11;
		blueValue  = ((rgbColorValue >> 0) & 0xF) * 0x11;
	}
	else if ([cleanedHexString length] == 2) {	// translate "12" to "121212"
		redValue	= rgbColorValue;
		greenValue	= rgbColorValue;
		blueValue	= rgbColorValue;
	}
	else {	// translate "1" to "111111"
		redValue	= rgbColorValue * 0x11;
		greenValue	= rgbColorValue * 0x11;
		blueValue	= rgbColorValue * 0x11;
	}
	
	return [UIColor colorWithRed:((CGFloat) redValue / 255.0) green:((CGFloat) greenValue / 255.0) blue:((CGFloat) blueValue / 255.0) alpha:((CGFloat) alphaValue / 255.0)];
}

// Based on http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
+ (UIColor *)lfx_colorWithKelvin:(float)kelvin brightness:(float)brightness
{
	float red, green, blue = 0.0;
	
	if (kelvin <= 6600)
	{
		red = 1.0;
	}
	else
	{
		red = 1.292936186062745 * powf(kelvin / 100.0 - 60.0, -0.1332047592);
	}
	
	if (kelvin <= 6600)
	{
		green = 0.39008157876902 * logf(kelvin / 100.0) - 0.631841443788627;
	}
	else
	{
		green = 1.129890860895294 * powf(kelvin / 100.0 - 60.0, -0.0755148492);
	}
	
	if (kelvin >= 6600)
	{
		blue = 1.0;
	}
	else
	{
		if (kelvin <= 1900)
		{
			blue = 0.0;
		}
		else
		{
			blue = 0.543206789110196 * logf(kelvin / 100.0 - 10.0) - 1.19625408914;
		}
	}
	
	if (red < 0.0) red = 0.0;
	if (red > 1.0) red = 1.0;
	if (green < 0.0) green = 0.0;
	if (green > 1.0) green = 1.0;
	if (blue < 0.0) blue = 0.0;
	if (blue > 1.0) blue = 1.0;
	
	red *= brightness;
	green *= brightness;
	blue *= brightness;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
