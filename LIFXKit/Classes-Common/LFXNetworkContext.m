//
//  LFXNetworkContext.m
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXNetworkContext.h"
#import "LFXAllLightsCollection.h"
#import "LFXUntaggedLightsCollection.h"
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
#import "LFXMessageRateManager.h"
#import "LFXDevice+Private.h"

NSString * const LFXNetworkContextErrorDomain = @"LFXNetworkContextErrorDomain";

NSString * const LFXNetworkContextTypeLocal = @"LFXNetworkContextTypeLocal";

@interface LFXNetworkContext () <LFXTransportManagerObserver>

@property (nonatomic) LFXRoutingTable *routingTable;

@property (nonatomic) LFXTransportManager *transportManager;

// Lights and Light States
@property (nonatomic) LFXAllLightsCollection *allLightsCollection;
@property (nonatomic) NSMutableArray *mutableTaggedLightCollections;

@property (nonatomic) NSTimer *siteScanTimer;

@property (nonatomic) LFXObserverProxy <LFXNetworkContextObserver> *networkContextObserverProxy;

@property (nonatomic) LFXMessageRateManager *messageRateManager;

@property (nonatomic) LFXUntaggedLightsCollection *internalUntaggedLightsCollection;

@property (nonatomic) NSMutableArray *synchronizedUpdatesStack;

@property (nonatomic) LFXConnectionState connectionState;

@end


@implementation LFXNetworkContext

- (NSString *)name
{
	@throw @"This needs to be overridden by subclasses";
}

- (NSString *)networkContextType
{
	@throw @"This needs to be overridden by subclasses";
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p (name = %@, isEnabled = %@, connectionState = %@)>", self.class, self, self.name, self.isEnabled ? @"Yes" : @"No", NSStringFromLFXConnectionState(self.connectionState)];
}

- (void)transportManager:(LFXTransportManager *)transportManager didChangeConnectionState:(LFXConnectionState)connectionState
{
	if (connectionState == self.connectionState) return;
	
	self.connectionState = connectionState;
	LFXLogInfo(@"Network Context %@ did change connection state: %@", self, NSStringFromLFXConnectionState(connectionState));
	[self.networkContextObserverProxy networkContext:self didChangeConnectionState:connectionState];
	
	if (connectionState == LFXConnectionStateConnected)
	{
		[self scanNetworkForLightStates];
	}
}

- (void)transportManager:(LFXTransportManager *)transportManager didConnectToGateway:(LFXGatewayDescriptor *)gatewayDescriptor
{
	[self scanNetworkForLightStates];
}

- (void)transportManager:(LFXTransportManager *)transportManager didDisconnectWithError:(NSError *)error
{
	[self.networkContextObserverProxy networkContext:self didDisconnectWithError:error];
}

- (BOOL)isEnabled
{
	return self.transportManager.isEnabled;
}

- (void)setIsEnabled:(BOOL)isEnabled
{
	LFXLogInfo(@"%@ network context: %@", isEnabled ? @"Enabling" : @"Disabling", self);
	self.transportManager.isEnabled = isEnabled;
	[self.networkContextObserverProxy networkContext:self didChangeIsEnabled:isEnabled];
}

- (NSArray *)taggedLightCollections
{
	return self.mutableTaggedLightCollections.copy;
}

- (void)siteScanTimerDidFire
{
	if (self.connectionState != LFXConnectionStateConnected) return;
	if (self.client.quietModeIsEnabled) return;
	
	[self sendBroadcastLightGet];
	[self sendBroadcastGetTagLabels];
}

- (void)handleMessage:(LFXMessage *)message
{
	BOOL didUpdateDeviceMappings = NO;
	BOOL didUpdateTagMappings = NO;
	BOOL didUpdateSiteIDs = NO;
	[self.routingTable updateMappingsFromMessage:message didUpdateDeviceMappings:&didUpdateDeviceMappings didUpdateTagMappings:&didUpdateTagMappings didUpdateSiteIDs:&didUpdateSiteIDs];
	if (didUpdateTagMappings)
	{
		[self updateTaggedCollectionsFromRoutingTable];
	}
	if (didUpdateDeviceMappings || didUpdateTagMappings)
	{
		[self updateDeviceTagMembershipsFromRoutingTable];
	}
	if (didUpdateSiteIDs)
	{
		[self scanNetworkForLightStates];
	}
	
	for (NSString *aDeviceID in [self.routingTable deviceIDsForBinaryPath:message.path])
	{
		[self forwardMessage:message toDeviceWithDeviceID:aDeviceID];
	}
}

