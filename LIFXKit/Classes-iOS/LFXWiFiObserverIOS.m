//
//  LFXWiFiObserverIOS.m
//  LIFXKit
//
//  Created by Chris Miles on 29/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXWiFiObserverIOS.h"
#import "LFXWiFiObserver_Private.h"
#import "LFXMacros.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation LFXWiFiObserverIOS

- (id)init
{
    if ((self = [super init]))
    {
        MakeWeakRef(self, weakSelf);
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [weakSelf updateNetworkInfo];
            [weakSelf createPollingTimer];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [weakSelf updateNetworkInfo];
            [weakSelf destroyPollingTimer];
        }];
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
        {
            [self createPollingTimer];
        }
    }
    return self;
}

- (NSDictionary *)freshNetworkInfo
{
    NSArray *interfaceNames = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (interfaceNames.firstObject)
    {
        NSDictionary *infoDictionary = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceNames.firstObject);

        NSString *ssid = infoDictionary[(NSString *)kCNNetworkInfoKeySSID];
        NSString *bssid = infoDictionary[(NSString *)kCNNetworkInfoKeyBSSID];

        NSMutableDictionary *networkInfo = [NSMutableDictionary dictionary];
        if (ssid)
        {
            networkInfo[LFXWiFiObserverNetworkInfoSSIDKey] = ssid;
        }

        if (bssid)
        {
            networkInfo[LFXWiFiObserverNetworkInfoBSSIDKey] = bssid;
        }

        return networkInfo;
    }
    return nil;
}

@end
