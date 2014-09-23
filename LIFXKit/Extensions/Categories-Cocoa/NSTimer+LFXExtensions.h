//
//  NSTimer+LFXExtensions.h
//  LIFXKit
//
//  Created by Nick Forge on 16/07/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (LFXExtensions)

+ (NSTimer *)lfx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)())block;

@end
