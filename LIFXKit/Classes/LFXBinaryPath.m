//
//  LFXBinaryPath.m
//  LIFX
//
//  Created by Nick Forge on 14/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXBinaryPath.h"
#import "LFXExtensions.h"
#import "LFXSiteID.h"
#import "LFXBinaryTargetID.h"

@implementation LFXBinaryPath

+ (LFXBinaryPath *)pathWithString:(NSString *)string
{
	NSArray *components = [string componentsSeparatedByString:@"/"];
	if (components.count != 2)
	{
		LFXLogError(@"Error: Path doesn't contain 2 elements separated by a '/': %@", string);
		return nil;
	}
	
	NSString *siteString = components[0];
	NSString *targetString = components[1];
	return [LFXBinaryPath pathWithSiteID:[LFXSiteID siteIDWithString:siteString] targetID:[LFXBinaryTargetID targetIDWithString:targetString]];
}

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(stringValue)]];
}

- (NSString *)stringValue
{
	return [NSString stringWithFormat:@"%@/%@", self.siteID.stringValue, self.targetID.stringValue];
}

+ (LFXBinaryPath *)pathWithSiteID:(LFXSiteID *)siteID targetID:(LFXBinaryTargetID *)targetID
{
	LFXBinaryPath *path = [LFXBinaryPath new];
	path->_siteID = siteID;
	path->_targetID = targetID;
	return path;
}

+ (LFXBinaryPath *)broadcastBinaryPathWithSiteID:(LFXSiteID *)siteID
{
	return [self pathWithSiteID:siteID targetID:[LFXBinaryTargetID broadcastTargetID]];
}

- (BOOL)isEqual:(id)object
{
	if (![object isKindOfClass:[LFXBinaryPath class]]) return NO;
	if (![((LFXBinaryPath *)object).targetID isEqual:self.targetID]) return NO;
	if (![((LFXBinaryPath *)object).siteID isEqual:self.siteID]) return NO;
	return YES;
}

- (NSUInteger)hash
{
	return self.targetID.hash ^ self.siteID.hash;
}

- (id)copyWithZone:(NSZone *)zone
{
	LFXBinaryPath *newPath = [LFXBinaryPath new];
	newPath->_siteID = self.siteID;
	newPath->_targetID = self.targetID;
	return newPath;
}

- (NSString *)debugStringValue
{
	return [NSString stringWithFormat:@"%@/%@", self.siteID.debugStringValue, self.targetID.debugStringValue];
}

@end
