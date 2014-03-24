//
//  LFXDeviceMapping.h
//  LIFX
//
//  Created by Nick Forge on 5/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXTypes.h"
#import "LFXBinaryTypes.h"
@class LFXSiteID;

@interface LFXDeviceMapping : NSObject

@property (nonatomic) NSString *deviceID;

@property (nonatomic) LFXSiteID *siteID;
@property (nonatomic) tagField_t tagField;	// The tagField indicating what tags the device belongs to in the context of .siteID


// This is used for uniqueing in the routing table within a Network Context
- (BOOL)matchesDeviceID:(NSString *)deviceID;


@end
