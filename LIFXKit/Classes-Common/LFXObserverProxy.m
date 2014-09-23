//
//  LFXObserverProxy.m
//  LIFXKit
//
//  Created by Nick Forge on 19/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXObserverProxy.h"
#import "LFXExtensions.h"

@interface LFXObserverProxy ()

@property (nonatomic) NSHashTable *observers;
@property (nonatomic) Protocol *protocol;

@end

@implementation LFXObserverProxy

+ (LFXObserverProxy *)observerProxyWithObserverProtocol:(Protocol *)protocol
{
	LFXObserverProxy *proxy = [LFXObserverProxy alloc];
	proxy.observers = [NSHashTable weakObjectsHashTable];
	proxy.protocol = protocol;
	return proxy;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ : %p> {observerProtocol = %@, observers = %@}", NSStringFromClass(self.class), self, NSStringFromProtocol(self.protocol), self.observers];
}

- (void)addObserver:(id)observer
{
	if ([observer conformsToProtocol:self.protocol])
	{
		[self.observers addObject:observer];
	}
	else
	{
		NSLog(@"Error: attempted to add observer %@ to observer proxy %@", observer, self);
	}
}

- (void)removeObserver:(id)observer
{
	[self.observers removeObject:observer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature *signature;
	
	if ((signature = [super methodSignatureForSelector:selector])) return signature;
	
	return [NSMethodSignature lfx_signatureWithProtocol:self.protocol selector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
	for (id anObserver in self.observers.allObjects)
	{
		if ([anObserver respondsToSelector:invocation.selector])
		{
			[invocation invokeWithTarget:anObserver];
		}
	}
}

@end