- (void)forwardMessage:(LFXMessage *)message toDeviceWithDeviceID:(NSString *)deviceID
{
	LFXLight *light = [self.allLightsCollection lightForDeviceID:deviceID];
	if (message.path.siteID.isZeroSite)
	{
		if (light != nil)
		{
			[self.allLightsCollection lfx_removeLight:light];
		}
	}
	else if (light == nil && message.messageType == LX_PROTOCOL_LIGHT_STATE)
	{
		light = [LFXLight lightWithDeviceID:deviceID networkContext:self];
		[light handleMessage:message];
		[light queryClock];
		[self.allLightsCollection lfx_addLight:light];
		[self updateDeviceTagMembershipsFromRoutingTable];
	}
	else
	{
		[light handleMessage:message];
	}
}

- (void)updateTaggedCollectionsFromRoutingTable
{
	// Remove any existing tags that don't have a mapping
	NSSet *tagsThatHaveMappings = self.routingTable.allTags;
	
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
	// Possible future optimisation: most of the time, we only need to update the device-tag membership
	// for a single device, not for all devices (e.g. when we receive a LightState message).
	// Nick Forge - 23 Jul 2014
	
	// For each device, find out what tags it should be in
	for (LFXLight *aLight in self.allLightsCollection)
	{
		// DeviceMapping tells us the SiteID and TagField of this device
		LFXDeviceMapping *deviceMapping = [self.routingTable deviceMappingForDeviceID:aLight.deviceID];

		// Now we need to find the tags corresponding to the SiteID and Tagfield
		NSArray *oldTaggedCollections = aLight.taggedCollections;
		
		NSMutableArray *tagsForThisLight = [NSMutableArray new];
		NSMutableSet *taggedCollectionsThisLightShouldBeIn = [NSMutableSet new];
		
		NSMutableArray *collectionsToAddThisLightTo = [NSMutableArray new];
		
		[LFXBinaryTargetID enumerateTagField:deviceMapping.tagField block:^(tagField_t singularTagField) {
			LFXTagMapping *tagMapping = [self.routingTable tagMappingForSiteID:deviceMapping.siteID tagField:singularTagField];
			if (!tagMapping) return;
			
			NSString *tag = tagMapping.tag;
			
			LFXTaggedLightCollection *collection = [self taggedLightCollectionForTag:tag];

			[tagsForThisLight addObject:tag];
			[taggedCollectionsThisLightShouldBeIn addObject:collection];
			
			if ([collection containsLight:aLight] == NO)
			{
				[collectionsToAddThisLightTo addObject:collection];
			}
		}];
		
		NSMutableSet *collectionsToRemoveThisLightFrom = [NSMutableSet setWithArray:oldTaggedCollections];
		[collectionsToRemoveThisLightFrom minusSet:taggedCollectionsThisLightShouldBeIn];
		
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
        
        // Update this light's membership in the Untagged Lights collection
        if (tagsForThisLight.count == 0 && [self.internalUntaggedLightsCollection containsLight:aLight] == NO)
		{
			[self.internalUntaggedLightsCollection addLight:aLight];
        }
		if (tagsForThisLight.count > 0 && [self.internalUntaggedLightsCollection containsLight:aLight] == YES)
		{
			[self.internalUntaggedLightsCollection removeLight:aLight];
        }
	}
}

