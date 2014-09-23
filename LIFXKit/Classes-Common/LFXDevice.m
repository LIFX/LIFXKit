//
//  LFXDevice.m
//  LIFXKit
//
//  Created by Nick Forge on 16/05/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXDevice.h"
#import "LFXDevice+Private.h"
#import "NSDate+LFXExtensions.h"
#import "LFXMacros.h"
#import "LFXPeriodicTask.h"
#import "LFXClient+Private.h"
#import "LFXNetworkContext+Private.h"
#import "LFXWeakObjectProxy.h"
#import "LFXMessage.h"
#import "LFXObserverProxy.h"
#import "LFXBinaryTypes.h"

NSTimeInterval const LFXPropertySetStateOverlapPeriod = 3.0;


extern NSString * NSStringFromLFXPropertySource(LFXPropertySource propertySource)
{
	switch (propertySource)
	{
		case LFXPropertySourceNoValue:	return @"No Value";
		case LFXPropertySourceClient:	return @"Client";
		case LFXPropertySourceDevice:	return @"Device";
	}
	return @"?";
}

@implementation LFXDevice


- (id)init
{
	if ((self = [super init]))
	{
		self.devicePropertyValues = [NSMutableDictionary new];
		self.clientPropertyValues = [NSMutableDictionary new];
		self.devicePropertyTimestamps = [NSMutableDictionary new];
		self.clientPropertyTimestamps = [NSMutableDictionary new];
		self.weakProxy = [LFXWeakObjectProxy proxyWithObject:self];
		self.periodicTasks = [NSMutableDictionary new];
		self.periodTaskTimer = [NSTimer scheduledTimerWithTimeInterval:LFXPeriodicTaskInterval target:self.weakProxy selector:@selector(periodicTaskTimerDidFire) userInfo:nil repeats:YES];
		self.messageHandlerProxy = LFXCreateObserverProxy(LFXDeviceMessageHandler);
	}
	return self;
}

- (void)dealloc
{
    [self.periodTaskTimer invalidate];
}

- (void)addMessageHandler:(id <LFXDeviceMessageHandler>)handler
{
	[self.messageHandlerProxy addObserver:handler];
}

- (void)removeMessageHandler:(id <LFXDeviceMessageHandler>)handler
{
	[self.messageHandlerProxy removeObserver:handler];
}

- (void)setPropertyValue:(id)value forKey:(NSString *)key source:(LFXPropertySource)source
{
	if (value)
	{
		[[self propertyValuesDictionaryForSource:source] setObject:value forKey:key];
		[[self propertyTimestampsDictionaryForSource:source] setObject:[NSDate date] forKey:key];
	}
	else
	{
		[[self propertyValuesDictionaryForSource:source] removeObjectForKey:key];
		[[self propertyTimestampsDictionaryForSource:source] removeObjectForKey:key];
	}
}

- (NSMutableDictionary *)propertyValuesDictionaryForSource:(LFXPropertySource)source
{
	switch (source)
	{
		case LFXPropertySourceDevice:	return self.devicePropertyValues;
		case LFXPropertySourceClient:	return self.clientPropertyValues;
		case LFXPropertySourceNoValue:	return nil;
	}
}

- (NSMutableDictionary *)propertyTimestampsDictionaryForSource:(LFXPropertySource)source
{
	switch (source)
	{
		case LFXPropertySourceDevice:	return self.devicePropertyTimestamps;
		case LFXPropertySourceClient:	return self.clientPropertyTimestamps;
		case LFXPropertySourceNoValue:	return nil;
	}
}

- (id)propertyValueForKey:(NSString *)key source:(LFXPropertySource)source
{
	return [[self propertyValuesDictionaryForSource:source] objectForKey:key];
}

- (NSDate *)propertyTimestampForKey:(NSString *)key source:(LFXPropertySource)source
{
	return [[self propertyTimestampsDictionaryForSource:source] objectForKey:key];
}

- (LFXPropertySource)bestPropertySourceForKey:(NSString *)key
{
	NSDate *knownDate = [self propertyTimestampForKey:key source:LFXPropertySourceDevice];
	NSDate *assumedDate = [self propertyTimestampForKey:key source:LFXPropertySourceClient];
	if (knownDate != nil && assumedDate != nil)
	{
		// i.e. if the Known value was received more than 3 seconds _after_ the Assumed value
		if ([assumedDate lfx_timeIntervalUpToDate:knownDate] > LFXPropertySetStateOverlapPeriod)
		{
			return LFXPropertySourceDevice;
		}
		else
		{
			return LFXPropertySourceClient;
		}
	}
	else if (knownDate != nil)
	{
		return LFXPropertySourceDevice;
	}
	else if (assumedDate != nil)
	{
		return LFXPropertySourceClient;
	}
	return LFXPropertySourceNoValue;
}

- (id)propertyValueForKey:(NSString *)key
{
	return [self propertyValueForKey:key source:[self bestPropertySourceForKey:key]];
}

