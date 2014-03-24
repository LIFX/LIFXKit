//
//  LFXGCDFunction.h
//  LIFX
//
//  Created by Nick Forge on 18/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

void LFXRunBlockWithDelay(NSTimeInterval delayInSeconds, void (^block)(void));
