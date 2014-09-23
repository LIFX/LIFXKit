//
//  LFXPeriodicTask.m
//  LIFXKit
//
//  Created by Nick Forge on 17/05/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXPeriodicTask.h"
#import "NSObject+LFXExtensions.h"
#import "LFXMacros.h"

NSTimeInterval const LFXPeriodicTaskInterval = 5.0;

@implementation LFXPeriodicTask

+ (instancetype)taskWithTaskID:(NSString *)taskID runsWhenDeviceIsUnreachable:(BOOL)runsWhenDeviceIsUnreachable taskBlock:(LFXPeriodicTaskBlock)taskBlock
{
	LFXPeriodicTask *task = [LFXPeriodicTask new];
	task->_taskID = taskID;
	task->_taskBlock = [taskBlock copy];
	task->_runsWhenDeviceIsUnreachable = runsWhenDeviceIsUnreachable;
	return task;
}

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(taskID)]];
}

@end
