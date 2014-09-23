//
//  LFXTarget.m
//  LIFX
//
//  Created by Nick Forge on 4/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXTarget.h"
#import "LFXExtensions.h"

@interface LFXTarget ()

@property (nonatomic) NSString *deviceID;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSArray *internalTargets;

@end

@implementation LFXTarget

+ (LFXTarget *)broadcastTarget
{
	LFXTarget *target = [LFXTarget new];
	target->_targetType = LFXTargetTypeBroadcast;
	return target;
}

+ (LFXTarget *)deviceTargetWithDeviceID:(NSString *)deviceID
{
	LFXTarget *target = [LFXTarget new];
	target->_targetType = LFXTargetTypeDevice;
	target->_deviceID = deviceID;
	return target;
}

+ (LFXTarget *)tagTargetWithTag:(NSString *)tag
{
	LFXTarget *target = [LFXTarget new];
	target->_targetType = LFXTargetTypeTag;
	target->_tag = tag;
	return target;
}

+ (LFXTarget *)compositeTargetWithTargets:(NSArray *)targets
{
	LFXTarget *target = [LFXTarget new];
	target->_targetType = LFXTargetTypeComposite;
	target->_internalTargets = targets;
	return target;
}

- (NSArray *)targets
{
	switch (self.targetType)
	{
		case LFXTargetTypeBroadcast:
		case LFXTargetTypeDevice:
		case LFXTargetTypeTag:
			return @[self];
		case LFXTargetTypeComposite:
			return self.internalTargets;
	}
}

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(stringValue)]];
}

- (NSString *)stringValue
{
	switch (self.targetType)
	{
		case LFXTargetTypeBroadcast:
			return @"*";
		case LFXTargetTypeTag:
			return [NSString stringWithFormat:@"#%@", self.tag];
		case LFXTargetTypeDevice:
			return self.deviceID;
		case LFXTargetTypeComposite:
			return [NSString stringWithFormat:@"&[%@]", [[self.internalTargets lfx_arrayByMapping:^id(LFXTarget *target) { return target.stringValue; }] componentsJoinedByString:@", "]];
	}
}

+ (LFXTarget *)targetWithString:(NSString *)string
{
	if (string.length == 0) return nil;
	
	NSScanner *scanner = [NSScanner scannerWithString:string];
	
	if ([scanner scanString:@"*" intoString:NULL]) return [LFXTarget broadcastTarget];
	
	if ([scanner scanString:@"#" intoString:NULL])
	{
		// Group Target
		return [LFXTarget tagTargetWithTag:[string substringFromIndex:1]];
	}
	else if ([scanner scanString:@"&" intoString:NULL])
	{
		LFXLogError(@"Error: parsing of a composite LFXTarget hasn't been implemented yet");
		return nil;
	}
	else
	{
		// Device Target
		return [LFXTarget deviceTargetWithDeviceID:string];
	}
}

- (NSUInteger)hash
{
	// This might be optimisable
	return self.targetType ^ self.tag.hash ^ self.deviceID.hash ^ self.internalTargets.hash;
}

- (BOOL)isEqual:(id)object
{
	LFXTarget *targetObj = CastObject(LFXTarget, object);
	if (!targetObj) return NO;
	if (self.targetType != targetObj.targetType) return NO;
	
	switch (self.targetType)
	{
		case LFXTargetTypeBroadcast:
			return YES;
		case LFXTargetTypeDevice:
			return [self.deviceID isEqualToString:targetObj.deviceID];
		case LFXTargetTypeTag:
			return [self.tag isEqualToString:targetObj.tag];
		case LFXTargetTypeComposite:
			return [self.internalTargets isEqualToArray:targetObj.internalTargets];
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	switch (self.targetType)
	{
		case LFXTargetTypeBroadcast:	return [LFXTarget broadcastTarget];
		case LFXTargetTypeDevice:		return [LFXTarget deviceTargetWithDeviceID:self.deviceID];
		case LFXTargetTypeTag:			return [LFXTarget tagTargetWithTag:self.tag];
		case LFXTargetTypeComposite:	return [LFXTarget compositeTargetWithTargets:self.internalTargets];
	}
}

@end
