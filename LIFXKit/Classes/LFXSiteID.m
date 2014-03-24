//
//  LFXSiteID.m
//  LIFX
//
//  Created by Nick Forge on 13/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXSiteID.h"
#import "LFXExtensions.h"

#define LFXSiteIDNumberOfBytes 6

@interface LFXSiteID ()
{
	uint8_t _bytes[LFXSiteIDNumberOfBytes];
}

@end

@implementation LFXSiteID

+ (LFXSiteID *)siteIDWithString:(NSString *)siteIDString
{
	NSData *data = [NSData lfx_dataWithHexString:siteIDString];
	return [LFXSiteID siteIDWithData:data];
}

- (NSString *)stringValue
{
	if (self.isZeroSite) return @"*";
	return [lfx_NSDataWithPointer(_bytes) lfx_hexStringValue];
}


+ (LFXSiteID *)siteIDWithData:(NSData *)data
{
	if (data.length != LFXSiteIDNumberOfBytes)
	{
		LFXLogError(@"Site ID doesn't have %d bytes: %@", LFXSiteIDNumberOfBytes, data);
	}
	
	LFXSiteID *siteID = [LFXSiteID new];
	[data getBytes:siteID->_bytes length:LFXSiteIDNumberOfBytes];
	return siteID;
}

- (NSData *)dataValue
{
	return lfx_NSDataWithPointer(_bytes);
}


+ (LFXSiteID *)zeroSiteID
{
	uint8_t bytes[LFXSiteIDNumberOfBytes] = {0,0,0,0,0,0};
	return [self siteIDWithData:lfx_NSDataWithPointer(bytes)];
}


- (NSString *)debugStringValue
{
	return self.stringValue.lfx_stringByRemovingLIFXOUI;
}

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(debugStringValue)]];
}


- (BOOL)isZeroSite
{
	uint8_t bytes[LFXSiteIDNumberOfBytes] = {0,0,0,0,0,0};
	return memcmp(bytes, _bytes, sizeof(_bytes)) == 0;
}

#pragma mark - NSObject

- (NSUInteger)hash
{
	// Note - if NSUInteger is smaller than _bytes (which is the case on 32-bit platforms),
	// this may be a poor quality hash function.
	NSUInteger hash = 0;
	memcpy(&hash, _bytes, MAX(sizeof(_bytes), sizeof(NSUInteger)));
	return hash;
}

- (BOOL)isEqual:(id)object
{
	if (![object isKindOfClass:[LFXSiteID class]]) return NO;
	if (memcmp(_bytes, ((LFXSiteID *)object)->_bytes, LFXSiteIDNumberOfBytes) != 0) return NO;
	return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

@end
