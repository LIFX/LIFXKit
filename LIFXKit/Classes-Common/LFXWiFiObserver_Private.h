//
//  LFXWiFiObserver_Private.h
//  LIFXKit
//
//  Created by Chris Miles on 29/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXWiFiObserver.h"
#import "LFXObserverProxy.h"

static NSString *const LFXWiFiObserverNetworkInfoSSIDKey = @"SSID";
static NSString *const LFXWiFiObserverNetworkInfoBSSIDKey = @"BSSID";


@interface LFXWiFiObserver ()

@property (nonatomic) NSTimer *wifiStatePollingTimer;

@property (strong, nonatomic) NSDictionary *cachedNetworkInfo;

@property (nonatomic) LFXObserverProxy <LFXWiFiObserverProtocol> *wiFiObserverProxy;


// Methods for concrete subclasses

- (void)createPollingTimer;
- (void)destroyPollingTimer;

- (void)updateNetworkInfo;

@end
