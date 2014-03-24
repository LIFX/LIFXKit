//
//  LFXNetworkContext.m
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXNetworkContext.h"
#import "LFXAllLightsCollection.h"
#import "LFXDeviceMapping.h"
#import "LFXTagMapping.h"
#import "LFXTaggedLightCollection.h"
#import "LFXRoutingTable.h"
#import "LFXLight.h"
#import "LXProtocol.h"
#import "LFXTransportManager.h"
#import "LFXNetworkContext+Private.h"
#import "LFXLight+Private.h"
#import "LFXLightCollection+Private.h"
#import "LFXTaggedLightCollection+Private.h"
#import "LFXExtensions.h"
#import "LFXHSBKColor.h"
#import "LFXObserverProxy.h"
#import "LFXClient+Private.h"

@interface LFXNetworkContext () <LFXTransportManagerDelegate>

@property (nonatomic) LFXRoutingTable *routingTable;

@property (nonatomic) LFXTransportManager *transportManager;

// Lights and Light States
@property (nonatomic) LFXAllLightsCollection *allLightsCollection;
@property (nonatomic) NSMutableArray *mutableTaggedLightCollections;

@property (nonatomic) NSTimer *siteScanTimer;

@property (nonatomic) LFXObserverProxy <LFXNetworkContextObserver> *networkContextObserverProxy;

@end


@implementation LFXNetworkContext

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(name), SelfKey(isConnected)]];
}

- (BOOL)isConnected
{
	return self.transportManager.isConnected;
}

- (void)transportManagerDidConnect:(LFXTransportManager *)transportManager
{
	[self scanNetworkForLightStates];
	[self.networkContextObserverProxy networkContextDidConnect:self];
	[self.client lfx_networkContextDidConnect:self];
}

- (void)transportManagerDidDisconnect:(LFXTransportManager *)transportManager
{
	[self.networkContextObserverProxy networkContextDidDisconnect:self];
	[self.client lfx_networkContextDidDisconnect:self];
}

- (void)transportManager:(LFXTransportManager *)transportManager didConnectToGateway:(LFXGatewayDescriptor *)gatewayDescriptor
{
	[self scanNetworkForLightStates];
}

- (void)transportManager:(LFXTransportManager *)transportManager didDisconnectFromGateway:(LFXGatewayDescriptor *)gatewayDescriptor
{
	
}

- (NSArray *)taggedLightCollections
{
	return self.mutableTaggedLightCollections.copy;
}

- (void)siteScanTimerDidFire
{
	if (self.isConnected == NO) return;
	[self scanNetworkForLightStates];
}

- (void)handleMessage:(LFXMessage *)message
{
	[self.routingTable updateMappingsFromMessage:message];
	[self updateTaggedCollectionsFromRoutingTable];
	[self updateDeviceTagMembershipsFromRoutingTable];
	
	for (NSString *aDeviceID in [self.routingTable deviceIDsForBinaryPath:message.path])
	{
		[self forwardMessage:message toDeviceWithDeviceID:aDeviceID];
	}
}

- (void)forwardMessage:(LFXMessage *)message toDeviceWithDeviceID:(NSString *)deviceID
{
//	LFXLogVerbose(@"Forwarding message to '%@': %@", deviceID, message);
	LFXLight *light = [self.allLightsCollection lightForDeviceID:deviceID];
	if (light == nil && message.messageType == LX_PROTOCOL_LIGHT_STATE)
	{
		light = [LFXLight lightWithDeviceID:deviceID networkContext:self];
		[light handleMessage:message];
		[self.allLightsCollection lfx_addLight:light];
	}
	else
	{
		[light handleMessage:message];
	}
}

- (void)updateTaggedCollectionsFromRoutingTable
{
	// Remove any existing tags that don't have a mapping
	NSSet *tagsThatHaveMappings = [NSSet setWithArray:self.routingTable.allTags];
	
	for (LFXTaggedLightCollection *anExistingTaggedCollection in self.taggedLightCollections.copy)
	{
		if ([tagsThatHaveMappings containsObject:anExistingTaggedCollection.tag] == NO)
		{
			[self.mutableTaggedLightCollections removeObject:anExistingTaggedCollection];
			[self.networkContextObserverProxy networkContext:self didRemoveTaggedLightCollection:anExistingTaggedCollection];
		}
	}
	
	// Create any non-existant tags that do have a mapping
	NSMutableSet *tagsThatHaveACollection = [NSMutableSet setWithArray:[self.taggedLightCollections lfx_arrayByMapping:^id(LFXTaggedLightCollection *collection) { return collection.tag; }]];
	for (LFXTagMapping *aTagMapping in self.routingTable.tagMappings)
	{
		if ([tagsThatHaveACollection containsObject:aTagMapping.tag] == NO)
		{
			LFXTaggedLightCollection *newCollection = [LFXTaggedLightCollection lightCollectionWithNetworkContext:self];
			newCollection.lfx_tag = aTagMapping.tag;
			[self.mutableTaggedLightCollections addObject:newCollection];
			[tagsThatHaveACollection addObject:aTagMapping.tag];
			[self.networkContextObserverProxy networkContext:self didAddTaggedLightCollection:newCollection];
		}
	}
}

