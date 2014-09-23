//
//  LFXExtensions+NSTimer.m
//  LIFXKit
//
//  Created by Nick Forge on 16/07/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "NSTimer+LFXExtensions.h"

static NSString * kBlockUserInfoKey = @"block";
static NSString * kHelperUserInfoKey = @"helper";

// LFXTimerHelper exists purely as a receiver for the timer fire message (you can't set the target and selector after initialisation,
// so you can't use the NSTimer itself)

@interface LFXTimerHelper : NSObject

@end

@implementation LFXTimerHelper

- (void)timerWithBlockDidFire:(NSTimer *)timer
{
	void (^block)() = timer.userInfo[kBlockUserInfoKey];
	block();
}

@end


@implementation NSTimer (LFXExtensions)

+ (NSTimer *)lfx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)())block
{
	LFXTimerHelper *timerHelper = [LFXTimerHelper new];
	NSDictionary *userInfo = @{kBlockUserInfoKey: [block copy], kHelperUserInfoKey: timerHelper};
	return [NSTimer scheduledTimerWithTimeInterval:interval target:timerHelper selector:@selector(timerWithBlockDidFire:) userInfo:userInfo repeats:repeats];
}

@end
