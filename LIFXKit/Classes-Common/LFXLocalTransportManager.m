//
//  LFXLocalTransportManager.m
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXLocalTransportManager.h"
#import "LFXGatewayConnection.h"
#import "LFXGatewayDiscoveryController.h"
#import "LXProtocolTypes.h"
#import "LFXExtensions.h"
#import "LFXLANTimeSyncManager.h"
#import "LFXNetworkContext+Private.h"

@interface LFXLocalTransportManager () <LFXGatewayConnectionDelegate, LFXGatewayDiscoveryControllerDelegate>

@property (nonatomic) LFXGatewayDiscoveryController *gatewayDiscoveryController;

@property (nonatomic) LFXGatewayConnection *broadcastUDPConnection;
@property (nonatomic) LFXGatewayConnection *peerToPeerUDPConnection;

@property (nonatomic) NSMutableDictionary *gatewayConnections;	// Keyed by .gatewayDescriptor

@property (nonatomic) LFXLANTimeSyncManager *timeSyncManager;

@end

@implementation LFXLocalTransportManager

- (id)initWithNetworkContext:(LFXNetworkContext *)networkContext
{
	if ((self = [super initWithNetworkContext:networkContext]))
	{
		self.gatewayConnections = [NSMutableDictionary new];
		self.gatewayDiscoveryController = [LFXGatewayDiscoveryController gatewayDiscoveryControllerWithLocalTransportManager:self delegate:self];
		[self updateGatewayDiscoveryMode];
		self.timeSyncManager = [[LFXLANTimeSyncManager alloc] initWithTransportManager:self];
		
		[self setupInitialConnections];
		
#if TARGET_OS_IPHONE
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
			[self.gatewayDiscoveryController sendGatewayDiscoveryMessage];
		}];
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
			[self destroyTCPConnections];
		}];
#endif
	}
	return self;
}

- (void)didSetIsEnabled:(BOOL)isEnabled
{
	if (isEnabled)
	{
		if (self.connectionState == LFXConnectionStateNotConnected)
		{
			[self didChangeConnectionState:LFXConnectionStateConnecting];
		}
	}
	else
	{
		[self didChangeConnectionState:LFXConnectionStateNotConnected];
		[self destroyAllGatewayConnections];
	}
	[self updateGatewayDiscoveryMode];
}

- (void)destroyTCPConnections
{
	for (LFXGatewayConnection *aConnection in self.gatewayConnections.allValues)
	{
		if (aConnection.gatewayDescriptor.service == LX_PROTOCOL_DEVICE_SERVICE_TCP)
		{
			[aConnection disconnect];
		}
	}
}

- (BOOL)shouldIgnoreTCPConnections
{
#if TARGET_OS_IPHONE
	return [UIApplication sharedApplication].applicationState != UIApplicationStateActive;
#endif
	return NO;
}

- (void)setupBroadcastUDPConnection
{
	self.broadcastUDPConnection = [LFXGatewayConnection gatewayConnectionWithGatewayDescriptor:[LFXGatewayDescriptor broadcastGatewayDescriptor] messageRateManager:self.networkContext.messageRateManager delegate:self];
	[self.broadcastUDPConnection connect];
}

- (void)destroyBroadcastUDPConnection
{
	self.broadcastUDPConnection.delegate = nil;
	[self.broadcastUDPConnection disconnect];
	self.broadcastUDPConnection = nil;
}

- (void)setupPeerToPeerUDPConnection
{
	self.peerToPeerUDPConnection = [LFXGatewayConnection gatewayConnectionWithGatewayDescriptor:[LFXGatewayDescriptor clientPeerToPeerGatewayDescriptor] messageRateManager:self.networkContext.messageRateManager delegate:self];
	[self.peerToPeerUDPConnection connect];
}

- (void)destroyPeerToPeerUDPConnection
{
	self.peerToPeerUDPConnection.delegate = nil;
	[self.peerToPeerUDPConnection disconnect];
	self.peerToPeerUDPConnection = nil;
}

- (void)setupInitialConnections
{
	[self setupBroadcastUDPConnection];
	[self setupPeerToPeerUDPConnection];
	[self.gatewayDiscoveryController sendGatewayDiscoveryMessage];
}

- (void)reset
{
	for (LFXGatewayConnection *aConnection in self.gatewayConnections.allValues)
	{
		[aConnection disconnect];
	}
	[self.gatewayConnections removeAllObjects];
	[self didChangeConnectionState:LFXConnectionStateConnecting];
	[self updateGatewayDiscoveryMode];
}

