//
//  NSArray+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 10/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LFXExtensions)

- (NSArray *)lfx_sortedArrayUsingKey:(NSString *)key ascending:(BOOL)ascending;

- (NSArray *)lfx_subArrayWithRangeIfItExists:(NSRange)range;
- (NSArray *)lfx_subArrayToIndexIfItExists:(NSUInteger)index;

// Returns nil if <object> was the last object, or if it wasn't found
- (id)lfx_objectAfterObject:(id)object;

- (NSArray *)lfx_arrayByMapping:(id (^)(id obj))block;

+ (NSArray *)lfx_arrayWithContentsOfArrays:(NSArray *)arrays;

- (NSArray *)lfx_arrayByRemovingObject:(id)object;

- (id)lfx_firstObjectWhere:(BOOL (^)(id obj))block;
- (NSArray *)lfx_allObjectsWhere:(BOOL (^)(id obj))block;

- (BOOL)lfx_anyObjectPasses:(BOOL (^)(id obj))block;

- (id)lfx_objectAtIndexIfItExists:(NSUInteger)index;

- (NSString *)lfx_singleLineDescription;

- (NSSet *)lfx_set;

- (NSInteger)lfx_numberOfObjectsPassing:(BOOL (^)(id obj))block;

@end

@interface NSMutableArray (LFXExtensions)

- (void)lfx_sortUsingKey:(NSString *)key ascending:(BOOL)ascending;

- (void)lfx_addObjectIfNonNil:(id)object;

@end
