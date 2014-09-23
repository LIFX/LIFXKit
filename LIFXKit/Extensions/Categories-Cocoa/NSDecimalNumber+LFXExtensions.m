//
//  NSDecimalNumber+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 12/02/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "NSDecimalNumber+LFXExtensions.h"

@implementation NSDecimalNumber (LFXExtensions)

- (uint64_t)lfx_uint64Value
{
	return strtoull([[self stringValue] UTF8String], NULL, 0);
}

@end
