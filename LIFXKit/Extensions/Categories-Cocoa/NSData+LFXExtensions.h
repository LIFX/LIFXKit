//
//  NSData+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 12/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


#define lfx_NSDataWithPointer(pointer) [NSData dataWithBytes:pointer length:sizeof(pointer)]


@interface NSData (LFXExtensions)

- (uint32_t)lfx_CRC32;

+ (NSData *)lfx_dataWithHexString:(NSString *)hexString;
- (NSString *)lfx_hexStringValue;

- (BOOL)lfx_isAllZeroes;

+ (NSData *)lfx_zeroedDataWithLength:(NSInteger)length;

@end
