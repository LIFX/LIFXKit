//
//  LFXRoutingTable.h
//  LIFX
//
//  Created by Nick Forge on 6/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXDeviceMapping, LFXTagMapping, LFXTarget, LFXMessage, LFXSiteID, LFXBinaryPath;
#import "LFXBinaryTypes.h"


@interface LFXRoutingTable : NSObject

@property (nonatomic, readonly) NSArray /* LFXDeviceMapping */ *deviceMappings;
@property (nonatomic, readonly) NSArray /* LFXTagMapping */ *tagMappings;
@property (nonatomic, readonly) NSArray /* LFXSiteID */ *siteIDs;


// Updating

- (void)updateMappingsFromMessage:(LFXMessage *)message didUpdateDeviceMappings:(BOOL *)didUpdateDeviceMappings didUpdateTagMappings:(BOOL *)didUpdateTagMappings didUpdateSiteIDs:(BOOL *)didUpdateSiteIDs;


// Removes all mappings + siteIDs
- (void)resetRoutingTable;


// Querying

- (NSSet /* NSString */ *)allTags;


- (LFXDeviceMapping *)deviceMappingForDeviceID:(NSString *)deviceID;
- (NSArray /* LFXDeviceMapping */ *)deviceMappingsForSiteID:(LFXSiteID *)siteID;
- (NSArray /* LFXDeviceMapping */ *)deviceMappingsForSiteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField;

- (LFXTagMapping *)tagMappingForSiteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField;
- (NSArray /* LFXTagMapping */ *)tagMappingsForTag:(NSString *)tag;
- (NSArray /* LFXTagMapping */ *)tagMappingsForSiteID:(LFXSiteID *)siteID tag:(NSString *)tag;


// Routing

// LFXTarget -> LFXBinaryPath (for outgoing messages)
- (NSArray /* LFXBinaryPath */ *)binaryPathsForTarget:(LFXTarget *)target;

// LFXBinaryPath -> DeviceID (NSString) (for incoming messages)
- (NSArray /* NSString */ *)deviceIDsForBinaryPath:(LFXBinaryPath *)binaryPath;

@end
