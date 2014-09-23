//
//  LFXGatewayDiscoveryTable.h
//  LIFX
//
//  Created by Nick Forge on 13/10/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXGatewayDescriptor.h"
#import "LFXGatewayDiscoveryTableEntry.h"

@protocol LFXGatewayDiscoveryControllerDelegate;
@class LFXLocalTransportManager;


typedef NS_ENUM(NSUInteger, LFXGatewayDiscoveryMode) {
	LFXGatewayDiscoveryModeNormal,				// 30 seconds
	LFXGatewayDiscoveryModeActivelySearching,	// 1 second
	LFXGatewayDiscoveryModeDisabled,			// disabled
};


@interface LFXGatewayDiscoveryController : NSObject

+ (LFXGatewayDiscoveryController *)gatewayDiscoveryControllerWithLocalTransportManager:(LFXLocalTransportManager *)transportManager delegate:(id <LFXGatewayDiscoveryControllerDelegate>)delegate;

@property (nonatomic, weak) id <LFXGatewayDiscoveryControllerDelegate> delegate;

// This property will change how often DeviceGetPanGateway messages are broadcast
@property (nonatomic) LFXGatewayDiscoveryMode discoveryMode;

- (void)sendGatewayDiscoveryMessage;

- (NSArray *)allGatewayDiscoveryTableEntries;

- (void)removeAllGatewayDiscoveryTableEntries;

- (NSString *)diagnosticTextDump;

@end


@protocol LFXGatewayDiscoveryControllerDelegate <NSObject>

- (void)gatewayDiscoveryController:(LFXGatewayDiscoveryController *)table didUpdateEntry:(LFXGatewayDiscoveryTableEntry *)tableEntry entryIsNew:(BOOL)entryIsNew;

@end