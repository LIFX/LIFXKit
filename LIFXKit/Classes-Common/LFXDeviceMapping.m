//
//  LFXDeviceMapping.m
//  LIFX
//
//  Created by Nick Forge on 5/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXDeviceMapping.h"
#import "LFXExtensions.h"

@implementation LFXDeviceMapping

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(deviceID), SelfKey(siteID), SelfKey(tagField)]];
}

- (BOOL)matchesDeviceID:(NSString *)deviceID
{
	return [self.deviceID isEqualToString:deviceID];
}

@end
