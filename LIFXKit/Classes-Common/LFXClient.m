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
#import "LFXLocalTransportManager.h"
#import "LFXNetworkContext+Private.h"
#import "LFXExtensions.h"
#import "LFXObserverProxy.h"
#import "LFXWiFiObserver.h"
#import "LFXLocalNetworkContext.h"


@interface LFXClient () <LFXWiFiObserverProtocol, LFXNetworkContextObserver>

@property (nonatomic) LFXNetworkContext *localNetworkContext;

@property (nonatomic) LFXObserverProxy <LFXClientObserver> *clientObserverProxy;

@property (nonatomic) BOOL quietModeIsEnabled;

@property (nonatomic) NSMutableArray *mutableNetworkContexts;

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
		self.mutableNetworkContexts = [NSMutableArray new];
		[[LFXWiFiObserver sharedObserver] addWiFiObserver:self];
		self.localNetworkContext.isEnabled = YES;
	}
	return self;
}

- (void)wifiObserver:(LFXWiFiObserver *)observer didChangeSSID:(NSString *)ssid
{
	[self.localNetworkContext resetAllCaches];
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
		localNetworkContext = [[LFXLocalNetworkContext alloc] initWithClient:self];
		[self lfx_addNetworkContext:localNetworkContext];
	});
	return localNetworkContext;
}

- (NSArray *)networkContexts
{
	return self.mutableNetworkContexts.copy;
}

- (void)networkContextDidConnect:(LFXNetworkContext *)networkContext
{
	[self.clientObserverProxy client:self networkContextDidConnect:networkContext];
}

- (void)networkContextDidDisconnect:(LFXNetworkContext *)networkContext
{
	[self.clientObserverProxy client:self networkContextDidDisconnect:networkContext];
}

@end

@implementation LFXClient (Private)

- (void)lfx_addNetworkContext:(LFXNetworkContext *)networkContext
{
	[self.mutableNetworkContexts addObject:networkContext];
	[networkContext addNetworkContextObserver:self];
	[self.clientObserverProxy client:self didAddNetworkContext:networkContext];
}

- (void)lfx_removeNetworkContext:(LFXNetworkContext *)networkContext
{
	[self.mutableNetworkContexts removeObject:networkContext];
	[networkContext removeNetworkContextObserver:self];
	[self.clientObserverProxy client:self didRemoveNetworkContext:networkContext];
}

@end