- (LFXTaggedLightCollection *)taggedLightCollectionForTag:(NSString *)tag
{
	return [self.mutableTaggedLightCollections lfx_firstObjectWhere:^BOOL(LFXTaggedLightCollection *collection) { return [collection.tag isEqualToString:tag]; }];
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
    // the removeLight:fromTaggedLightCollection: mutates the taggedLightCollection,
    // so we copy the light refs and enumerate the copy instead
    NSArray *taggedLights = [NSArray arrayWithArray:taggedLightCollection.lights];
    for (LFXLight *aLight in taggedLights)
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

- (void)sendBroadcastLightGet
{
	[self sendMessage:[LFXMessageLightGet messageWithTarget:[LFXTarget broadcastTarget]]];
}

- (void)sendBroadcastGetTagLabels
{
	LFXMessageDeviceGetTagLabels *getTagLabels = [LFXMessageDeviceGetTagLabels messageWithTarget:[LFXTarget broadcastTarget]];
	getTagLabels.payload.tags = ~0;
	[self sendMessage:getTagLabels];
}

- (LFXAdHocLightCollection *)createAdHocLightCollection
{
	return [LFXAdHocLightCollection lightCollectionWithNetworkContext:self];
}

- (LFXLightCollection *)untaggedLightsCollection
{
	return self.internalUntaggedLightsCollection;
}

@end

@implementation LFXNetworkContext (Deprecated)

- (BOOL)isConnected
{
	return self.connectionState == LFXConnectionStateConnected;
}

@end


@implementation LFXNetworkContext (Private)

- (instancetype)initWithClient:(LFXClient *)client
{
	if ((self = [super init]))
	{
		_client = client;
		_routingTable = [LFXRoutingTable new];
		_messageRateManager = [[LFXMessageRateManager alloc] initWithNetworkContext:self];
		_transportManager = [[[[self class] transportManagerClass] alloc] initWithNetworkContext:self];
		[_transportManager addTransportManagerObserver:self];
		_allLightsCollection = [LFXAllLightsCollection lightCollectionWithNetworkContext:self];
        _internalUntaggedLightsCollection = [LFXUntaggedLightsCollection lightCollectionWithNetworkContext:self];
		_mutableTaggedLightCollections = [NSMutableArray new];
		_synchronizedUpdatesStack = [NSMutableArray new];
		_networkContextObserverProxy = LFXCreateObserverProxy(LFXNetworkContextObserver);
		[_messageRateManager startObserving];
		
		_siteScanTimer = [NSTimer scheduledTimerWithTimeInterval:LFXSiteScanTimerInterval target:self selector:@selector(siteScanTimerDidFire) userInfo:nil repeats:YES];
		
		MakeWeakRef(self, weakSelf);
		[_transportManager addMessageObserverObject:self withCallback:^(LFXMessage *message) {
			[weakSelf handleMessage:message];
		}];
	}
	return self;
}

+ (Class)transportManagerClass
{
	@throw @"This needs to be overridden by subclasses";
}

- (void)resetAllCaches
{
	[self.routingTable resetRoutingTable];
	[self.allLightsCollection lfx_removeAllLights];
	[self.internalUntaggedLightsCollection removeAllLights];
	[self updateTaggedCollectionsFromRoutingTable];
	[self.transportManager reset];
}

- (void)logEverything
{
	NSLog(@"Network Context: %@", self.networkContextType);
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
	for (LFXLight *aLight in self.allLightsCollection)
	{
		NSLog(@"... ... %@    color = %@  powerState = %@  label = '%@'  tags = %@  mesh = %@ [%@]  wifi = %@ [%@]", aLight.deviceID, aLight.color.stringValue, NSStringFromLFXPowerState(aLight.powerState), aLight.label, aLight.tags.lfx_singleLineDescription, aLight.meshFirmwareVersion, [aLight.meshFirmwareBuild lfx_stringWithDateFormatterTemplate:@"yyyy MMM dd"], aLight.wifiFirmwareVersion, [aLight.wifiFirmwareBuild lfx_stringWithDateFormatterTemplate:@"yyyy MMM dd"]);
	}
	NSLog(@"... Groups:");
	for (LFXTaggedLightCollection *aGroup in self.taggedLightCollections)
	{
		NSLog(@"... ... '%@'    fuzzyPowerState = %@  lights = %@", aGroup.tag, NSStringFromLFXFuzzyPowerState(aGroup.fuzzyPowerState), [aGroup.lights lfx_arrayByMapping:^id(LFXLight *light) { return light.deviceID; }].lfx_singleLineDescription);
	}
}

- (void)sendMessage:(LFXMessage *)message
{
	NSMutableArray *synchronizedUpdates = self.synchronizedUpdatesStack.lastObject;
	if (synchronizedUpdates)
	{
		[synchronizedUpdates addObject:message];
	}
	else
	{
		[self actuallySendMessage:message];
	}
}

- (void)actuallySendMessage:(LFXMessage *)message
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
	if (self.connectionState != LFXConnectionStateConnected) return;
	if (self.client.quietModeIsEnabled) return;
	
	[self sendBroadcastLightGet];
	[self sendBroadcastGetTagLabels];
	LFXRunBlockWithDelay(3.0, ^{
		[self sendBroadcastLightGet];
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

- (void)beginSynchronizedUpdates
{
	[self.synchronizedUpdatesStack addObject:[NSMutableArray new]];
}

- (void)commitSynchronizedUpdates
{
	NSTimeInterval const timeSyncBuffer = 2.0;	// Adds a buffer to minimise the chances of waveforms being ignored due to being received "in the past" according to a device
	
	NSMutableArray *messages = self.synchronizedUpdatesStack.lastObject;
	NSTimeInterval timeForAllMessages = self.messageRateManager.messageRate * (messages.count + 1) + timeSyncBuffer;
	NSDate *atTime = [NSDate dateWithTimeIntervalSinceNow:timeForAllMessages];
	for (LFXMessage *aMessage in messages)
	{
		NSDate *adjustedAtTime = atTime;
		if (aMessage.target.targetType == LFXTargetTypeDevice)
		{
			LFXLight *light = [self.allLightsCollection lightForDeviceID:aMessage.target.deviceID];
			if (light)
			{
				adjustedAtTime = [light deviceTimeForClientDeviceTime:atTime];
			}
		}
		aMessage.atTime = LFXProtocolUnixTimeFromNSDate(adjustedAtTime);
		aMessage.qosPriority = LFXMessageQosPriorityHigh;
		if (aMessage.atTime == 0)
		{
			aMessage.atTime = LFXProtocolUnixTimeFromNSDate(atTime);
		}
		[self actuallySendMessage:aMessage];
	}
	
	[self.synchronizedUpdatesStack removeLastObject];
}

- (void)performSynchronizedUpdates:(void(^)())block
{
	[self beginSynchronizedUpdates];
	block();
	[self commitSynchronizedUpdates];
}


@end
