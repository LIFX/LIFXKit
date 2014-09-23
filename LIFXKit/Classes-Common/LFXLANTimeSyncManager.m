//
//  LFXLANTimeSyncManager.m
//  LIFXKit
//
//  Created by Nick Forge on 4/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXLANTimeSyncManager.h"
#import "LXProtocol.h"
#import "LFXMacros.h"
#import "LFXBinaryTypes.h"
#import "NSDate+LFXExtensions.h"

@interface LFXLANTimeSyncManager ()

@property (nonatomic) LFXTransportManager *transportManager;

@end

@implementation LFXLANTimeSyncManager

- (id)initWithTransportManager:(LFXTransportManager *)transportManager
{
	if ((self = [super init]))
	{
		self.transportManager = transportManager;
		[transportManager addMessageObserverObject:self withCallback:^(LFXMessage *message) {
			if (message.messageType == LX_PROTOCOL_DEVICE_STATE_TIME)
			{
				LFXMessageDeviceStateTime *stateTime = CastObject(LFXMessageDeviceStateTime, message);
				NSDate *deviceTime = NSDateFromLFXProtocolUnixTime(stateTime.payload.time);
				if ([deviceTime lfx_timeIntervalUpToNow] > lfx_NSTimeIntervalWithDays(365))
				{
					LFXLogWarn(@"State Time received which is more than 1 year behind the local device (%@). Setting the time based on the current local system time (%@).", deviceTime, [NSDate date]);
					LFXMessageDeviceSetTime *setTime = [LFXMessageDeviceSetTime messageWithBinaryPath:stateTime.path];
					setTime.payload.time = LFXProtocolUnixTimeFromNSDate([NSDate new]);
					[self.transportManager sendMessage:setTime];
				}
			}
		}];
	}
	return self;
}

@end
