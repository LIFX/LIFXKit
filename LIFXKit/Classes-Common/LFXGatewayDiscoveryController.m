//
//  LFXGatewayDiscoveryTable.m
//  LIFX
//
//  Created by Nick Forge on 13/10/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXGatewayDiscoveryController.h"
#import "LFXWiFiObserver.h"
#import "LFXLocalTransportManager.h"
#import "LXProtocol.h"
#import "LFXNetworkContext.h"
#import "LFXExtensions.h"
#import "LFXClient+Private.h"

@interface LFXGatewayDiscoveryController () {
	
}

@property (nonatomic) NSTimer *discoveryTimer;

@property (nonatomic) LFXLocalTransportManager *transportManager;
@property (nonatomic) NSMutableArray *table;

@end

@implementation LFXGatewayDiscoveryController

+ (LFXGatewayDiscoveryController *)gatewayDiscoveryControllerWithLocalTransportManager:(LFXLocalTransportManager *)transportManager delegate:(id <LFXGatewayDiscoveryControllerDelegate>)delegate
{
	LFXGatewayDiscoveryController *discoveryTable = [LFXGatewayDiscoveryController new];
	discoveryTable->_table = [NSMutableArray new];
	discoveryTable->_transportManager = transportManager;
	discoveryTable->_delegate = delegate;
	MakeWeakRef(discoveryTable, weakDiscoveryTable);
	[discoveryTable.transportManager addMessageObserverObject:self withCallback:^(LFXMessage *message) {
		if (message.messageType != LX_PROTOCOL_DEVICE_STATE_PAN_GATEWAY) return;
		[weakDiscoveryTable handleStatePANGatewayMessage:(LFXMessageDeviceStatePanGateway *)message];
	}];
	discoveryTable->_discoveryMode = LFXGatewayDiscoveryModeNormal;
	[discoveryTable configureTimerForDiscoveryMode:discoveryTable.discoveryMode];
	return discoveryTable;
}

- (NSArray *)allGatewayDiscoveryTableEntries
{
	return self.table.copy;
}

- (void)removeAllGatewayDiscoveryTableEntries
{
	[self.table removeAllObjects];
}

- (NSString *)diagnosticTextDump
{
	NSMutableString *string = [NSMutableString new];
	
	for (LFXGatewayDiscoveryTableEntry *anEntry in self.table)
	{
		NSTimeInterval secondsAgo = [anEntry.lastDiscoveryResponseDate lfx_timeIntervalUpToNow];
		NSString *timeAgo;
		if (secondsAgo < 60) {
			timeAgo = [NSString stringWithFormat:@"%0.0fs", secondsAgo];
		}
		else if (secondsAgo < 60 * 60) {
			timeAgo = [NSString stringWithFormat:@"%0.0fm", secondsAgo/60.0];
		}
		else {
			timeAgo = @">1h";
		}
		[string appendFormat:@"%@:%hu %@ %@ (%@)\n", anEntry.gatewayDescriptor.host, anEntry.gatewayDescriptor.port, anEntry.gatewayDescriptor.protocolString, anEntry.gatewayDescriptor.path.debugStringValue, timeAgo];
	}
	
	return string;
}

- (void)handleStatePANGatewayMessage:(LFXMessageDeviceStatePanGateway *)statePanGateway
{
	if ([[LFXWiFiObserver sharedObserver].currentBSSID.lfx_stringByStandardizingMACAddress hasPrefix:[NSString lfx_LIFXOUIInMACFormat]]) return;
	
	LFXGatewayDescriptor *gatewayDescriptor = [LFXGatewayDescriptor gatewayDescriptorWithHost:statePanGateway.gatewayDescriptor.host port:statePanGateway.payload.port path:statePanGateway.path service:statePanGateway.payload.service];
	
	LFXGatewayDiscoveryTableEntry *tableEntry = [self.table lfx_firstObjectWhere:^BOOL(LFXGatewayDiscoveryTableEntry *entry) { return [entry.gatewayDescriptor isEqual:gatewayDescriptor]; }];
	
	if (tableEntry)
	{
		tableEntry.lastDiscoveryResponseDate = [NSDate new];
		[self.delegate gatewayDiscoveryController:self didUpdateEntry:tableEntry entryIsNew:NO];
	}
	else
	{
		tableEntry = [LFXGatewayDiscoveryTableEntry new];
		tableEntry.gatewayDescriptor = gatewayDescriptor;
		tableEntry.lastDiscoveryResponseDate = [NSDate new];
		[self.table addObject:tableEntry];
		[self.delegate gatewayDiscoveryController:self didUpdateEntry:tableEntry entryIsNew:YES];
	}
}

- (void)sendGatewayDiscoveryMessage
{
	if (CastObject(LFXTransportManager, self.delegate).networkContext.client.quietModeIsEnabled) return;
	
	LFXLogVerbose(@"Sending Gateway Discovery Message");
	LFXMessageDeviceGetPanGateway *getPANGateway = [LFXMessageDeviceGetPanGateway messageWithBinaryPath:[LFXBinaryPath broadcastBinaryPathWithSiteID:[LFXSiteID zeroSiteID]]];
	[self.transportManager sendBroadcastUDPMessage:getPANGateway];
}

- (void)setDiscoveryMode:(LFXGatewayDiscoveryMode)discoveryMode
{
	if (_discoveryMode == discoveryMode) return;
	_discoveryMode = discoveryMode;
	[self configureTimerForDiscoveryMode:_discoveryMode];
}

- (void)configureTimerForDiscoveryMode:(LFXGatewayDiscoveryMode)discoveryMode
{
	NSTimeInterval duration;
	switch (discoveryMode)
	{
		case LFXGatewayDiscoveryModeNormal:
			duration = 30.0;
			break;
		case LFXGatewayDiscoveryModeActivelySearching:
			duration = 1.0;
			break;
		case LFXGatewayDiscoveryModeDisabled:
			duration = 0.0;
			break;
	}
	
	[self.discoveryTimer invalidate];
	if (duration > 0.0)
	{
		self.discoveryTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(discoveryTimerDidFire:) userInfo:nil repeats:YES];
	}
}

- (void)discoveryTimerDidFire:(NSTimer *)timer
{
	[self sendGatewayDiscoveryMessage];
}

@end
