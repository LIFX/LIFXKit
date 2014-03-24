//
//  NSString+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 9/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LFXExtensions)

// These methods won't throw an exception if the range is invalid
- (NSString *)lfx_substringToIndexIfItExists:(NSUInteger)index;
- (NSString *)lfx_substringFromIndexIfItExists:(NSUInteger)index;
- (NSString *)lfx_substringWithRangeIfItExists:(NSRange)range;

- (BOOL)lfx_containsOnlyCharactersInSet:(NSCharacterSet *)set;
- (BOOL)lfx_containsOnlyCharactersInSet:(NSCharacterSet *)set options:(NSStringCompareOptions)optionsMask;

// Uses -[NSScanner scanHexInt:], so the hex string will be treated as an integer (not raw bytes)
- (unsigned int)lfx_unsignedIntFromHexString;

// These methods treat strings as representations of raw bytes, not integers
+ (NSString *)lfx_hexByteStringFromBytes:(const uint8_t *)bytes length:(NSUInteger)numberOfBytes;
- (void)lfx_getBytesAsHexByteString:(uint8_t *)bytes length:(NSUInteger)numberOfBytes;

// Binary output (unpadded)
+ (NSString *)lfx_binaryStringFromUint64:(uint64_t)integer;

// Hex output
+ (NSString *)lfx_hexStringWithUInt64:(uint64_t)integer;

// IP Hosts
- (NSString *)lfx_IPv4StringByStrippingIPv6Prefix;

// LIFX OUI
+ (NSString *)lfx_LIFXOUI;
- (NSString *)lfx_stringByRemovingLIFXOUI;

@end