- (void)updateDeviceTagMembershipsFromRoutingTable
{
	// For each device, find out what tags it should be in
	for (LFXLight *aLight in self.allLightsCollection.lights)
	{
		// DeviceMapping tells us the SiteID and TagField of this device
		LFXDeviceMapping *deviceMapping = [self.routingTable deviceMappingForDeviceID:aLight.deviceID];

		// Now we need to find the tags corresponding to the SiteID and Tagfield
		NSArray *oldTaggedCollections = aLight.taggedCollections;
		
		NSMutableArray *tagsForThisLight = [NSMutableArray new];
		NSMutableArray *taggedCollectionsThisLightShouldBeIn = [NSMutableArray new];
		
		NSMutableArray *collectionsToAddThisLightTo = [NSMutableArray new];
		
		[LFXBinaryTargetID enumerateTagField:deviceMapping.tagField block:^(tagField_t singularTagField) {
			LFXTagMapping *tagMapping = [self.routingTable tagMappingForSiteID:deviceMapping.siteID tagField:singularTagField];
			if (!tagMapping) return;
			
			NSString *tag = tagMapping.tag;
			
			LFXTaggedLightCollection *collection = [self taggedLightCollectionForTag:tag];

			[tagsForThisLight addObject:tag];
			[taggedCollectionsThisLightShouldBeIn addObject:collection];
			
			if ([collection.lights containsObject:aLight] == NO)
			{
				[collectionsToAddThisLightTo addObject:collection];
			}
		}];
		
		NSMutableSet *collectionsToRemoveThisLightFrom = [NSMutableSet setWithArray:oldTaggedCollections];
		[collectionsToRemoveThisLightFrom minusSet:[NSSet setWithArray:taggedCollectionsThisLightShouldBeIn]];
		
		for (LFXTaggedLightCollection *aCollection in collectionsToRemoveThisLightFrom)
		{
			[aLight lfx_setTags:[aLight.tags lfx_arrayByRemovingObject:aCollection.tag]];
			[aLight lfx_setTaggedCollections:[aLight.taggedCollections lfx_arrayByRemovingObject:aCollection]];
			[aCollection lfx_removeLight:aLight];
		}
		
		for (LFXTaggedLightCollection *aCollection in collectionsToAddThisLightTo)
		{
			[aLight lfx_setTags:[aLight.tags arrayByAddingObject:aCollection.tag]];
			[aLight lfx_setTaggedCollections:[aLight.taggedCollections arrayByAddingObject:aCollection]];
			[aCollection lfx_addLight:aLight];
		}
	}
}

- (LFXTaggedLightCollection *)taggedLightCollectionForTag:(NSString *)tag
{
	return [self.taggedLightCollections lfx_firstObjectWhere:^BOOL(LFXTaggedLightCollection *collection) { return [collection.tag isEqualToString:tag]; }];
}

// Creates a new Tagged Light Collection
- (LFXTaggedLightCollection *)addTaggedLightCollectionWithTag:(NSString *)tag
{
	LFXTaggedLightCollection *existingCollection = [self taggedLightCollectionForTag:tag];
	if (existingCollection) return existingCollection;
	
	// Add the tag to each site
	for (LFXSiteID *aSiteID in self.routingTable.siteIDs)
	{
		[self addTag:tag toSiteWithSiteID:aSiteID];
	}
	return [self taggedLightCollectionForTag:tag];
}

