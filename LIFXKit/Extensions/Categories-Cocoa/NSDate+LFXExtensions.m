//
//  NSDate+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 10/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "NSDate+LFXExtensions.h"
#import "NSDateFormatter+LFXExtensions.h"

@implementation NSDate (LFXExtensions)

- (NSString *)lfx_stringWithDateFormatterTemplate:(NSString *)dateFormatterTemplate
{
	NSDateFormatter *dateFormatter = [NSDateFormatter lfx_threadLocalDateFormatterForTemplate:dateFormatterTemplate];
	return [dateFormatter stringFromDate:self];
}

- (NSString *)lfx_stringWithDateFormat:(NSString *)dateFormat
{
	NSDateFormatter *dateFormatter = [NSDateFormatter lfx_threadLocalDateFormatterForDateFormat:dateFormat];
	return [dateFormatter stringFromDate:self];
}

- (BOOL)lfx_isEarlierThanDate:(NSDate *)date
{
	return [self timeIntervalSinceDate:date] < 0;
}

- (BOOL)lfx_isLaterThanDate:(NSDate *)date
{
	return [self timeIntervalSinceDate:date] > 0;
}

- (BOOL)lfx_isEarlierThanNow
{
	return [self lfx_isEarlierThanDate:[NSDate new]];
}

- (BOOL)lfx_isLaterThanNow
{
	return [self lfx_isLaterThanDate:[NSDate new]];
}

- (NSTimeInterval)lfx_timeIntervalUpToNow
{
	return -[self timeIntervalSinceNow];
}

- (NSTimeInterval)lfx_timeIntervalUpToDate:(NSDate *)date
{
	return [date timeIntervalSinceDate:self];
}

@end
