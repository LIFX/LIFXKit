//
//  LFXHSBKColor+UIKit.m
//  LIFXKit
//
//  Created by Chris Miles on 22/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXHSBKColor+UIKit.h"

@implementation LFXHSBKColor (UIKit)

- (UIColor *)UIColor
{
    return [UIColor colorWithHue:self.hue / LFXHSBKColorMaxHue saturation:self.saturation brightness:self.brightness alpha:1.0];
}

@end
