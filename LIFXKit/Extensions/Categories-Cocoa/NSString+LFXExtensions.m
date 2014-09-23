//
//  NSString+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 9/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "NSString+LFXExtensions.h"

@implementation NSString (LFXExtensions)

- (NSString *)lfx_substringToIndexIfItExists:(NSUInteger)index
{
	NSUInteger safeIndex = MIN(index, self.length);
	return [self substringToIndex:safeIndex];
}

- (NSString *)lfx_substringFromIndexIfItExists:(NSUInteger)index
{
	NSUInteger safeIndex = MIN(index, self.length);
	return [self substringFromIndex:safeIndex];
}

- (NSString *)lfx_substringWithRangeIfItExists:(NSRange)range
{
	NSUInteger safeLocation = MIN(range.location, self.length);
	NSUInteger safeLength = MIN(range.length, self.length - safeLocation);
	return [self substringWithRange:NSMakeRange(safeLocation, safeLength)];
}

- (BOOL)lfx_containsOnlyCharactersInSet:(NSCharacterSet *)set
{
	return [self lfx_containsOnlyCharactersInSet:set options:0];
}

- (BOOL)lfx_containsOnlyCharactersInSet:(NSCharacterSet *)set options:(NSStringCompareOptions)optionsMask
{
	return [self rangeOfCharacterFromSet:[set invertedSet] options:optionsMask].location == NSNotFound;
}

- (uint8_t)lfx_uint8FromHexString
{
	NSScanner *scanner = [NSScanner scannerWithString:self];
	unsigned int value = 0;
	[scanner scanHexInt:&value];
	return value;
}

- (unsigned int)lfx_unsignedIntFromHexString
{
	NSScanner *scanner = [NSScanner scannerWithString:self];
	unsigned int value = 0;
	[scanner scanHexInt:&value];
	return value;
}


+ (NSString *)lfx_hexByteStringFromBytes:(const uint8_t *)bytes length:(NSUInteger)numberOfBytes
{
	NSMutableString *string = [NSMutableString new];
	for (NSUInteger i = 0; i < numberOfBytes; i ++)
	{
		[string appendFormat:@"%02x", bytes[i]];
	}
	return string;
}

- (void)lfx_getBytesAsHexByteString:(uint8_t *)bytes length:(NSUInteger)numberOfBytes
{
	for (NSUInteger i = 0; i < numberOfBytes; i ++)
	{
		NSString *hexByteString = [self lfx_substringWithRangeIfItExists:NSMakeRange(i * 2, 2)];
		bytes[i] = [hexByteString lfx_unsignedIntFromHexString];
	}
}

+ (NSString *)lfx_binaryStringFromUint64:(uint64_t)integer
{
	NSMutableString *string = [NSMutableString new];
	uint64_t remainder = integer;
	while (remainder != 0)
	{
		int lowestBit = remainder & 1ull;
		[string insertString:lowestBit ? @"1" : @"0" atIndex:0];
		remainder >>= 1;
	}
	if (string.length == 0) [string appendString:@"0"];
	return string;
}

+ (NSString *)lfx_hexStringWithUInt64:(uint64_t)integer
{
	return [NSString stringWithFormat:@"%llx", integer];
}

- (NSString *)lfx_IPv4StringByStrippingIPv6Prefix
{
	NSString *ipv6Prefix = @"::ffff:";
	if ([self hasPrefix:ipv6Prefix]) return [self substringFromIndex:ipv6Prefix.length];
	return self;
}

+ (NSString *)lfx_stringWithInteger:(NSInteger)integer
{
	return [NSString stringWithFormat:@"%d", (int)integer];
}

+ (NSString *)lfx_LIFXOUI
{
	return @"d073d5";
}

+ (NSString *)lfx_LIFXOUIInMACFormat
{
	return @"d0:73:d5";
}

- (NSString *)lfx_stringByRemovingLIFXOUI
{
	return [self stringByReplacingOccurrencesOfString:[NSString lfx_LIFXOUI] withString:@""];
}

- (NSString *)lfx_stringByStandardizingMACAddress
{
	if ([self rangeOfString:@":"].location == NSNotFound)
	{
		// No Colons
		if (self.length != 12) return nil;
		NSMutableArray *components = [NSMutableArray new];
		for (int i = 0; i < 6; i ++)
		{
			[components addObject:[self substringWithRange:NSMakeRange(i * 2, 2)].lowercaseString];
		}
		return [components componentsJoinedByString:@":"];
	}
	else
	{
		// Colons
		NSArray *components = [self componentsSeparatedByString:@":"];
		if (components.count != 6) return nil;
		NSMutableArray *standardizedComponents = [NSMutableArray new];
		for (NSString *aComponent in components)
		{
			if (aComponent.length > 2) return nil;
			NSString *standardizedComponent;
			if (aComponent.length == 2) standardizedComponent = aComponent;
			if (aComponent.length == 1) standardizedComponent = [@"0" stringByAppendingString:aComponent];
			if (aComponent.length == 0) standardizedComponent = [@"00" stringByAppendingString:aComponent];
			if (standardizedComponent) [standardizedComponents addObject:standardizedComponent.lowercaseString];
		}
		return [standardizedComponents componentsJoinedByString:@":"];
	}
}

@end