- (void)destroyAllConnections
{
	[self destroyAllGatewayConnections];
	[self destroyBroadcastUDPConnection];
	[self destroyPeerToPeerUDPConnection];
}

- (void)destroyAllGatewayConnections
{
	for (LFXGatewayConnection *aConnection in self.gatewayConnections.allValues)
	{
		[aConnection disconnect];
	}
	[self.gatewayConnections removeAllObjects];
}

- (void)connectionStatesDidChange
{
	BOOL aGatewayIsConnected = [self.gatewayConnections.allValues lfx_anyObjectPasses:^BOOL(LFXGatewayConnection *connection) {
		return connection.connectionState == LFXConnectionStateConnected;
	}];

	LFXConnectionState connectionState = aGatewayIsConnected ? LFXConnectionStateConnected : LFXConnectionStateConnecting;
	
	[self didChangeConnectionState:connectionState];
	[self updateGatewayDiscoveryMode];
	[self logConnectionStates];
}

- (void)updateGatewayDiscoveryMode
{
	if (self.isEnabled)
	{
		if (self.connectionState == LFXConnectionStateConnected)
		{
			self.gatewayDiscoveryController.discoveryMode = LFXGatewayDiscoveryModeNormal;
		}
		else
		{
			self.gatewayDiscoveryController.discoveryMode = LFXGatewayDiscoveryModeActivelySearching;
		}
	}
	else
	{
		self.gatewayDiscoveryController.discoveryMode = LFXGatewayDiscoveryModeDisabled;
	}
}

- (void)logConnectionStates
{
	LFXLogVerbose(@"Current Connections:");
	LFXLogVerbose(@"... Broadcast UDP: %@", self.broadcastUDPConnection);
	LFXLogVerbose(@"... Peer to Peer UDP: %@", self.peerToPeerUDPConnection);
	LFXLogVerbose(@"... Gateway Connections:");
	for (LFXGatewayConnection *aConnection in self.gatewayConnections.allValues)
	{
		LFXLogVerbose(@"... ... %@", aConnection);
	}
}

#pragma mark - Message Sending

- (void)sendMessage:(LFXMessage *)message
{
	[super sendMessage:message];
	if (message.path.siteID.isZeroSite)
	{
		for (NSString *aGatewayHost in [self gatewayHosts])
		{
			LFXGatewayConnection *tcpConnection = [self gatewayConnectionForHost:aGatewayHost service:LX_PROTOCOL_DEVICE_SERVICE_TCP];
			LFXGatewayConnection *udpConnection = [self gatewayConnectionForHost:aGatewayHost service:LX_PROTOCOL_DEVICE_SERVICE_UDP];
			
			NSMutableArray *connections = [NSMutableArray new];
			[connections lfx_addObjectIfNonNil:tcpConnection];
			[connections lfx_addObjectIfNonNil:udpConnection];
			LFXGatewayConnection *connectionToUse = connections.firstObject;
			if (connectionToUse)
			{
				[self sendMessage:message onConnection:connectionToUse];
			}
		}
	}
	else
	{
		BOOL messageWasSent = NO;
		for (NSString *aGatewayHost in [self gatewayHostsForSiteID:message.path.siteID])
		{
			LFXGatewayConnection *tcpConnection = [self gatewayConnectionForHost:aGatewayHost service:LX_PROTOCOL_DEVICE_SERVICE_TCP];
			LFXGatewayConnection *udpConnection = [self gatewayConnectionForHost:aGatewayHost service:LX_PROTOCOL_DEVICE_SERVICE_UDP];
			
			NSMutableArray *connections = [NSMutableArray new];
			[connections lfx_addObjectIfNonNil:tcpConnection];
			[connections lfx_addObjectIfNonNil:udpConnection];
			LFXGatewayConnection *connectionToUse = connections.firstObject;
			if (connectionToUse)
			{
				[self sendMessage:message onConnection:connectionToUse];
				messageWasSent = YES;
			}
		}
		if (messageWasSent == NO)
		{
			[self sendMessage:message onConnection:self.broadcastUDPConnection];
		}
	}
	
	[self sendMessage:message onConnection:self.peerToPeerUDPConnection];
	[self didSendMessage:message];
}

- (void)sendBroadcastUDPMessage:(LFXMessage *)message
{
	[self sendMessage:message onConnection:self.broadcastUDPConnection];
	[self didSendMessage:message];
}

- (void)sendMessage:(LFXMessage *)message onConnection:(LFXGatewayConnection *)connection
{
	[connection sendMessage:message.copy];
}

