//
//  LFXDevice.h
//  LIFXKit
//
//  Created by Nick Forge on 16/05/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXNetworkContext;
#import "LFXTypes.h"

@interface LFXDevice : NSObject

@property (nonatomic, readonly, weak) LFXNetworkContext *networkContext;
@property (nonatomic, readonly) NSString *deviceID;
@property (nonatomic, readonly) LFXDeviceReachability reachability;

@end
