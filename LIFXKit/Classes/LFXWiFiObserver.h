//
//  LFXWiFiObserver.h
//  LIFX
//
//  Created by Nick Forge on 30/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXWiFiObserver;

typedef void (^LFXWiFiObserverCallback)(LFXWiFiObserver *observer);

@interface LFXWiFiObserver : NSObject

+ (LFXWiFiObserver *)sharedObserver;

@property (nonatomic, readonly) NSString *currentSSID;

- (BOOL)isConnectedToLIFXSoftAP;

- (void)addObserverObject:(id)object callback:(LFXWiFiObserverCallback)callback;
- (void)removeObserverObject:(id)object;

@end
