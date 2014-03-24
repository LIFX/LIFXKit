//
//  LFXClient.m
//  LIFX
//
//  Created by Nick Forge on 12/12/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXClient.h"
#import "LFXClient+Private.h"
#import "LFXNetworkContext.h"
#import "LFXLANTransportManager.h"
#import "LFXWiFiObserver.h"
#import "LFXNetworkContext+Private.h"
#import "LFXExtensions.h"
#import "LFXObserverProxy.h"

@interface LFXClient ()

@property (nonatomic) LFXNetworkContext *localNetworkContext;

@property (nonatomic) LFXObserverProxy <LFXClientObserver> *clientObserverProxy;

@end

@implementation LFXClient

+ (LFXClient *)sharedClient
{
	static LFXClient *sharedClient;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedClient = [LFXClient new];
	});
	return sharedClient;
}

- (id)init
{
	if ((self = [super init]))
	{
		self.clientObserverProxy = LFXCreateObserverProxy(LFXClientObserver);
		MakeWeakRef(self, weakSelf);
		[[LFXWiFiObserver sharedObserver] addObserverObject:self callback:^(LFXWiFiObserver *observer) {
			MakeStrongRef(weakSelf, strongSelf);
			[strongSelf.localNetworkContext resetAllCaches];
		}];
	}
	return self;
}

- (void)addClientObserver:(id<LFXClientObserver>)observer
{
	[self.clientObserverProxy addObserver:observer];
}

- (void)removeClientObserver:(id<LFXClientObserver>)observer
{
	[self.clientObserverProxy removeObserver:observer];
}

- (LFXNetworkContext *)localNetworkContext
{
	static LFXNetworkContext *localNetworkContext;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		localNetworkContext = [[LFXNetworkContext alloc] initWithClient:self transportManager:[LFXLANTransportManager new] name:@"LAN"];
	});
	return localNetworkContext;
}

@end

@implementation LFXClient (Private)

- (void)lfx_networkContextDidConnect:(LFXNetworkContext *)networkContext
{
	[self.clientObserverProxy client:self networkContextDidConnect:networkContext];
}

- (void)lfx_networkContextDidDisconnect:(LFXNetworkContext *)networkContext
{
	[self.clientObserverProxy client:self networkContextDidDisconnect:networkContext];
}

@end
