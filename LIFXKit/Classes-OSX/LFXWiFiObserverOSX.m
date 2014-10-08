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

@property (strong) NSMutableSet *activeInterfaceNames;
@property (strong) NSMutableDictionary *trackedInterfaces;

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
                                                 CWSSIDDidChangeNotification,
                                                 ];

        MakeWeakRef(self, weakSelf);
        
        void ((^handleWifiChangeNotification)(NSNotification *notification)) = ^(NSNotification *notification) {
            MakeStrongRef(weakSelf, self);

            NSString *interfaceName = notification.object;
            if (interfaceName)
            {
                [self updateInterfaceStateWithName:interfaceName];
                [self networkInfoNeedsUpdate];
            }
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

        self.trackedInterfaces = [NSMutableDictionary dictionary];
        self.activeInterfaceNames = [NSMutableSet set];

        for (NSString *interfaceName in [CWInterface interfaceNames])
        {
            [self updateInterfaceStateWithName:interfaceName];
        }

        self.serialObservationQueue = serialObservationQueue;
    }
    return self;
}

- (void)updateInterfaceStateWithName:(NSString *)interfaceName
{
    CWInterface *interface = self.trackedInterfaces[interfaceName];
    if (interface == nil)
    {
        interface = [CWInterface interfaceWithName:interfaceName];
    }

    if (interface)
    {
        self.trackedInterfaces[interfaceName] = interface;  // hold any interface references we find to ensure CoreWLAN notifications are sent

        BOOL interfaceIsActive = (interface.powerOn && interface.serviceActive);

        if (interfaceIsActive)
        {
            [self.activeInterfaceNames addObject:interfaceName];
        }
        else
        {
            [self.activeInterfaceNames removeObject:interfaceName];
        }
    }

    LFXLogVerbose(@"%@ %@: active interfaces = %@", self, NSStringFromSelector(_cmd), self.activeInterfaceNames);
}

- (void)networkInfoNeedsUpdate
{
    // coalesce network info updates for efficiency
    static NSTimeInterval const coalesceDelay = 0.2;
    SEL updateNetworkInfoSelector = @selector(updateNetworkInfo);

    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:updateNetworkInfoSelector object:nil];
        [self performSelector:updateNetworkInfoSelector withObject:nil afterDelay:coalesceDelay];
    });
}


#pragma mark - Fresh Network Info

- (NSDictionary *)freshNetworkInfo
{
    NSString *ssid = nil;
    NSString *bssid = nil;

    // Select an active wifi interface
    NSString *interfaceName = [self.activeInterfaceNames anyObject];
    if (interfaceName)
    {
        CWInterface *activeInterface = self.trackedInterfaces[interfaceName];
        if (activeInterface == nil)
        {
            activeInterface = [CWInterface interfaceWithName:interfaceName];
        }

        if (activeInterface)
        {
            ssid = activeInterface.ssid;
            bssid = activeInterface.bssid;
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
