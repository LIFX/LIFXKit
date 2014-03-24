//
//  LFXGatewayDiscoveryTableEntry.h
//  LIFX
//
//  Created by Nick Forge on 13/10/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXGatewayDescriptor.h"

@interface LFXGatewayDiscoveryTableEntry : NSObject

@property (nonatomic) LFXGatewayDescriptor *gatewayDescriptor;
@property (nonatomic) NSDate *lastDiscoveryResponseDate;	// this is the date of the last DeviceStatePanGateway message corresponding to this gateway

@end