- (void)addTag:(NSString *)tag toSiteWithSiteID:(LFXSiteID *)siteID
{
	tagField_t nextAvailableTagField = 0;
	for (NSUInteger tagIndex = 0; tagIndex < 64; tagIndex ++)
	{
		tagField_t tagField = 1 << tagIndex;
		if ([self.routingTable tagMappingForSiteID:siteID tagField:tagField] == nil)
		{
			nextAvailableTagField = tagField;
			break;
		}
	}
	if (nextAvailableTagField == 0)
	{
		LFXLogError(@"Unable to create tag '%@' in site %@, no available tag slots", tag, siteID.stringValue);
	}
	else
	{
		LFXLogError(@"Creating tag '%@' in site %@ with tagField %llx", tag, siteID.stringValue, nextAvailableTagField);
		LFXMessageDeviceSetTagLabels *setTagLabels = [LFXMessageDeviceSetTagLabels messageWithBinaryPath:[LFXBinaryPath broadcastBinaryPathWithSiteID:siteID]];
		setTagLabels.payload.tags = nextAvailableTagField;
		setTagLabels.payload.label = tag;
		[self sendMessage:setTagLabels];
	}
}

- (void)deleteTaggedLightCollection:(LFXTaggedLightCollection *)taggedLightCollection
{
	for (LFXLight *aLight in taggedLightCollection.lights)
	{
		[self removeLight:aLight fromTaggedLightCollection:taggedLightCollection];
	}
	
	for (LFXTagMapping *aTagMapping in [self.routingTable tagMappingsForTag:taggedLightCollection.tag])
	{
		LFXMessageDeviceSetTagLabels *setTagLabels = [LFXMessageDeviceSetTagLabels messageWithBinaryPath:[LFXBinaryPath broadcastBinaryPathWithSiteID:aTagMapping.siteID]];
		setTagLabels.payload.tags = aTagMapping.tagField;
		setTagLabels.payload.label = @"";
		[self sendMessage:setTagLabels];
	}
}

- (void)addNetworkContextObserver:(id <LFXNetworkContextObserver>)observer
{
	[self.networkContextObserverProxy addObserver:observer];
}

- (void)removeNetworkContextObserver:(id <LFXNetworkContextObserver>)observer
{
	[self.networkContextObserverProxy removeObserver:observer];
}

@end


@implementation LFXNetworkContext (Private)

- (instancetype)initWithClient:(LFXClient *)client transportManager:(LFXTransportManager *)transportManager name:(NSString *)name
{
	if ((self = [super init]))
	{
		_client = client;
		_name = name;
		_transportManager = transportManager;
		_transportManager.networkContext = self;
		_transportManager.delegate = self;
		_routingTable = [LFXRoutingTable new];
		_allLightsCollection = [LFXAllLightsCollection lightCollectionWithNetworkContext:self];
		_mutableTaggedLightCollections = [NSMutableArray new];
		_networkContextObserverProxy = LFXCreateObserverProxy(LFXNetworkContextObserver);
		
		MakeWeakRef(self, weakSelf);
		[_transportManager addMessageObserverObject:self withCallback:^(LFXMessage *message) {
			[weakSelf handleMessage:message];
		}];
		
		_siteScanTimer = [NSTimer scheduledTimerWithTimeInterval:LFXSiteScanTimerInterval target:self selector:@selector(siteScanTimerDidFire) userInfo:nil repeats:YES];
	}
	return self;
}

- (void)resetAllCaches
{
	[self.routingTable resetRoutingTable];
	[self.allLightsCollection lfx_removeAllLights];
	[self.mutableTaggedLightCollections removeAllObjects];
}

- (void)logEverything
{
	NSLog(@"Network Context: %@", self.name);
	NSLog(@"... Visible Sites:");
	for (LFXSiteID *aSiteID in self.routingTable.siteIDs)
	{
		NSLog(@"... ... %@", aSiteID.stringValue);
	}
	NSLog(@"... Tag Mappings:");
	for (LFXTagMapping *aTagMapping in self.routingTable.tagMappings)
	{
		NSLog(@"... ... %@\\%@    tag = '%@'", aTagMapping.siteID.stringValue, [NSString lfx_hexStringWithUInt64:aTagMapping.tagField], aTagMapping.tag);
	}
	NSLog(@"... Device Mappings:");
	for (LFXDeviceMapping *aDeviceMapping in self.routingTable.deviceMappings)
	{
		NSLog(@"... ... %@    site = %@ tagField = %@", aDeviceMapping.deviceID, aDeviceMapping.siteID.stringValue, [NSString lfx_hexStringWithUInt64:aDeviceMapping.tagField]);
	}
	NSLog(@"... Lights:");
	for (LFXLight *aLight in self.allLightsCollection.lights)
	{
		NSLog(@"... ... %@    color = %@  powerState = %@  label = '%@'  tags = %@", aLight.deviceID, aLight.color.stringValue, NSStringFromLFXPowerState(aLight.powerState), aLight.label, aLight.tags.lfx_singleLineDescription);
	}
	NSLog(@"... Groups:");
	for (LFXTaggedLightCollection *aGroup in self.taggedLightCollections)
	{
		NSLog(@"... ... '%@'    fuzzyPowerState = %@  lights = %@", aGroup.tag, NSStringFromLFXFuzzyPowerState(aGroup.fuzzyPowerState), [aGroup.lights lfx_arrayByMapping:^id(LFXLight *light) { return light.deviceID; }].lfx_singleLineDescription);
	}
}

