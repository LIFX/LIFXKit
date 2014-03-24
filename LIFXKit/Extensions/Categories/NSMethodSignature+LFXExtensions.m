//
//  NSMethodSignature+LFXExtensions.m
//  LIFXKit
//
//  Created by Nick Forge on 19/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "NSMethodSignature+LFXExtensions.h"
#import <objc/runtime.h>

@implementation NSMethodSignature (LFXExtensions)

+ (NSMethodSignature *)lfx_signatureWithProtocol:(Protocol *)protocol selector:(SEL)selector
{
	struct objc_method_description desc;
    BOOL required = YES;

    desc = protocol_getMethodDescription(protocol, selector, required, YES);
    if (desc.name == NULL)
	{
        required = NO;
        desc = protocol_getMethodDescription(protocol, selector, required, YES);
    }
	
    if (desc.name == NULL) return nil;
	
    return [NSMethodSignature signatureWithObjCTypes:desc.types];
}

@end
