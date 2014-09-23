//
//  LFXLight+Private.h
//  LIFX SDK
//
//  Created by Nick Forge on 14/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

@class LFXMessage;


@interface LFXLight (Private)

+ (instancetype)lightWithDeviceID:(NSString *)deviceID networkContext:(LFXNetworkContext *)networkContext;

- (void)lfx_setTags:(NSArray *)tags;
- (void)lfx_setTaggedCollections:(NSArray *)taggedCollections;

- (void)setColor:(LFXHSBKColor *)color overDuration:(NSTimeInterval)duration atTime:(NSDate *)atTime;

@property (nonatomic, readonly) NSDate *meshFirmwareBuild;
@property (nonatomic, readonly) NSDate *wifiFirmwareBuild;

@end