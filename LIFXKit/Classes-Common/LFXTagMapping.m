//
//  LFXTagMapping.m
//  LIFX
//
//  Created by Nick Forge on 5/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXTagMapping.h"
#import "LFXSiteID.h"
#import "LFXExtensions.h"

@implementation LFXTagMapping

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(tag), SelfKey(siteID), SelfKey(tagField)]];
}

- (BOOL)matchesSiteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField
{
	return tagField == self.tagField && [siteID isEqual:self.siteID];
}

- (BOOL)matchesTag:(NSString *)tag
{
	return [tag isEqualToString:self.tag];
}

@end
