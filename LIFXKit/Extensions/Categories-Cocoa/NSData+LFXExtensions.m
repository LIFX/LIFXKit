//
//  NSData+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 12/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "NSData+LFXExtensions.h"
#import "NSString+LFXExtensions.h"
#import <zlib.h>

@implementation NSData (LFXExtensions)

- (uint32_t)lfx_CRC32
{
	uLong crc = crc32(0L, Z_NULL, 0);
	crc = crc32(crc, [self bytes], (uInt)[self length]);
	return (uint32_t)crc;
}

+ (NSData *)lfx_dataWithHexString:(NSString *)hexString
{
	if (hexString.length % 2 != 0)
	{
		hexString = [hexString stringByAppendingString:@"0"];
	}
	
	NSMutableData *data = [NSMutableData dataWithLength:hexString.length / 2];
	
	for (NSUInteger byteOffset = 0; byteOffset < hexString.length / 2; byteOffset ++)
	{
		NSString *hexByteString = [hexString substringWithRange:NSMakeRange(byteOffset * 2, 2)];
		uint8_t byte = [hexByteString lfx_unsignedIntFromHexString];
		[data replaceBytesInRange:NSMakeRange(byteOffset, 1) withBytes:&byte];
	}
	
	return data.copy;
}

- (NSString *)lfx_hexStringValue
{
	return [NSString lfx_hexByteStringFromBytes:self.bytes length:self.length];
}

- (BOOL)lfx_isAllZeroes
{
	uint8_t const *bytes = self.bytes;
	NSUInteger length = self.length;
	for (size_t i = 0; i < length; i ++)
	{
		if (bytes[i] != 0) return NO;
	}
	return YES;
}

+ (NSData *)lfx_zeroedDataWithLength:(NSInteger)length
{
	NSMutableData *data = [NSMutableData new];
	data.length = length;
	return data;
}

@end
