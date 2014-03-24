//
//  LFXBinaryPath.h
//  LIFX
//
//  Created by Nick Forge on 14/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXSiteID, LFXBinaryTargetID;

@interface LFXBinaryPath : NSObject <NSCopying>

+ (LFXBinaryPath *)pathWithString:(NSString *)string;
- (NSString *)stringValue;


+ (LFXBinaryPath *)pathWithSiteID:(LFXSiteID *)siteID targetID:(LFXBinaryTargetID *)targetID;

// Convenience Factory
+ (LFXBinaryPath *)broadcastBinaryPathWithSiteID:(LFXSiteID *)siteID;

@property (nonatomic, readonly) LFXSiteID *siteID;
@property (nonatomic, readonly) LFXBinaryTargetID *targetID;


- (NSString *)debugStringValue;

@end
