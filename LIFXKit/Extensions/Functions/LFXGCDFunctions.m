//
//  LFXGCDFunction.m
//  LIFX
//
//  Created by Nick Forge on 18/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXGCDFunctions.h"

void LFXRunBlockWithDelay(NSTimeInterval delayInSeconds, void (^block)(void))
{
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), block);
}

