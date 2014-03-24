//
//  LFXHSBKColor.m
//  LIFX
//
//  Created by Nick Forge on 13/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXHSBKColor.h"

@implementation LFXHSBKColor

- (id)init
{
	if ((self = [super init]))
	{
		self.hue = 0.0;
		self.saturation = 0.0;
		self.brightness = 1.0;
		self.kelvin = LFXHSBKColorDefaultKelvin;
	}
	return self;
}

+ (LFXHSBKColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness kelvin:(uint16_t)kelvin
{
	LFXHSBKColor *color = [LFXHSBKColor new];
	color.hue = hue;
	color.saturation = saturation;
	color.brightness = brightness;
	color.kelvin = kelvin;
	return color;
}

+ (LFXHSBKColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness
{
	return [self colorWithHue:hue saturation:saturation brightness:brightness kelvin:3500];
}

+ (LFXHSBKColor *)averageOfColors:(NSArray *)colors
{
	if (colors.count == 0)
	{
		return nil;
	}
	
	CGFloat hueXTotal = 0;
	CGFloat hueYTotal = 0;
	CGFloat saturationTotal = 0;
	CGFloat brightnessTotal = 0;
	uint32_t kelvinTotal = 0;
	
	for (LFXHSBKColor *aColor in colors)
	{
		hueXTotal += sin(aColor.hue * 2.0 * M_PI / LFXHSBKColorMaxHue);
		hueYTotal += cos(aColor.hue * 2.0 * M_PI / LFXHSBKColorMaxHue);
		saturationTotal += aColor.saturation;
		brightnessTotal += aColor.brightness;
		kelvinTotal += aColor.kelvin ?: 3500;
	}
	
	CGFloat hue = atan2(hueXTotal, hueYTotal) / (2.0 * M_PI);
	if (hue < 0.0) hue += 1.0;
	hue *= LFXHSBKColorMaxHue;
	CGFloat saturation = saturationTotal / (CGFloat) colors.count;
	CGFloat brightness = brightnessTotal / (CGFloat) colors.count;
	uint16_t kelvin = kelvinTotal / colors.count;
	
	return [LFXHSBKColor colorWithHue:hue saturation:saturation brightness:brightness kelvin:kelvin];
}

- (id)copyWithZone:(NSZone *)zone
{
	LFXHSBKColor *newColor = [[self class] new];
	newColor.hue = self.hue;
	newColor.saturation = self.saturation;
	newColor.brightness = self.brightness;
	newColor.kelvin = self.kelvin;
	return newColor;
}

- (BOOL)isEqual:(id)object
{
	if (![object isKindOfClass:[LFXHSBKColor class]]) return NO;
	LFXHSBKColor *colorObject = object;
	if (colorObject.hue != self.hue ||
		colorObject.saturation != self.saturation ||
		colorObject.brightness != self.brightness ||
		colorObject.kelvin != self.kelvin) return NO;
	return YES;
}

- (NSString *)description
{
	return self.stringValue;
}

- (NSString *)stringValue
{
	return [NSString stringWithFormat:@"hsbk(%0.2f, %0.2f, %0.2f, %hu)", self.hue, self.saturation, self.brightness, self.kelvin];
}

- (UIColor *)UIColor
{
	return [UIColor colorWithHue:self.hue / LFXHSBKColorMaxHue saturation:self.saturation brightness:self.brightness alpha:1.0];
}

- (BOOL)isWhite
{
	return self.saturation <= FLT_MIN;
}

@end