- (NSArray *)gatewayDescriptorsForSiteID:(LFXSiteID *)siteID
{
	return [self.gatewayConnections.allKeys lfx_allObjectsWhere:^BOOL(LFXGatewayDescriptor *gateway) { return [gateway.path.siteID isEqual:siteID]; }];
}

- (NSSet *)gatewayHostsForSiteID:(LFXSiteID *)siteID
{
	return [[[self gatewayDescriptorsForSiteID:siteID] lfx_arrayByMapping:^id(LFXGatewayDescriptor *gateway) { return gateway.host; }] lfx_set];
}

- (NSSet *)gatewayHosts
{
	return [[self.gatewayConnections.allKeys lfx_arrayByMapping:^id(LFXGatewayDescriptor *gateway) { return gateway.host; }] lfx_set];
}

- (LFXGatewayConnection *)gatewayConnectionForHost:(NSString *)host service:(LXProtocolDeviceService)service
{
	return [self.gatewayConnections.allValues lfx_firstObjectWhere:^BOOL(LFXGatewayConnection *connection) { return connection.gatewayDescriptor.service == service && [connection.gatewayDescriptor.host isEqualToString:host]; }];
}

- (NSArray /* LFXGatewayConnection */ *)allGatewayConnections
{
	return self.gatewayConnections.allValues;
}

#pragma mark - LFXGatewayConnectionDelegate

- (void)gatewayConnectionDidConnect:(LFXGatewayConnection *)connection
{
	LFXLogInfo(@"Connection %@ did connect", connection);
	[self connectionStatesDidChange];
	[self didConnectToGateway:connection.gatewayDescriptor];
}

- (void)gatewayConnection:(LFXGatewayConnection *)connection didDisconnectWithError:(NSError *)error
{
	LFXLogInfo(@"Connection %@ did disconnect: %@", connection, error.localizedDescription);
	if (connection == self.broadcastUDPConnection)
	{
		[self destroyBroadcastUDPConnection];
		[self performSelector:@selector(setupBroadcastUDPConnection) withObject:nil afterDelay:1.0];
	}
	else if (connection == self.peerToPeerUDPConnection)
	{
		[self destroyPeerToPeerUDPConnection];
		[self performSelector:@selector(setupPeerToPeerUDPConnection) withObject:nil afterDelay:3.0];
	}
	else
	{
		[self.gatewayConnections removeObjectForKey:connection.gatewayDescriptor];
	}
	[self connectionStatesDidChange];
	[self didConnectToGateway:connection.gatewayDescriptor];
}

- (void)gatewayConnection:(LFXGatewayConnection *)connection didReceiveMessage:(LFXMessage *)message fromHost:(NSString *)host
{
	[self didReceiveMessage:message];
}

#pragma mark - LFXGatewayDiscoveryControllerDelegate

- (void)gatewayDiscoveryController:(LFXGatewayDiscoveryController *)table didUpdateEntry:(LFXGatewayDiscoveryTableEntry *)tableEntry entryIsNew:(BOOL)entryIsNew
{
	LFXLogVerbose(@"Received %@ gateway discovery entry: %@", entryIsNew ? @"a new" : @"an updated", tableEntry);
	
	LFXGatewayDescriptor *gateway = tableEntry.gatewayDescriptor;
	if (gateway.port == 0)
	{
		LFXLogVerbose(@"Service %@/%@:%u unavailable (port == 0), ignoring", gateway.protocolString, gateway.host, gateway.port);
		return;
	}

	if (gateway.service == LX_PROTOCOL_DEVICE_SERVICE_TCP)
	{
		BOOL ignoreAllTCP = YES;
		if (ignoreAllTCP || [self shouldIgnoreTCPConnections])
		{
			LFXLogVerbose(@"Ignoring TCP Service on LAN");
			return;
		}
	}
	
	LFXGatewayConnection *existingConnection = self.gatewayConnections[gateway];
	if (existingConnection == nil)
	{
		if (self.isEnabled == NO)
		{
			LFXLogInfo(@"Ignoring DeviceStatePanGateway, Local Network Context is not enabled");
			return;
		}
		
		LFXLogInfo(@"Service %@/%@:%u has no existing connection, connecting", gateway.protocolString, gateway.host, gateway.port);
		LFXGatewayConnection *newConnection = [LFXGatewayConnection gatewayConnectionWithGatewayDescriptor:gateway messageRateManager:self.networkContext.messageRateManager delegate:self];
		self.gatewayConnections[gateway] = newConnection;
		[newConnection connect];
		[self connectionStatesDidChange];
	}
}

@end
