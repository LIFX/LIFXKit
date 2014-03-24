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


- (void)updateSiteID:(LFXSiteID *)siteID;

- (void)updateDeviceMappingWithDeviceID:(NSString *)deviceID siteID:(LFXSiteID *)siteID;
- (void)updateDeviceMappingWithDeviceID:(NSString *)deviceID siteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField;

- (void)updateTagMappingWithTag:(NSString *)tag siteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField;



@end

@implementation LFXRoutingTable

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

- (void)updateMappingsFromMessage:(LFXMessage *)message
{
	if (message.isAResponseMessage)
	{
		[self updateSiteID:message.path.siteID];
		[self updateDeviceMappingWithDeviceID:message.path.targetID.stringValue siteID:message.path.siteID];
	}
	
	if (message.messageType == LX_PROTOCOL_LIGHT_STATE)
	{
		[self updateDeviceMappingWithDeviceID:message.path.targetID.stringValue siteID:message.path.siteID tagField:CastObject(LFXMessageLightState, message).payload.tags];
	}
	if (message.messageType == LX_PROTOCOL_DEVICE_STATE_TAGS)
	{
		[self updateDeviceMappingWithDeviceID:message.path.targetID.stringValue siteID:message.path.siteID tagField:CastObject(LFXMessageDeviceStateTags, message).payload.tags];
	}
	if (message.messageType == LX_PROTOCOL_DEVICE_SET_TAGS)
	{
		[self updateDeviceMappingWithDeviceID:message.path.targetID.stringValue siteID:message.path.siteID tagField:CastObject(LFXMessageDeviceSetTags, message).payload.tags];
	}
	if (message.messageType == LX_PROTOCOL_DEVICE_STATE_TAG_LABELS)
	{
		LFXMessageDeviceStateTagLabels *stateTagLabels = CastObject(LFXMessageDeviceStateTagLabels, message);
		[LFXBinaryTargetID enumerateTagField:stateTagLabels.payload.tags block:^(tagField_t singularTagField) {
			[self updateTagMappingWithTag:stateTagLabels.payload.label siteID:message.path.siteID tagField:singularTagField];
		}];
	}
	if (message.messageType == LX_PROTOCOL_DEVICE_SET_TAG_LABELS)
	{
		LFXMessageDeviceSetTagLabels *setTagLabels = CastObject(LFXMessageDeviceSetTagLabels, message);
		[LFXBinaryTargetID enumerateTagField:setTagLabels.payload.tags block:^(tagField_t singularTagField) {
			[self updateTagMappingWithTag:setTagLabels.payload.label siteID:message.path.siteID tagField:singularTagField];
		}];
	}
}

- (void)updateSiteID:(LFXSiteID *)siteID
{
	if ([self.mutableSiteIDs containsObject:siteID]) return;
	
	[self.mutableSiteIDs addObject:siteID];
}

- (void)updateDeviceMappingWithDeviceID:(NSString *)deviceID siteID:(LFXSiteID *)siteID
{
	LFXDeviceMapping *deviceMapping = [self deviceMappingForDeviceID:deviceID];
	if (!deviceMapping)
	{
		deviceMapping = [LFXDeviceMapping new];
		[self.mutableDeviceMappingsByDeviceID setObject:deviceMapping forKey:deviceID];
	}
	
	deviceMapping.deviceID = deviceID;
	deviceMapping.siteID = siteID;
}

- (void)updateDeviceMappingWithDeviceID:(NSString *)deviceID siteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField
{
	LFXDeviceMapping *deviceMapping = [self deviceMappingForDeviceID:deviceID];
	if (!deviceMapping)
	{
		deviceMapping = [LFXDeviceMapping new];
		[self.mutableDeviceMappingsByDeviceID setObject:deviceMapping forKey:deviceID];
	}
	
	deviceMapping.deviceID = deviceID;
	deviceMapping.siteID = siteID;
	deviceMapping.tagField = tagField;
}

- (void)updateTagMappingWithTag:(NSString *)tag siteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField
{
	if (siteID.isZeroSite) return;
	
	LFXTagMapping *tagMapping = [self tagMappingForSiteID:siteID tagField:tagField];
	
	if (tag.length > 0)
	{
		if (!tagMapping)
		{
			tagMapping = [LFXTagMapping new];
			[self.mutableTagMappings addObject:tagMapping];
		}
		tagMapping.tag = tag;
		tagMapping.siteID = siteID;
		tagMapping.tagField = tagField;
	}
	else
	{
		if (tagMapping)
		{
			[self.mutableTagMappings removeObject:tagMapping];
		}
	}
}

- (void)resetRoutingTable
{
	[self.mutableDeviceMappingsByDeviceID removeAllObjects];
	[self.mutableTagMappings removeAllObjects];
	[self.mutableSiteIDs removeAllObjects];
}

- (NSArray *)allTags
{
	return [self.mutableTagMappings lfx_arrayByMapping:^id(LFXTagMapping *mapping) { return mapping.tag; }];
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
	}
}

- (NSArray *)deviceIDsForBinaryPath:(LFXBinaryPath *)binaryPath
{
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
