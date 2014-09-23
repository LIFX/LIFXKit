//
//  LFXWeakObjectProxy.m
//  LIFXKit
//
//  Created by Nick Forge on 17/05/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXWeakObjectProxy.h"

@interface LFXWeakObjectProxy ()

@property (nonatomic, weak) id object;

@end

@implementation LFXWeakObjectProxy

+ (instancetype)proxyWithObject:(id)object
{
	LFXWeakObjectProxy *proxy = [LFXWeakObjectProxy new];
	proxy.object = object;
	return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	if (_object)
	{
		return [self.object methodSignatureForSelector:selector];
	}
	return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
	if (_object)
	{
		[invocation invokeWithTarget:self.object];
	}
}

@end
