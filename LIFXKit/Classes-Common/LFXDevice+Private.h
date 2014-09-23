//
//  LFXDevice_Private.h
//  LIFXKit
//
//  Created by Nick Forge on 16/05/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXDevice.h"
#import "LFXTypes.h"
@class LFXWeakObjectProxy, LFXPeriodicTask, LFXNetworkContext, LFXMessage, LFXObserverProxy;
@protocol LFXDeviceMessageHandler;


typedef NS_ENUM(NSInteger, LFXPropertySource) {
	LFXPropertySourceNoValue,	// => no value for this property
	LFXPropertySourceDevice,	// => based on messages from device
	LFXPropertySourceClient,	// => based on messages sent to device
};

extern NSString * NSStringFromLFXPropertySource(LFXPropertySource propertySource);

extern NSTimeInterval const LFXPropertySetStateOverlapPeriod;


@interface LFXDevice ()

// Subclasses can hook into messages addressed to/from this device by overriding this method
- (void)handleMessage:(LFXMessage *)message NS_REQUIRES_SUPER;


// Other components can hook into messages addressed to/from a device using these hooks
- (void)addMessageHandler:(id <LFXDeviceMessageHandler>)handler;
- (void)removeMessageHandler:(id <LFXDeviceMessageHandler>)handler;


@property (nonatomic, weak) LFXNetworkContext *networkContext;
@property (nonatomic) NSString *deviceID;
@property (nonatomic) LFXDeviceReachability reachability;



// Clock Synchronization
// Device Time = clock time on the LIFX Device
// Client Device Time = clock time on the iOS Device

// Requests the current time from the device, the response will automatically update .clockDelta
- (void)queryClock;

@property (nonatomic, readonly) NSTimeInterval clockDelta;	// Device Time = Client Device Time + Clock Delta

// Takes into account .clockDelta
- (NSDate *)deviceTimeForClientDeviceTime:(NSDate *)clientTime;




// Call this when handling messages for a device.
// It will set both the <value>, as well as a timestamp for the {key, source} pair
- (void)setPropertyValue:(id)value forKey:(NSString *)key source:(LFXPropertySource)source;



// Convenience method; makes use of -bestPropertySourceForKey: and -propertyValueForKey:source:
- (id)propertyValueForKey:(NSString *)key;

// Convenience method; makes use of -bestPropertySourceForKey: and -propertyTimestampForKey:source:
- (NSDate *)propertyTimestampForKey:(NSString *)key;



// This relies on a standard timestamp-comparison approach to work out the most reliable source of data
- (LFXPropertySource)bestPropertySourceForKey:(NSString *)key;



// For code that requires complex logic (e.g. confirmation of a Set message), use this to query
// the last known value of a property from a particular source (usually the Device)
- (id)propertyValueForKey:(NSString *)key source:(LFXPropertySource)source;


// This can be used in network scanning logic
- (NSDate *)propertyTimestampForKey:(NSString *)key source:(LFXPropertySource)source;



// Tasks

- (void)addPeriodicTask:(LFXPeriodicTask *)task;
- (void)removePeriodicTaskForTaskID:(NSString *)periodicTaskID;


// For Subclasses

- (void)didChangeReachability:(LFXDeviceReachability)reachability;



// Internal class use
@property (nonatomic) NSMutableDictionary *devicePropertyValues;
@property (nonatomic) NSMutableDictionary *clientPropertyValues;

@property (nonatomic) NSMutableDictionary *devicePropertyTimestamps;
@property (nonatomic) NSMutableDictionary *clientPropertyTimestamps;

@property (nonatomic) NSTimer *periodTaskTimer;
@property (nonatomic) NSMutableDictionary *periodicTasks;

@property (nonatomic) LFXWeakObjectProxy *weakProxy;

@property (nonatomic) NSDate *mostRecentMessageTimestamp;

@property (nonatomic) LFXObserverProxy <LFXDeviceMessageHandler> *messageHandlerProxy;

@end

@protocol LFXDeviceMessageHandler <NSObject>

- (void)device:(LFXDevice *)device didHandleMessage:(LFXMessage *)message;

@end
