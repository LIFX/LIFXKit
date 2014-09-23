//
//  LFXMessageRateManager.h
//  LIFXKit
//
//  Created by Nick Forge on 22/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXNetworkContext;
@protocol LFXMessageRateManagerObserver;

@interface LFXMessageRateManager : NSObject

- (id)initWithNetworkContext:(LFXNetworkContext *)networkContext;
- (void)startObserving;	// Call this after the .networkContext stack has been setup

@property (nonatomic, readonly) LFXNetworkContext *networkContext;

@property (nonatomic, readonly) NSTimeInterval messageRate;

- (void)addMessageRateObserver:(id <LFXMessageRateManagerObserver>)observer;
- (void)removeMessageRateObserver:(id <LFXMessageRateManagerObserver>)observer;

@end


@protocol LFXMessageRateManagerObserver <NSObject>

- (void)messageRateManager:(LFXMessageRateManager *)manager didChangeMessageRate:(NSTimeInterval)messageRate;

@end