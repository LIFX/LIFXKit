//
//  LFXRequestTask.h
//  LIFXKit
//
//  Created by Nick Forge on 17/05/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXLight, LFXRequestTaskBatch, LFXRequestTask, LFXMessage;

typedef NS_ENUM(NSInteger, LFXRequestTaskStatus) {
	LFXRequestTaskStatusNotStarted,
	LFXRequestTaskStatusRunning,
	LFXRequestTaskStatusSuccess,
	LFXRequestTaskStatusFail,
};

typedef NS_ENUM(NSInteger, LFXTaskBlockReturnStatus) {
	LFXTaskBlockReturnStatusSuccess,
	LFXTaskBlockReturnStatusSendSet,
	LFXTaskBlockReturnStatusSendGet,
};


typedef LFXTaskBlockReturnStatus(^LFXRequestTaskBlock)(LFXRequestTask *task);
typedef void(^LFXRequestTaskCompletionBlock)(LFXRequestTask *task);
typedef void(^LFXRequestTaskBatchCompletionBlock)(LFXRequestTaskBatch *taskBatch);



@interface LFXRequestTask : NSObject

+ (instancetype)taskWithLight:(LFXLight *)light getMessage:(LFXMessage *)getMessage setMessage:(LFXMessage *)setMessage taskBlock:(LFXRequestTaskBlock)taskBlock;

@property (nonatomic) LFXLight *light;

@property (nonatomic) LFXRequestTaskStatus taskStatus;

@property (nonatomic) LFXMessage *setMessage;
@property (nonatomic) LFXMessage *getMessage;



@property (nonatomic, copy) LFXRequestTaskCompletionBlock completionBlock;

// The .taskBlock will be run periodically while until the task is complete
@property (nonatomic, copy) LFXRequestTaskBlock taskBlock;

- (void)startTask;

@end




@interface LFXRequestTaskBatch : NSObject

+ (instancetype)taskBatchWithTasks:(NSArray *)tasks;

@property (nonatomic, readonly) NSArray *tasks;

- (void)addTask:(LFXRequestTask *)task;

@property (nonatomic, copy) LFXRequestTaskBatchCompletionBlock completionBlock;

- (NSArray *)tasksForTaskStatus:(LFXRequestTaskStatus)taskStatus;

- (void)startTasks;

@end