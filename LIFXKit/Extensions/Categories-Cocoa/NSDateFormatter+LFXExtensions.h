//
//  NSDateFormatter+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 10/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (LFXExtensions)

+ (instancetype)lfx_dateFormatterForTemplate:(NSString *)templateString;
+ (instancetype)lfx_dateFormatterForTemplate:(NSString *)templateString locale:(NSLocale *)locale;

+ (instancetype)lfx_threadLocalDateFormatterForTemplate:(NSString *)templateString;
+ (instancetype)lfx_threadLocalDateFormatterForTemplate:(NSString *)templateString locale:(NSLocale *)locale;


+ (instancetype)lfx_dateFormatterForDateFormat:(NSString *)dateFormat;
+ (instancetype)lfx_dateFormatterForDateFormat:(NSString *)dateFormat locale:(NSLocale *)locale;

+ (instancetype)lfx_threadLocalDateFormatterForDateFormat:(NSString *)dateFormat;
+ (instancetype)lfx_threadLocalDateFormatterForDateFormat:(NSString *)dateFormat locale:(NSLocale *)locale;

@end
