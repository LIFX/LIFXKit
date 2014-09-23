//
//  NSDecimalNumber+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 12/02/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (LFXExtensions)

// This actually works for large values, unlike unsignedLongLongValue, which is broken (https://gist.github.com/nsforge/8949790)
- (uint64_t)lfx_uint64Value;

@end
