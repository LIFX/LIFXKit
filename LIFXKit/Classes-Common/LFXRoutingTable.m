//
//  LFXRoutingTable.m
//  LIFX
//
//  Created by Nick Forge on 6/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXRoutingTable.h"
#import "LFXTagMapping.h"
#import "LFXDeviceMapping.h"
#import "LXProtocol.h"
#import "LFXExtensions.h"

@interface LFXRoutingTable ()

@property (nonatomic) NSMutableDictionary *mutableDeviceMappingsByDeviceID;
@property (nonatomic) NSMutableArray *mutableTagMappings;
@property (nonatomic) NSMutableArray *mutableSiteIDs;	// Could be derived from DeviceMappings, but is cached separately for performance reasons


// These methods all return YES if there was an actual update
- (BOOL)updateSiteID:(LFXSiteID *)siteID;
- (BOOL)updateDeviceMappingWithDeviceID:(NSString *)deviceID siteID:(LFXSiteID *)siteID;
- (BOOL)updateDeviceMappingWithDeviceID:(NSString *)deviceID siteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField;
- (BOOL)updateTagMappingWithTag:(NSString *)tag siteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField;

@end

@implementation LFXRoutingTable

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(siteIDs), @{SelfKey(tagMappings): self.tagMappings.firstObject}]];
}

- (id)init
{
	if ((self = [super init]))
	{
		self.mutableDeviceMappingsByDeviceID = [NSMutableDictionary new];
		self.mutableTagMappings = [NSMutableArray new];
		self.mutableSiteIDs = [NSMutableArray new];
	}
	return self;
}

- (NSArray *)deviceMappings
{
	return self.mutableDeviceMappingsByDeviceID.allValues;
}

- (NSArray *)tagMappings
{
	return self.mutableTagMappings.copy;
}

- (NSArray *)siteIDs
{
	return self.mutableSiteIDs.copy;
}

- (void)updateMappingsFromMessage:(LFXMessage *)message didUpdateDeviceMappings:(BOOL *)didUpdateDeviceMappings didUpdateTagMappings:(BOOL *)didUpdateTagMappings didUpdateSiteIDs:(BOOL *)didUpdateSiteIDs
{
	BOOL deviceMappingsUpdated = NO;
	__block BOOL tagMappingsUpdated = NO;
	BOOL siteIDsUpdated = NO;
	
	if (message.messageSource == LFXMessageSourceDevice)
	{
		if ([self updateSiteID:message.path.siteID])
		{
			siteIDsUpdated = YES;
		}
		if ([self updateDeviceMappingWithDeviceID:message.path.targetID.stringValue siteID:message.path.siteID])
		{
			deviceMappingsUpdated = YES;
		}
	}
	
	if (message.messageType == LX_PROTOCOL_LIGHT_STATE)
	{
		if ([self updateDeviceMappingWithDeviceID:message.path.targetID.stringValue siteID:message.path.siteID tagField:CastObject(LFXMessageLightState, message).payload.tags])
		{
			deviceMappingsUpdated = YES;
		}
	}
	if (message.messageType == LX_PROTOCOL_DEVICE_STATE_TAGS)
	{
		if ([self updateDeviceMappingWithDeviceID:message.path.targetID.stringValue siteID:message.path.siteID tagField:CastObject(LFXMessageDeviceStateTags, message).payload.tags])
		{
			deviceMappingsUpdated = YES;
		}
	}
	if (message.messageType == LX_PROTOCOL_DEVICE_SET_TAGS)
	{
		if ([self updateDeviceMappingWithDeviceID:message.path.targetID.stringValue siteID:message.path.siteID tagField:CastObject(LFXMessageDeviceSetTags, message).payload.tags])
		{
			deviceMappingsUpdated = YES;
		}
	}
	if (message.messageType == LX_PROTOCOL_DEVICE_STATE_TAG_LABELS)
	{
		LFXMessageDeviceStateTagLabels *stateTagLabels = CastObject(LFXMessageDeviceStateTagLabels, message);
		[LFXBinaryTargetID enumerateTagField:stateTagLabels.payload.tags block:^(tagField_t singularTagField) {
			if ([self updateTagMappingWithTag:stateTagLabels.payload.label siteID:message.path.siteID tagField:singularTagField])
			{
				tagMappingsUpdated = YES;
			}
		}];
	}
	if (message.messageType == LX_PROTOCOL_DEVICE_SET_TAG_LABELS)
	{
		LFXMessageDeviceSetTagLabels *setTagLabels = CastObject(LFXMessageDeviceSetTagLabels, message);
		[LFXBinaryTargetID enumerateTagField:setTagLabels.payload.tags block:^(tagField_t singularTagField) {
			if ([self updateTagMappingWithTag:setTagLabels.payload.label siteID:message.path.siteID tagField:singularTagField])
			{
				tagMappingsUpdated = YES;
			}
		}];
	}
	*didUpdateDeviceMappings = deviceMappingsUpdated;
	*didUpdateTagMappings = tagMappingsUpdated;
	*didUpdateSiteIDs = siteIDsUpdated;
}

