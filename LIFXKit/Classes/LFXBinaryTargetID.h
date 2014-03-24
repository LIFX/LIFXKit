//
//  LFXTarget.h
//  LIFX
//
//  Created by Nick Forge on 13/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LFXBinaryTargetType) {
	LFXBinaryTargetTypeDevice,
	LFXBinaryTargetTypeTag,
	LFXBinaryTargetTypeBroadcast, // Special case of a group
};

typedef uint64_t tagField_t;

// LFXSiteID instances are immutable



@interface LFXBinaryTargetID : NSObject <NSCopying>

// Canonical representation is a string
//
// Device: 6 byte, 12 char hex string				(704192abcd12)
// Group: uint64 bitfield prefixed with # in hex	(#8 - group 4)
// Broadcast: "*"

+ (LFXBinaryTargetID *)targetIDWithString:(NSString *)stringValue;
- (NSString *)stringValue;


- (LFXBinaryTargetType)targetType;

// Device Targets
+ (LFXBinaryTargetID *)deviceTargetIDWithData:(NSData *)data;
+ (LFXBinaryTargetID *)deviceTargetIDWithString:(NSString *)string;
- (NSData *)deviceDataValue;

// Group Targets
+ (LFXBinaryTargetID *)groupTargetIDWithTagField:(tagField_t)tagField;
- (tagField_t)groupTagField;

// Broadcast Targets
+ (LFXBinaryTargetID *)broadcastTargetID;

// This will return an LFXBinaryTargetID for each bit that's set in the tagfield
- (NSArray *)individualGroupTargetIDs;


- (NSString *)debugStringValue;






// Tag Field Enumeration
+ (void)enumerateTagField:(tagField_t)tagField block:(void (^)(tagField_t singularTagField))block;

@end
