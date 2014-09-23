//
//  NSDate+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 10/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline NSTimeInterval lfx_NSTimeIntervalWithMinutes(double minutes)
{
	return 60.0 * minutes;
}

static inline NSTimeInterval lfx_NSTimeIntervalWithHours(double hours)
{
	return 60.0 * 60.0 * hours;
}

static inline NSTimeInterval lfx_NSTimeIntervalWithDays(double days)
{
	return 60.0 * 60.0 * 24.0 * days;
}

@interface NSDate (LFXExtensions)

// These are thread safe, since they use Thread Local NSDateFormatters
- (NSString *)lfx_stringWithDateFormatterTemplate:(NSString *)dateFormatterTemplate;
- (NSString *)lfx_stringWithDateFormat:(NSString *)dateFormat;

- (BOOL)lfx_isEarlierThanDate:(NSDate *)date;
- (BOOL)lfx_isLaterThanDate:(NSDate *)date;

- (BOOL)lfx_isEarlierThanNow;
- (BOOL)lfx_isLaterThanNow;

- (NSTimeInterval)lfx_timeIntervalUpToNow;
- (NSTimeInterval)lfx_timeIntervalUpToDate:(NSDate *)date;

@end