- (void)sendMessage:(LFXMessage *)message
{
	// For messages that have their Target set
	if (message.target != nil)
	{
		for (LFXBinaryPath *aBinaryPath in [self.routingTable binaryPathsForTarget:message.target])
		{
			LFXMessage *newMessage = [message copy];
			newMessage.path = aBinaryPath;
			[self.transportManager sendMessage:newMessage];
		}
	}
	else // For message that have their Binary Path set explicitily (for internal use only)
	{
		[self.transportManager sendMessage:message];
	}
}

- (void)scanNetworkForLightStates
{
	[self sendMessage:[LFXMessageLightGet messageWithTarget:[LFXTarget broadcastTarget]]];
	LFXMessageDeviceGetTagLabels *getTagLabels = [LFXMessageDeviceGetTagLabels messageWithTarget:[LFXTarget broadcastTarget]];
	getTagLabels.payload.tags = ~0;
	[self sendMessage:getTagLabels];
	
	LFXRunBlockWithDelay(3.0, ^{
		[self sendMessage:[LFXMessageLightGet messageWithTarget:[LFXTarget broadcastTarget]]];
	});
}

- (void)addLight:(LFXLight *)light toTaggedLightCollection:(LFXTaggedLightCollection *)taggedLightCollection
{
	NSString *tag = taggedLightCollection.tag;
	LFXDeviceMapping *deviceMapping = [self.routingTable deviceMappingForDeviceID:light.deviceID];
	LFXSiteID *siteID = deviceMapping.siteID;
	LFXTagMapping *tagMapping = [self.routingTable tagMappingsForSiteID:siteID tag:tag].firstObject;
	
	if (!tagMapping)
	{
		[self addTag:tag toSiteWithSiteID:siteID];
		tagMapping = [self.routingTable tagMappingsForSiteID:siteID tag:tag].firstObject;
		if (!tagMapping)
		{
			LFXLogError(@"Couldn't add device %@ to tag '%@' since it couldn't be created in site %@", light, tag, siteID);
			return;
		}
	}
	
	LFXMessageDeviceSetTags *setTags = [LFXMessageDeviceSetTags messageWithTarget:light.target];
	setTags.payload.tags = deviceMapping.tagField | tagMapping.tagField;
	[self sendMessage:setTags];
}

- (void)removeLight:(LFXLight *)light fromTaggedLightCollection:(LFXTaggedLightCollection *)taggedLightCollection
{
	LFXDeviceMapping *deviceMapping = [self.routingTable deviceMappingForDeviceID:light.deviceID];
	LFXSiteID *siteID = deviceMapping.siteID;
	LFXTagMapping *tagMapping = [self.routingTable tagMappingsForSiteID:siteID tag:taggedLightCollection.tag].firstObject;
	
	LFXMessageDeviceSetTags *setTags = [LFXMessageDeviceSetTags messageWithTarget:light.target];
	setTags.payload.tags = deviceMapping.tagField & ~tagMapping.tagField;
	[self sendMessage:setTags];
}

- (BOOL)renameTaggedLightCollection:(LFXTaggedLightCollection *)collection withNewTag:(NSString *)newTag
{
	LFXTaggedLightCollection *existingTaggedCollectionWithNewTag = [self taggedLightCollectionForTag:newTag];
	if (existingTaggedCollectionWithNewTag)
	{
		LFXLogInfo(@"Tag '%@' already exists, aborting rename of '%@'", newTag, collection.tag);
		return NO;
	}
	
	LFXLogInfo(@"Renaming tag '%@' to '%@'", collection.tag, newTag);
	for (LFXTagMapping *aTagMapping in [self.routingTable tagMappingsForTag:collection.tag])
	{
		LFXMessageDeviceSetTagLabels *setTagLabels = [LFXMessageDeviceSetTagLabels messageWithBinaryPath:[LFXBinaryPath broadcastBinaryPathWithSiteID:aTagMapping.siteID]];
		setTagLabels.payload.tags = aTagMapping.tagField;
		setTagLabels.payload.label = newTag;
		[self sendMessage:setTagLabels];
	}
	return YES;
}

@end
