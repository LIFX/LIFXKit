//
//  NSObject+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 18/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LFXExtensions)

- (NSString *)lfx_descriptionWithPropertyKeys:(NSArray *)keys;
- (NSString *)lfx_multiLineDescriptionWithPropertyKeys:(NSArray *)keys;

- (NSArray *)lfx_propertyKeysForDescription;

@end
