//
//  LFXWiFiObserverOSX.m
//  LIFXKit
//
//  Created by Chris Miles on 29/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXWiFiObserverOSX.h"
#import "LFXWiFiObserver_Private.h"
#import "LFXMacros.h"
#import <CoreWLAN/CoreWLAN.h>


@interface LFXWiFiObserverOSX ()

@property (strong) NSArray *watchedInterfaces;
@property (strong) NSOperationQueue *serialObservationQueue;

@end


@implementation LFXWiFiObserverOSX

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSArray *wifiChangeNotificationNames = @[
                                                 CWBSSIDDidChangeNotification,
                                                 CWCountryCodeDidChangeNotification,
                                                 CWLinkDidChangeNotification,
                                                 CWModeDidChangeNotification,
                                                 CWPowerDidChangeNotification,
                                                 CWServiceDidChangeNotification,
                                                 CWSSIDDidChangeNotification,
                                                 ];

        MakeWeakRef(self, weakSelf);
        
        void ((^handleWifiChangeNotification)(NSNotification *notification)) = ^(NSNotification *notification) {
            MakeStrongRef(weakSelf, self);
            [self updateNetworkInfo];
        };

        NSOperationQueue *serialObservationQueue = [[NSOperationQueue alloc] init];
        serialObservationQueue.maxConcurrentOperationCount = 1; // serial

        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

        for (NSString *notificationName in wifiChangeNotificationNames)
        {
            [notificationCenter addObserverForName:notificationName
                                            object:nil
                                             queue:serialObservationQueue
                                        usingBlock:handleWifiChangeNotification];
        }

        LFXLogVerbose(@"%@ %@: WLAN notifications registered = %@", self, NSStringFromSelector(_cmd), wifiChangeNotificationNames);

        NSMutableArray *watchedInterfaces = [NSMutableArray array];
        for (NSString *interfaceName in [CWInterface interfaceNames])
        {
            CWInterface *interface = [CWInterface interfaceWithName:interfaceName];
            if (interface)
            {
                [watchedInterfaces addObject:interface];
            }
        }

        self.watchedInterfaces = watchedInterfaces;
        self.serialObservationQueue = serialObservationQueue;

        LFXLogInfo(@"%@ %@: watchedInterfaces = %@", self, NSStringFromSelector(_cmd), watchedInterfaces);
    }
    return self;
}


#pragma mark - Fresh Network Info

- (NSDictionary *)freshNetworkInfo
{
    NSString *ssid = nil;
    NSString *bssid = nil;

    for (CWInterface *interface in self.watchedInterfaces)
    {
        if (interface.serviceActive)
        {
            ssid = interface.ssid;
            bssid = interface.bssid;

            break;
        }
    }

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

@end
