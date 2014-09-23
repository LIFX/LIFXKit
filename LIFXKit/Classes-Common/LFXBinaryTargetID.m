//
//  LFXTarget.m
//  LIFX
//
//  Created by Nick Forge on 13/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXBinaryTargetID.h"
#import "LFXExtensions.h"

@interface LFXBinaryTargetID ()
{
	LFXBinaryTargetType _targetType;
	tagField_t _groupTagField;
	NSData *_deviceBytes;
}

@end

@implementation LFXBinaryTargetID

+ (LFXBinaryTargetID *)targetIDWithString:(NSString *)stringValue
{
	NSScanner *scanner = [NSScanner scannerWithString:stringValue];
	
	if ([scanner scanString:@"*" intoString:NULL]) return [LFXBinaryTargetID broadcastTargetID];
	
	if ([scanner scanString:@"#" intoString:NULL])
	{
		// Group Target (uint64 tagField)
		uint64_t tagField = 0;
		[scanner scanHexLongLong:&tagField];
		return [LFXBinaryTargetID groupTargetIDWithTagField:tagField];
	}
	else
	{
		// Device Target (6 bytes)
		return [LFXBinaryTargetID deviceTargetIDWithString:stringValue];
	}
}

- (NSString *)stringValue
{
	switch (_targetType)
	{
		case LFXBinaryTargetTypeBroadcast:
		{
			return @"*";
		}
		case LFXBinaryTargetTypeTag:
		{
			return [NSString stringWithFormat:@"#%llx", _groupTagField];
		}
		case LFXBinaryTargetTypeDevice:
		{
			return [_deviceBytes lfx_hexStringValue];
		}
	}
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<LFXBinaryTargetID %p> %@", self, self.debugStringValue];
}

- (LFXBinaryTargetType)targetType
{
	return _targetType;
}

+ (LFXBinaryTargetID *)deviceTargetIDWithData:(NSData *)data
{
	LFXBinaryTargetID *targetID = [LFXBinaryTargetID new];
	targetID->_targetType = LFXBinaryTargetTypeDevice;
	targetID->_deviceBytes = [data subdataWithRange:NSMakeRange(0, 6)];
	return targetID;
}

+ (LFXBinaryTargetID *)deviceTargetIDWithString:(NSString *)string
{
	NSData *data = [NSData lfx_dataWithHexString:string];
	return [LFXBinaryTargetID deviceTargetIDWithData:data];
}

- (NSData *)deviceDataValue
{
	return _deviceBytes;
}

+ (LFXBinaryTargetID *)groupTargetIDWithTagField:(tagField_t)tagField
{
	LFXBinaryTargetID *targetID = [LFXBinaryTargetID new];
	targetID->_targetType = tagField == 0 ? LFXBinaryTargetTypeBroadcast : LFXBinaryTargetTypeTag;
	targetID->_groupTagField = tagField;
	return targetID;
}

- (tagField_t)groupTagField
{
	return _groupTagField;
}


+ (LFXBinaryTargetID *)broadcastTargetID
{
	LFXBinaryTargetID *targetID = [LFXBinaryTargetID new];
	targetID->_targetType = LFXBinaryTargetTypeBroadcast;
	return targetID;
}

- (NSArray *)individualGroupTargetIDs
{
	// For future optimisation, this could get generated once, when a groupTargetID is created
	NSMutableArray *targetIDs = [NSMutableArray new];
	[LFXBinaryTargetID enumerateTagField:self.groupTagField block:^(tagField_t singularTagField) {
		[targetIDs addObject:[LFXBinaryTargetID groupTargetIDWithTagField:singularTagField]];
	}];
	return targetIDs;
}


+ (void)enumerateTagField:(tagField_t)tagField block:(void (^)(tagField_t singularTagField))block
{
	tagField_t singularTagField = 0;
	for (int i = 0; i < 64; i ++)
	{
		singularTagField = 1ull << i;
		if (tagField & singularTagField)
		{
			block(singularTagField);
		}
	}
}

- (NSString *)debugStringValue
{
	return self.stringValue.lfx_stringByRemovingLIFXOUI;
}



#pragma mark - NSObject

- (NSUInteger)hash
{
	NSUInteger hash = 0;
	hash ^= _groupTagField;	// This may be poor quality in a 32-bit runtime - the top 32 bits will be lost
	hash ^= _deviceBytes.hash;
	return hash;
}

- (BOOL)isEqual:(id)object
{
	if (![object isKindOfClass:[LFXBinaryTargetID class]]) return NO;
	LFXBinaryTargetID *otherTargetID = object;
	if (self.targetType != otherTargetID.targetType) return NO;
	switch (self.targetType)
	{
		case LFXBinaryTargetTypeBroadcast:
			return YES;
		case LFXBinaryTargetTypeDevice:
			return [_deviceBytes isEqualToData:otherTargetID->_deviceBytes];
		case LFXBinaryTargetTypeTag:
			return _groupTagField == otherTargetID->_groupTagField;
	}
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

@end
