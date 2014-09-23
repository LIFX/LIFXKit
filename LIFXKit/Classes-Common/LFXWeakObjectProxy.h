//
//  LFXWeakObjectProxy.h
//  LIFXKit
//
//  Created by Nick Forge on 17/05/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFXWeakObjectProxy : NSObject

+ (instancetype)proxyWithObject:(id)object;

@end
