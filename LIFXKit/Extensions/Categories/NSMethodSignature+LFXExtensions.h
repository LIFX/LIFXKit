//
//  NSMethodSignature+LFXExtensions.h
//  LIFXKit
//
//  Created by Nick Forge on 19/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMethodSignature (LFXExtensions)

+ (NSMethodSignature *)lfx_signatureWithProtocol:(Protocol *)protocol selector:(SEL)selector;

@end
