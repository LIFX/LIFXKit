//
//  NSObject+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 18/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "NSObject+LFXExtensions.h"
#import "NSArray+LFXExtensions.h"

@implementation NSObject (LFXExtensions)

- (NSString *)lfx_descriptionWithPropertyKeys:(NSArray *)keys
{
	NSMutableString *string = [NSMutableString new];
	[string appendFormat:@"<%@: %p> {", NSStringFromClass(self.class), self];
	
	NSMutableArray *valueStrings = [NSMutableArray new];
	for (NSString *aKey in keys)
	{
		id value = [self valueForKeyPath:aKey];
		if (value)
		{
			id valueString = [value isKindOfClass:[NSArray class]] ? [(NSArray *)value lfx_singleLineDescription] : [value description];
			[valueStrings addObject:[NSString stringWithFormat:@"%@ = %@", aKey, valueString]];
		}
	}
	[string appendString:[valueStrings componentsJoinedByString:@", "]];
	[string appendString:@"}"];
	return string;
}

- (NSString *)lfx_multiLineDescriptionWithPropertyKeys:(NSArray *)keys
{
	NSInteger descriptionRecursionDepth = 0;
	for (NSString *aCallFrame in [NSThread callStackSymbols])
	{
		if ([aCallFrame rangeOfString:NSStringFromSelector(_cmd)].location != NSNotFound) descriptionRecursionDepth ++;
	}
	
	NSMutableString *string = [NSMutableString new];
	[string appendFormat:@"<%@: %p> {\n", NSStringFromClass(self.class), self];
	for (NSString *aKey in keys)
	{
		id value = [self valueForKey:aKey];
		if (value)
		{
			for (int i = 0; i < descriptionRecursionDepth; i ++) [string appendString:@"\t"];
			[string appendFormat:@"%@ = %@\n", aKey, value];
		}
	}
	for (int i = 0; i < descriptionRecursionDepth - 1; i ++) [string appendString:@"\t"];
	[string appendString:@"}"];
	return string;
}

- (NSArray *)lfx_propertyKeysForDescription
{
	return @[];
}

@end
