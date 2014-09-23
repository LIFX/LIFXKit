//
//  LFXRequestTask.m
//  LIFXKit
//
//  Created by Nick Forge on 17/05/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXRequestTask.h"
#import "NSArray+LFXExtensions.h"
#import "LFXMacros.h"
#import "LFXLight.h"
#import "LFXNetworkContext+Private.h"

NSInteger const LFXTaskBlockRetries = 10;
NSTimeInterval const LFXTaskBlockTimerInterval = 1.0;


@interface LFXRequestTask ()

@property (nonatomic) NSTimer *taskBlockTimer;
@property (nonatomic) NSInteger numberOfTaskBlockRetriesLeft;

@property (nonatomic) LFXRequestTaskBatch *taskBatch;

@end



@interface LFXRequestTaskBatch ()

@property (nonatomic) NSMutableArray *mutableTasks;

- (void)taskDidFinish:(LFXRequestTask *)task;

@end


@implementation LFXRequestTask

+ (instancetype)taskWithLight:(LFXLight *)light getMessage:(LFXMessage *)getMessage setMessage:(LFXMessage *)setMessage taskBlock:(LFXRequestTaskBlock)taskBlock
{
	LFXRequestTask *task = [LFXRequestTask new];
	task.light = light;
	task.taskBlock = taskBlock;
	task.getMessage = getMessage;
	task.setMessage = setMessage;
	return task;
}

- (void)startTask
{
	if (self.taskStatus != LFXRequestTaskStatusNotStarted)
	{
		LFXLogError(@"Error: can't start task when it's already started");
		return;
	}
	self.taskStatus = LFXRequestTaskStatusRunning;
	self.numberOfTaskBlockRetriesLeft = LFXTaskBlockRetries;
	self.taskBlockTimer = [NSTimer scheduledTimerWithTimeInterval:LFXTaskBlockTimerInterval target:self selector:@selector(taskBlockTimerDidFire) userInfo:nil repeats:YES];
}

- (void)taskBlockTimerDidFire
{
	self.numberOfTaskBlockRetriesLeft = self.numberOfTaskBlockRetriesLeft - 1;

	if (self.numberOfTaskBlockRetriesLeft == 0)
	{
		self.taskStatus = LFXRequestTaskStatusFail;
		[self didFinish];
		return;
	}
	
	LFXTaskBlockReturnStatus status = self.taskBlock(self);
	switch (status)
	{
		case LFXTaskBlockReturnStatusSuccess:
		{
			self.taskStatus = LFXRequestTaskStatusSuccess;
			[self didFinish];
			break;
		}
		case LFXTaskBlockReturnStatusSendGet:
		{
			[self.light.networkContext sendMessage:self.getMessage];
			break;
		}
		case LFXTaskBlockReturnStatusSendSet:
			[self.light.networkContext sendMessage:self.setMessage];
			break;
	}
}

- (void)didFinish
{
	LFXLogError(@"Request Task %@ did finish with status: %li", self, (long)self.taskStatus);
	[self.taskBlockTimer invalidate];
	if (self.completionBlock)
	{
		self.completionBlock(self);
	}
	if (self.taskBatch)
	{
		[self.taskBatch taskDidFinish:self];
	}
}

@end



@implementation LFXRequestTaskBatch

+ (instancetype)taskBatchWithTasks:(NSArray *)tasks
{
	LFXRequestTaskBatch *taskBatch = [LFXRequestTaskBatch new];
	taskBatch.mutableTasks = [NSMutableArray new];
	for (LFXRequestTask *aTask in tasks)
	{
		[taskBatch addTask:aTask];
	}
	return taskBatch;
}

- (NSArray *)tasks
{
	return self.mutableTasks;
}

- (void)addTask:(LFXRequestTask *)task
{
	[self.mutableTasks addObject:task];
	task.taskBatch = self;
}

- (void)taskDidFinish:(LFXRequestTask *)task
{
	for (LFXRequestTask *aTask in self.tasks)
	{
		if (aTask.taskStatus == LFXRequestTaskStatusRunning) return;
	}
	LFXLogError(@"Request Task Batch %@ did finish", self);
	[self didFinish];
}

- (NSArray *)tasksForTaskStatus:(LFXRequestTaskStatus)taskStatus
{
	return [self.tasks lfx_allObjectsWhere:^BOOL(LFXRequestTask *request) {
		return request.taskStatus == taskStatus;
	}];
}

- (void)startTasks
{
	for (LFXRequestTask *aTask in self.tasks)
	{
		[aTask startTask];
	}
}

- (void)didFinish
{
	if (self.completionBlock)
	{
		self.completionBlock(self);
	}
}

@end