- (BOOL)updateSiteID:(LFXSiteID *)siteID
{
	if ([self.mutableSiteIDs containsObject:siteID]) return NO;
	
	[self.mutableSiteIDs addObject:siteID];
	return YES;
}

- (BOOL)updateDeviceMappingWithDeviceID:(NSString *)deviceID siteID:(LFXSiteID *)siteID
{
	LFXDeviceMapping *deviceMapping = [self deviceMappingForDeviceID:deviceID];
	if (!deviceMapping)
	{
		deviceMapping = [LFXDeviceMapping new];
		[self.mutableDeviceMappingsByDeviceID setObject:deviceMapping forKey:deviceID];
	}
	
	if ([deviceMapping.deviceID isEqualToString:deviceID] &&
		[deviceMapping.siteID isEqual:siteID]) return NO;
	
	deviceMapping.deviceID = deviceID;
	deviceMapping.siteID = siteID;
	
	return YES;
}

- (BOOL)updateDeviceMappingWithDeviceID:(NSString *)deviceID siteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField
{
	LFXDeviceMapping *deviceMapping = [self deviceMappingForDeviceID:deviceID];
	if (!deviceMapping)
	{
		deviceMapping = [LFXDeviceMapping new];
		[self.mutableDeviceMappingsByDeviceID setObject:deviceMapping forKey:deviceID];
	}
	
	if ([deviceMapping.deviceID isEqualToString:deviceID] &&
		[deviceMapping.siteID isEqual:siteID] &&
		deviceMapping.tagField == tagField) return NO;
	
	deviceMapping.deviceID = deviceID;
	deviceMapping.siteID = siteID;
	deviceMapping.tagField = tagField;
	
	return YES;
}

- (BOOL)updateTagMappingWithTag:(NSString *)tag siteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField
{
	if (siteID.isZeroSite) return NO;
	
	LFXTagMapping *tagMapping = [self tagMappingForSiteID:siteID tagField:tagField];
	
	if (tag.length > 0)
	{
		if (!tagMapping)
		{
			tagMapping = [LFXTagMapping new];
			[self.mutableTagMappings addObject:tagMapping];
		}
		
		if ([tagMapping.tag isEqualToString:tag] &&
			[tagMapping.siteID isEqual:siteID] &&
			tagMapping.tagField == tagField) return NO;
		
		tagMapping.tag = tag;
		tagMapping.siteID = siteID;
		tagMapping.tagField = tagField;
		
		return YES;
	}
	else
	{
		if (tagMapping)
		{
			[self.mutableTagMappings removeObject:tagMapping];
			return YES;
		}
	}
	
	return NO;
}

- (void)resetRoutingTable
{
	[self.mutableDeviceMappingsByDeviceID removeAllObjects];
	[self.mutableTagMappings removeAllObjects];
	[self.mutableSiteIDs removeAllObjects];
}

- (NSSet *)allTags
{
	return [self.mutableTagMappings lfx_arrayByMapping:^id(LFXTagMapping *mapping) { return mapping.tag; }].lfx_set;
}

- (NSArray *)allSiteIDs
{
	return self.mutableSiteIDs.copy;
}

- (LFXDeviceMapping *)deviceMappingForDeviceID:(NSString *)deviceID
{
	return [self.mutableDeviceMappingsByDeviceID objectForKey:deviceID];
}

- (NSArray *)deviceMappingsForSiteID:(LFXSiteID *)siteID
{
	return [self.mutableDeviceMappingsByDeviceID.allValues lfx_allObjectsWhere:^BOOL(LFXDeviceMapping *mapping) { return [mapping.siteID isEqual:siteID]; }];
}

