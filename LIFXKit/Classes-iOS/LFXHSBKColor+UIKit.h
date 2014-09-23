//
//  LFXHSBKColor+UIKit.h
//  LIFXKit
//
//  Created by Chris Miles on 22/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFXHSBKColor.h"

@interface LFXHSBKColor (UIKit)

// The conversion from HSBK to UIColor is currently quite crude - e.g. the Kelvin component is ignored
- (UIColor *)UIColor;

@end
