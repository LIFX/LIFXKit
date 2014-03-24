//
//  LFXObserverProxy.h
//  LIFXKit
//
//  Created by Nick Forge on 19/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 An Observer Proxy makes it easy to implement a multi-delegate style observer pattern.
 
 It is currently not threadsafe. To use it, declare a property in your observeable class like so:
 
	@property (nonatomic) LFXObserverProxy <MyObserverProtocol> *observerProxy;
 
 and initialise it using the LFXCreateObserverProxy() macro:
 
	self.observerProxy = LFXCreateObserverProxy(MyObserverProtocol);
 
 Then you can send messages to all observers by sending them to the .observerProxy:
 
	[self.observerProxy object:self didChangeSomeValue:value];
 
 */


#define LFXCreateObserverProxy(protocolName) (LFXObserverProxy <protocolName> *)[LFXObserverProxy observerProxyWithObserverProtocol:@protocol(protocolName)]

@interface LFXObserverProxy : NSObject

+ (LFXObserverProxy *)observerProxyWithObserverProtocol:(Protocol *)protocol;

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end
