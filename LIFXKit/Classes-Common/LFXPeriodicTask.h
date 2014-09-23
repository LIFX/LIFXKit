//
//  LFXPeriodicTask.h
//  LIFXKit
//
//  Created by Nick Forge on 17/05/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXDevice;

extern NSTimeInterval const LFXPeriodicTaskInterval; // 5s

typedef void(^LFXPeriodicTaskBlock)(LFXDevice *device);

@interface LFXPeriodicTask : NSObject

+ (instancetype)taskWithTaskID:(NSString *)taskID runsWhenDeviceIsUnreachable:(BOOL)runsWhenDeviceIsUnreachable taskBlock:(LFXPeriodicTaskBlock)taskBlock;

@property (nonatomic, readonly) NSString *taskID;

@property (nonatomic, readonly, copy) LFXPeriodicTaskBlock taskBlock;

@property (nonatomic, readonly) BOOL runsWhenDeviceIsUnreachable;

@end
