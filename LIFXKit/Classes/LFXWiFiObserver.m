//
//  LFXWiFiObserver.m
//  LIFX
//
//  Created by Nick Forge on 30/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXWiFiObserver.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface LFXWiFiObservationDescriptor : NSObject

@property (nonatomic) id observingObject;
@property (nonatomic, copy) LFXWiFiObserverCallback callback;

@end

@implementation LFXWiFiObservationDescriptor

@end



@interface LFXWiFiObserver ()

@property (nonatomic) NSTimer *wifiStatePollingTimer;
@property (nonatomic) NSMutableArray *observationDescriptors;

@property (nonatomic) NSDictionary *cachedNetworkInfo;

@end

@implementation LFXWiFiObserver

+ (LFXWiFiObserver *)sharedObserver
{
	static LFXWiFiObserver *sharedObserver;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedObserver = [LFXWiFiObserver new];
	});
	return sharedObserver;
}

- (id)init
{
	if ((self = [super init]))
	{
		self.observationDescriptors = [NSMutableArray new];
		self.wifiStatePollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(wifiPollingTimerDidFire:) userInfo:nil repeats:YES];
	}
	return self;
}

- (void)wifiPollingTimerDidFire:(NSTimer *)timer
{
	NSDictionary *freshNetworkInfo = [self freshNetworkInfo];
	if ((!self.cachedNetworkInfo && freshNetworkInfo) ||
		(self.cachedNetworkInfo && ![self.cachedNetworkInfo isEqual:freshNetworkInfo]))
	{
		self.cachedNetworkInfo = freshNetworkInfo;
		[self sendObservationCallbacks];
	}
}

- (NSDictionary *)freshNetworkInfo
{
	NSArray *interfaceNames = (__bridge NSArray *)CNCopySupportedInterfaces();
	if (interfaceNames.firstObject)
	{
		NSDictionary *infoDictionary = (__bridge NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceNames.firstObject);
		return infoDictionary;
	}
	return nil;
}

- (NSString *)currentSSID
{
	return self.freshNetworkInfo[(NSString *)kCNNetworkInfoKeySSID];
}

- (BOOL)isConnectedToLIFXSoftAP
{
	return [self.currentSSID isEqualToString:@"LIFX Bulb"];
}

- (void)addObserverObject:(id)object callback:(void (^)(LFXWiFiObserver *observer))callback
{
	LFXWiFiObservationDescriptor *observationDescriptor = [LFXWiFiObservationDescriptor new];
	observationDescriptor.observingObject = object;
	observationDescriptor.callback = callback;
	[self.observationDescriptors addObject:observationDescriptor];
}

- (void)removeObserverObject:(id)object
{
	for (LFXWiFiObservationDescriptor *anObservationDescriptor in self.observationDescriptors.copy)
	{
		if (anObservationDescriptor.observingObject == object)
		{
			[self.observationDescriptors removeObject:anObservationDescriptor];
		}
	}
}

- (void)sendObservationCallbacks
{
	for (LFXWiFiObservationDescriptor *anObservationDescriptor in self.observationDescriptors)
	{
		anObservationDescriptor.callback(self);
	}
}

@end
