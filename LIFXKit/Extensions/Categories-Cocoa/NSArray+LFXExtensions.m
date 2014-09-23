//
//  NSArray+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 10/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "NSArray+LFXExtensions.h"

@implementation NSArray (LFXExtensions)

- (instancetype)lfx_sortedArrayUsingKey:(NSString *)key ascending:(BOOL)ascending
{
	return [self sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]]];
}

- (NSArray *)lfx_subArrayWithRangeIfItExists:(NSRange)range
{
	NSUInteger safeLocation = MIN(range.location, self.count);
	NSUInteger safeLength = MIN(range.length, self.count - safeLocation);
	return [self subarrayWithRange:NSMakeRange(safeLocation, safeLength)];
}

- (NSArray *)lfx_subArrayToIndexIfItExists:(NSUInteger)index
{
	NSUInteger safeIndex = MIN(index, self.count);
	return [self subarrayWithRange:NSMakeRange(0, safeIndex)];
}

- (id)lfx_objectAfterObject:(id)object
{
	NSUInteger index = [self indexOfObject:object];
	if (index == NSNotFound) return nil;
	index ++;
	if (index == self.count) return nil;
	return self[index];
}

- (NSArray *)lfx_arrayByMapping:(id (^)(id obj))block
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	for (id anObject in self)
	{
		id result = block(anObject);
		if (result) [array addObject:result];
	}
	return array;
}

+ (NSArray *)lfx_arrayWithContentsOfArrays:(NSArray *)arrays
{
	NSMutableArray *array = [NSMutableArray new];
	for (NSArray *anArray in arrays)
	{
		[array addObjectsFromArray:anArray];
	}
	return array;
}

- (NSArray *)lfx_arrayByRemovingObject:(id)object
{
	NSMutableArray *array = [self mutableCopy];
	[array removeObject:object];
	return array;
}

- (BOOL)lfx_anyObjectPasses:(BOOL (^)(id obj))block
{
	for (id anObject in self)
	{
		if (block(anObject)) return YES;
	}
	return NO;
}

- (id)lfx_firstObjectWhere:(BOOL (^)(id obj))block
{
	for (id anObject in self)
	{
		if (block(anObject)) return anObject;
	}
	return nil;
}

- (NSArray *)lfx_allObjectsWhere:(BOOL (^)(id obj))block
{
	NSMutableArray *array = [NSMutableArray new];
	for (id anObject in self)
	{
		if (block(anObject)) [array addObject:anObject];
	}
	return array;
}

- (NSInteger)lfx_numberOfObjectsPassing:(BOOL (^)(id obj))block
{
	NSInteger count = 0;
	for (id anObject in self)
	{
		if (block(anObject)) count ++;
	}
	return count;
}

- (id)lfx_objectAtIndexIfItExists:(NSUInteger)index
{
	if (index >= self.count) return nil;
	return self[index];
}

- (NSString *)lfx_singleLineDescription
{
	return [NSString stringWithFormat:@"[%@]", [[self valueForKeyPath:@"description"] componentsJoinedByString:@", "]];
}

- (NSSet *)lfx_set
{
	return [NSSet setWithArray:self];
}

@end

@implementation NSMutableArray (LFXExtensions)

- (void)lfx_sortUsingKey:(NSString *)key ascending:(BOOL)ascending
{
	return [self sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]]];
}

- (void)lfx_addObjectIfNonNil:(id)object
{
	if (object) [self addObject:object];
}

@end