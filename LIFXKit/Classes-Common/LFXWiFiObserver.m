//
//  LFXWiFiObserver.m
//  LIFX
//
//  Created by Nick Forge on 30/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXWiFiObserver.h"
#import "LFXWiFiObserver_Private.h"
#import "LFXMacros.h"
#import "NSTimer+LFXExtensions.h"

#if TARGET_OS_IPHONE
#import "LFXWiFiObserverIOS.h"
#else
#import "LFXWiFiObserverOSX.h"
#endif


#pragma mark - LFXWiFiObserver

@implementation LFXWiFiObserver

+ (LFXWiFiObserver *)sharedObserver
{
    static LFXWiFiObserver *sharedObserver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

#if TARGET_OS_IPHONE
        sharedObserver = [LFXWiFiObserverIOS new];
#else
        sharedObserver = [LFXWiFiObserverOSX new];
#endif
    });
    return sharedObserver;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.wiFiObserverProxy = LFXCreateObserverProxy(LFXWiFiObserverProtocol);
    }
    return self;
}


#pragma mark - Polling Timer

- (void)createPollingTimer
{
	self.wifiStatePollingTimer = [NSTimer lfx_scheduledTimerWithTimeInterval:1.0 repeats:YES block:^{
		[self updateNetworkInfo];
	}];
}

- (void)destroyPollingTimer
{
	[self.wifiStatePollingTimer invalidate];
	self.wifiStatePollingTimer = nil;
}

#pragma mark - Update Network Info

- (void)updateNetworkInfo
{
    NSDictionary *freshNetworkInfo = [self freshNetworkInfo];
	
	NSString *oldSSID = self.cachedNetworkInfo[LFXWiFiObserverNetworkInfoSSIDKey];
	NSString *newSSID = freshNetworkInfo[LFXWiFiObserverNetworkInfoSSIDKey];
	
	NSString *oldBSSID = self.cachedNetworkInfo[LFXWiFiObserverNetworkInfoBSSIDKey];
	NSString *newBSSID = freshNetworkInfo[LFXWiFiObserverNetworkInfoBSSIDKey];
	
	if ((newSSID == nil && oldSSID != nil) || (newSSID != nil && ![newSSID isEqualToString:oldSSID]))
	{
		LFXLogInfo(@"Wifi Observer Did Change SSID: %@", newSSID);
		[self.wiFiObserverProxy wifiObserver:self didChangeSSID:newSSID];
		self.cachedNetworkInfo = freshNetworkInfo;
	}
	
	if ((newBSSID == nil && oldBSSID != nil) || (newBSSID != nil && ![newBSSID isEqualToString:oldBSSID]))
	{
		LFXLogInfo(@"Wifi Observer Did Change BSSID: %@", newBSSID);
		[self.wiFiObserverProxy wifiObserver:self didChangeBSSID:newBSSID];
		self.cachedNetworkInfo = freshNetworkInfo;
	}
}


#pragma mark - Public Properties

- (NSString *)currentSSID
{
    return self.freshNetworkInfo[LFXWiFiObserverNetworkInfoSSIDKey];
}

- (NSString *)currentBSSID
{
    return self.freshNetworkInfo[LFXWiFiObserverNetworkInfoBSSIDKey];
}


#pragma mark - Observers

- (void)addWiFiObserver:(id<LFXWiFiObserverProtocol>)observer
{
	[self.wiFiObserverProxy addObserver:observer];
}

- (void)removeWiFiObserver:(id<LFXWiFiObserverProtocol>)observer
{
	[self.wiFiObserverProxy removeObserver:observer];
}

#pragma mark - Abstract Methods

- (NSDictionary *)freshNetworkInfo
{
    LFXLogWarn(@"LFXWiFiObserver not implemented on this platform");

    return nil;
}

@end
