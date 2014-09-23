//
//  LFXTypes.m
//  LIFX
//
//  Created by Nick Forge on 23/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXTypes.h"

NSString *NSStringFromLFXDeviceReachability(LFXDeviceReachability reachability)
{
	switch (reachability)
	{
		case LFXDeviceReachabilityReachable:	return @"Reachable";
		case LFXDeviceReachabilityUnreachable:	return @"Unreachable";
	}
}

NSString *NSStringFromLFXConnectionState(LFXConnectionState connectionState)
{
	switch (connectionState)
	{
		case LFXConnectionStateConnected:		return @"Connected";
		case LFXConnectionStateConnecting:		return @"Connecting";
		case LFXConnectionStateNotConnected:	return @"Not Connected";
	}
}

LFXFuzzyPowerState LFXFuzzyPowerStateFromPowerState(LFXPowerState powerState)
{
	switch (powerState)
	{
		case LFXPowerStateOff:	return LFXFuzzyPowerStateOff;
		case LFXPowerStateOn:	return LFXFuzzyPowerStateOn;
	}
}



NSString *NSStringFromLFXPowerState(LFXPowerState powerState)
{
	switch (powerState)
	{
		case LFXPowerStateOn:	return @"On";
		case LFXPowerStateOff:	return @"Off";
	}
}

NSString *NSStringFromLFXFuzzyPowerState(LFXFuzzyPowerState powerState)
{
	switch (powerState)
	{
		case LFXFuzzyPowerStateOn:		return @"On";
		case LFXFuzzyPowerStateOff:		return @"Off";
		case LFXFuzzyPowerStateMixed:	return @"Mixed";
	}
}
