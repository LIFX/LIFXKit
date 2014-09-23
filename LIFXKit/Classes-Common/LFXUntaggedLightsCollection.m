//
//  LFXUntaggedLightsCollection.m
//  LIFX
//
//  Created by Aaron Vernon on 6/4/14.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXUntaggedLightsCollection.h"

@interface LFXUntaggedLightsCollection ()

@end

@implementation LFXUntaggedLightsCollection

- (NSString *)label
{
	return @"Ungrouped";
}

- (BOOL)labelIsEditable
{
	return NO;
}

@end