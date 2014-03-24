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

@property (nonatomic, readonly) NSArray *deviceMappings;
@property (nonatomic, readonly) NSArray *tagMappings;
@property (nonatomic, readonly) NSArray *siteIDs;


// Updating

- (void)updateMappingsFromMessage:(LFXMessage *)message;


// Removes all mappings + siteIDs
- (void)resetRoutingTable;


// Querying

- (NSArray *)allTags;	// NSString objects


- (LFXDeviceMapping *)deviceMappingForDeviceID:(NSString *)deviceID;
- (NSArray *)deviceMappingsForSiteID:(LFXSiteID *)siteID;									// LFXDeviceMapping objects
- (NSArray *)deviceMappingsForSiteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField;		// LFXDeviceMapping objects

- (LFXTagMapping *)tagMappingForSiteID:(LFXSiteID *)siteID tagField:(tagField_t)tagField;
- (NSArray *)tagMappingsForTag:(NSString *)tag;												// LFXTagMapping objects
- (NSArray *)tagMappingsForSiteID:(LFXSiteID *)siteID tag:(NSString *)tag;					// LFXTagMapping objects


// Routing

// LFXTarget -> LFXBinaryPath (for outgoing messages)
- (NSArray *)binaryPathsForTarget:(LFXTarget *)target;	// LFXBinaryPath objects

// LFXBinaryPath -> DeviceID (NSString) (for incoming messages)
- (NSArray *)deviceIDsForBinaryPath:(LFXBinaryPath *)binaryPath;

@end
