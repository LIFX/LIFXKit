//
//  LFXSiteID.h
//  LIFX
//
//  Created by Nick Forge on 13/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


// LFXSiteID instances are immutable

@interface LFXSiteID : NSObject <NSCopying>

// The canonical representation of a Site ID is a hex string. This is the form
// used in the LIFX Cloud API.
+ (LFXSiteID *)siteIDWithString:(NSString *)siteIDString;
- (NSString *)stringValue;


// The LIFX Protocol uses 6-bytes to represent a Site ID
+ (LFXSiteID *)siteIDWithData:(NSData *)data;
- (NSData *)dataValue;


// When a device hasn't been added to a site yet, it will have a 'zero' Site ID.
+ (LFXSiteID *)zeroSiteID;
- (BOOL)isZeroSite;


// A shorter string representation - useful for logging and diagnostics
- (NSString *)debugStringValue;

@end
