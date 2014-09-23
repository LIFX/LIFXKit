//
//  LFXLightCollection+Private.h
//  LIFX SDK
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

@class LFXObserverProxy, LFXMessage;
@protocol LFXLightCollectionObserver;


@interface LFXLightCollection (Private)

+ (instancetype)lightCollectionWithNetworkContext:(LFXNetworkContext *)networkContext;

- (void)handleMessage:(LFXMessage *)message;

- (void)lfx_addLight:(LFXLight *)light;
- (void)lfx_removeLight:(LFXLight *)light;
- (void)lfx_removeAllLights;

@property (nonatomic, readonly) LFXObserverProxy <LFXLightCollectionObserver> *lightCollectionObserverProxy;

@end