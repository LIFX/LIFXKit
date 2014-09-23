//
//  LFXWiFiObserver.h
//  LIFX
//
//  Created by Nick Forge on 30/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LFXWiFiObserverProtocol;	// Should be renamed if/when LFXWiFiObserver is renamed

@interface LFXWiFiObserver : NSObject

+ (LFXWiFiObserver *)sharedObserver;

@property (nonatomic, readonly) NSString *currentSSID;
@property (nonatomic, readonly) NSString *currentBSSID;

// Observers
- (void)addWiFiObserver:(id <LFXWiFiObserverProtocol>)observer;
- (void)removeWiFiObserver:(id <LFXWiFiObserverProtocol>)observer;

@end

@protocol LFXWiFiObserverProtocol <NSObject>

@optional
- (void)wifiObserver:(LFXWiFiObserver *)observer didChangeSSID:(NSString *)SSID;
- (void)wifiObserver:(LFXWiFiObserver *)observer didChangeBSSID:(NSString *)BSSID;

@end