- (NSArray *)deviceMappingsForSiteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField
{
	return [self.mutableDeviceMappingsByDeviceID.allValues lfx_allObjectsWhere:^BOOL(LFXDeviceMapping *mapping) { return tagField == mapping.tagField && [mapping.siteID isEqual:siteID]; }];
}

- (LFXTagMapping *)tagMappingForSiteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField
{
	return [self.mutableTagMappings lfx_firstObjectWhere:^BOOL(LFXTagMapping *mapping) { return [mapping.siteID isEqual:siteID] && mapping.tagField == tagField; }];
}

- (NSArray *)tagMappingsForTag:(NSString *)tag
{
	return [self.mutableTagMappings lfx_allObjectsWhere:^BOOL(LFXTagMapping *mapping) { return [mapping.tag isEqualToString:tag]; }];
}

- (NSArray *)tagMappingsForSiteID:(LFXSiteID *)siteID tag:(NSString *)tag
{
	return [self.mutableTagMappings lfx_allObjectsWhere:^BOOL(LFXTagMapping *mapping) { return [mapping.siteID isEqual:siteID] && [mapping.tag isEqualToString:tag]; }];
}

- (NSArray *)binaryPathsForTarget:(LFXTarget *)target
{
	switch (target.targetType)
	{
		case LFXTargetTypeBroadcast:
		{
			// If there's no known sites, use the zero SiteID
			if (self.mutableSiteIDs.count == 0) return @[[LFXBinaryPath broadcastBinaryPathWithSiteID:[LFXSiteID zeroSiteID]]];
			// Return the broadcast for each site we know about
			return [self.mutableSiteIDs lfx_arrayByMapping:^id(LFXSiteID *siteID) {
				return [LFXBinaryPath pathWithSiteID:siteID targetID:[LFXBinaryTargetID broadcastTargetID]];
			}];
		}
		case LFXTargetTypeDevice:
		{
			// If we know what site the device is in, send it there, otherwise
			// send to each
			LFXDeviceMapping *deviceMapping = [self deviceMappingForDeviceID:target.deviceID];
			
			if (deviceMapping)
			{
				LFXBinaryPath *binaryPath = [LFXBinaryPath pathWithSiteID:deviceMapping.siteID targetID:[LFXBinaryTargetID deviceTargetIDWithString:target.deviceID]];
				return @[binaryPath];
			}
			
			return [self.mutableSiteIDs lfx_arrayByMapping:^id(LFXSiteID *siteID) {
				return [LFXBinaryPath pathWithSiteID:siteID targetID:[LFXBinaryTargetID deviceTargetIDWithString:target.deviceID]];
			}];
		}
		case LFXTargetTypeTag:
		{
			// Look up the Tag Mappings
			NSMutableArray *binaryPaths = [NSMutableArray new];
			for (LFXTagMapping *aTagMapping in [self tagMappingsForTag:target.tag])
			{
				[binaryPaths addObject:[LFXBinaryPath pathWithSiteID:aTagMapping.siteID targetID:[LFXBinaryTargetID groupTargetIDWithTagField:aTagMapping.tagField]]];
			}
			return binaryPaths;
		}
		case LFXTargetTypeComposite:
		{
			NSMutableArray *binaryPaths = [NSMutableArray new];
			for (LFXTarget *aTarget in target.targets)
			{
				[binaryPaths addObjectsFromArray:[self binaryPathsForTarget:aTarget]];
			}
			return binaryPaths;
		}
	}
}

- (NSArray *)deviceIDsForBinaryPath:(LFXBinaryPath *)binaryPath
{
	if (!binaryPath) return @[];
	switch (binaryPath.targetID.targetType)
	{
		case LFXBinaryTargetTypeBroadcast:
		{
			return [[self deviceMappingsForSiteID:binaryPath.siteID] lfx_arrayByMapping:^id(LFXDeviceMapping *mapping) { return mapping.deviceID; }];
		}
		case LFXBinaryTargetTypeDevice:
		{
			return @[binaryPath.targetID.stringValue];
		}
		case LFXBinaryTargetTypeTag:
		{
			return [[self deviceMappingsForSiteID:binaryPath.siteID tagField:binaryPath.targetID.groupTagField] lfx_arrayByMapping:^id(LFXDeviceMapping *mapping) { return mapping.deviceID; }];
		}
	}
}

@end
