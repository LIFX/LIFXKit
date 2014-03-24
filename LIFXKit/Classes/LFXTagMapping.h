//
//  LFXTagMapping.h
//  LIFX
//
//  Created by Nick Forge on 5/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXTypes.h"
#import "LFXBinaryTypes.h"
@class LFXSiteID;

@interface LFXTagMapping : NSObject

@property (nonatomic) NSString *tag;

@property (nonatomic) LFXSiteID *siteID;
@property (nonatomic) tagField_t tagField;

// Use this for uniqueing a TagMapping
- (BOOL)matchesSiteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField;

// Use this for routing outgoing messages
- (BOOL)matchesTag:(NSString *)tag;

@end