- (NSDate *)propertyTimestampForKey:(NSString *)key
{
	return [self propertyTimestampForKey:key source:[self bestPropertySourceForKey:key]];
}

- (NSDictionary *)propertiesDiagnosticDump
{
	NSMutableSet *keys = [NSMutableSet new];
	[keys addObjectsFromArray:self.devicePropertyTimestamps.allKeys];
	[keys addObjectsFromArray:self.clientPropertyTimestamps.allKeys];
	NSMutableDictionary *dict = [NSMutableDictionary new];
	for (NSString *aKey in keys)
	{
		NSDate *deviceTime = [self propertyTimestampForKey:aKey source:LFXPropertySourceDevice];
		id deviceValue = [self propertyValueForKey:aKey source:LFXPropertySourceDevice];
		NSDate *clientTime = [self propertyTimestampForKey:aKey source:LFXPropertySourceClient];
		id clientValue = [self propertyValueForKey:aKey source:LFXPropertySourceClient];

		NSMutableArray *stringsForKey = [NSMutableArray new];
		if (deviceTime)
		{
			[stringsForKey addObject:[NSString stringWithFormat:@"device: <%@ (%@)>", deviceValue ?: @"nil", [deviceTime lfx_stringWithDateFormat:@"k:mm:ss.sss"]]];
		}
		if (clientTime)
		{
			[stringsForKey addObject:[NSString stringWithFormat:@"client: <%@ (%@)>", clientValue ?: @"nil", [clientTime lfx_stringWithDateFormat:@"k:mm:ss.sss"]]];
		}
		dict[aKey] = [stringsForKey componentsJoinedByString:@",  "];
	}
	return dict;
}

#pragma mark - Message Handling

- (void)handleMessage:(LFXMessage *)message
{
	if (message.messageSource == LFXMessageSourceDevice)
	{
		self.mostRecentMessageTimestamp = [NSDate new];
		[self updateReachability];
	}
	if (message.messageType == LX_PROTOCOL_DEVICE_STATE_TIME)
	{
		LFXMessageDeviceStateTime *stateTime = CastObject(LFXMessageDeviceStateTime, message);
		NSDate *date = NSDateFromLFXProtocolUnixTime(stateTime.payload.time);
		NSTimeInterval clockDelta = [date timeIntervalSinceNow];
		NSTimeInterval oldClockDelta = [[self propertyValueForKey:SelfKey(clockDelta)] doubleValue];
		NSTimeInterval newClockDelta = (clockDelta + oldClockDelta) * 0.5;
		if (oldClockDelta == 0.0) newClockDelta = clockDelta;
		[self setPropertyValue:@(newClockDelta) forKey:SelfKey(clockDelta) source:LFXPropertySourceDevice];
		LFXLogVerbose(@"Updating .clockDelta for %@ from %f to %f", self.deviceID, oldClockDelta, newClockDelta);
	}
	
	[self.messageHandlerProxy device:self didHandleMessage:message];
}

- (void)updateReachability
{
	LFXDeviceReachability newReachability = [self.mostRecentMessageTimestamp lfx_timeIntervalUpToNow] < 35 ? LFXDeviceReachabilityReachable : LFXDeviceReachabilityUnreachable;
	
	if (newReachability == _reachability) return;
	
	self.reachability = newReachability;
	[self didChangeReachability:newReachability];
}

- (void)didChangeReachability:(LFXDeviceReachability)reachability
{
	// To be overriden by subclasses
}

- (void)queryClock
{
	[self.networkContext sendMessage:[LFXMessageDeviceGetTime messageWithTarget:[LFXTarget deviceTargetWithDeviceID:self.deviceID] qosPriority:LFXMessageQosPriorityLow]];
}

- (NSTimeInterval)clockDelta
{
	NSNumber *number = [self propertyValueForKey:SelfKey(clockDelta)];
	if (number) return number.doubleValue;
	return 1.5;
}

- (NSDate *)deviceTimeForClientDeviceTime:(NSDate *)clientTime
{
	return [clientTime dateByAddingTimeInterval:self.clockDelta];
}

#pragma mark - Tasks

- (void)addPeriodicTask:(LFXPeriodicTask *)task
{
	[self.periodicTasks setObject:task forKey:task.taskID];
	[self runPeriodicTask:task];
}

- (void)removePeriodicTaskForTaskID:(NSString *)periodicTaskID
{
	[self.periodicTasks removeObjectForKey:periodicTaskID];
}

- (void)periodicTaskTimerDidFire
{
	[self updateReachability];
	
	if ([LFXClient sharedClient].quietModeIsEnabled) return;
	
	[self.periodicTasks enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[self runPeriodicTask:obj];
	}];
}

- (void)runPeriodicTask:(LFXPeriodicTask *)task
{
	if (task.runsWhenDeviceIsUnreachable || self.reachability == LFXDeviceReachabilityReachable)
	{
		task.taskBlock(self);
	}
}

@end
