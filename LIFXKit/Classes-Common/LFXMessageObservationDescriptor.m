//
//  LFXMessageObservationDescriptor.m
//  LIFX
//
//  Created by Nick Forge on 18/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXMessageObservationDescriptor.h"
#import "LFXExtensions.h"

@interface LFXMessageObservationDescriptor ()

@property (nonatomic, unsafe_unretained) id observingObjectUnsafeReference;

@end

@implementation LFXMessageObservationDescriptor

- (void)setObservingObject:(id)observingObject
{
	_observingObject = observingObject;
	_observingObjectUnsafeReference = observingObject;
}

- (BOOL)observingObjectWasEqualTo:(id)object
{
	return _observingObjectUnsafeReference == object;
}

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(observingObject), SelfKey(callback)]];
}

@end
