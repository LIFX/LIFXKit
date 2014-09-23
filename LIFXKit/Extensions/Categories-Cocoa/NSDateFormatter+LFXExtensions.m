//
//  NSDateFormatter+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 10/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "NSDateFormatter+LFXExtensions.h"

@implementation NSDateFormatter (LFXExtensions)

+ (instancetype)lfx_dateFormatterForTemplate:(NSString *)template
{
	return [self lfx_dateFormatterForTemplate:template locale:[NSLocale currentLocale]];
}

+ (instancetype)lfx_dateFormatterForTemplate:(NSString *)template locale:(NSLocale *)locale
{
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:template options:0 locale:locale];
	dateFormatter.locale = locale;
	return dateFormatter;
}

+ (instancetype)lfx_threadLocalDateFormatterForTemplate:(NSString *)template
{
	return [self lfx_threadLocalDateFormatterForTemplate:template locale:[NSLocale currentLocale]];
}

+ (instancetype)lfx_threadLocalDateFormatterForTemplate:(NSString *)template locale:(NSLocale *)locale
{
	NSString * const dateFormattersKey = @"NFTemplateDateFormatters";
	
	NSMutableDictionary *allFormatters = [[[NSThread currentThread] threadDictionary] objectForKey:dateFormattersKey];
	if (!allFormatters)
	{
		allFormatters = [NSMutableDictionary new];
		[[[NSThread currentThread] threadDictionary] setObject:allFormatters forKey:dateFormattersKey];
	}
	
	NSString *localeIdentifier = [locale localeIdentifier];
	NSMutableDictionary *formattersForLocale = allFormatters[localeIdentifier];
	if (!formattersForLocale)
	{
		formattersForLocale = [NSMutableDictionary new];
		allFormatters[localeIdentifier] = formattersForLocale;
	}
	
	NSDateFormatter *dateFormatter = formattersForLocale[template];
	if (!dateFormatter)
	{
		dateFormatter = [NSDateFormatter lfx_dateFormatterForTemplate:template locale:locale];
		formattersForLocale[template] = dateFormatter;
	}
	
	return dateFormatter;
}

+ (instancetype)lfx_dateFormatterForDateFormat:(NSString *)dateFormat
{
	return [self lfx_dateFormatterForDateFormat:dateFormat locale:[NSLocale currentLocale]];
}

+ (instancetype)lfx_dateFormatterForDateFormat:(NSString *)dateFormat locale:(NSLocale *)locale
{
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.dateFormat = dateFormat;
	dateFormatter.locale = locale;
	return dateFormatter;
}

+ (instancetype)lfx_threadLocalDateFormatterForDateFormat:(NSString *)dateFormat
{
	return [self lfx_threadLocalDateFormatterForDateFormat:dateFormat locale:[NSLocale currentLocale]];
}

+ (instancetype)lfx_threadLocalDateFormatterForDateFormat:(NSString *)dateFormat locale:(NSLocale *)locale
{
	NSString * const dateFormattersKey = @"NFDateFormatDateFormatters";
	
	NSMutableDictionary *allFormatters = [[[NSThread currentThread] threadDictionary] objectForKey:dateFormattersKey];
	if (!allFormatters)
	{
		allFormatters = [NSMutableDictionary new];
		[[[NSThread currentThread] threadDictionary] setObject:allFormatters forKey:dateFormattersKey];
	}
	
	NSString *localeIdentifier = [locale localeIdentifier];
	NSMutableDictionary *formattersForLocale = allFormatters[localeIdentifier];
	if (!formattersForLocale)
	{
		formattersForLocale = [NSMutableDictionary new];
		allFormatters[localeIdentifier] = formattersForLocale;
	}
	
	NSDateFormatter *dateFormatter = formattersForLocale[dateFormat];
	if (!dateFormatter)
	{
		dateFormatter = [NSDateFormatter lfx_dateFormatterForDateFormat:dateFormat locale:locale];
		formattersForLocale[dateFormat] = dateFormatter;
	}
	
	return dateFormatter;
}


@end
