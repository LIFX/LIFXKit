//
//  LFXLANTransportManager.m
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXLANTransportManager.h"
#import "LFXGatewayConnection.h"
#import "LFXGatewayDiscoveryController.h"
#import "LXProtocolTypes.h"
#import "LFXExtensions.h"

@interface LFXLANTransportManager () <LFXGatewayConnectionDelegate, LFXGatewayDiscoveryControllerDelegate>

@property (nonatomic) LFXGatewayDiscoveryController *gatewayDiscoveryController;

@property (nonatomic) LFXGatewayConnection *broadcastUDPConnection;
@property (nonatomic) LFXGatewayConnection *peerToPeerUDPConnection;

@property (nonatomic) NSMutableDictionary *gatewayConnections;	// Keyed by .gatewayDescriptor

@end

@implementation LFXLANTransportManager

- (id)init
{
	if ((self = [super init]))
	{
		self.gatewayDiscoveryController = [LFXGatewayDiscoveryController gatewayDiscoveryControllerWithLANTransportManager:self delegate:self];
		self.gatewayConnections = [NSMutableDictionary new];
		[self setupBroadcastUDPConnection];
		[self setupPeerToPeerUDPConnection];
		
		self.gatewayDiscoveryController.discoveryMode = LFXGatewayDiscoveryModeActivelySearching;
		
		[self.gatewayDiscoveryController sendGatewayDiscoveryMessage];
	}
	return self;
}

- (void)setupBroadcastUDPConnection
{
	self.broadcastUDPConnection = [LFXGatewayConnection gatewayConnectionWithGatewayDescriptor:[LFXGatewayDescriptor broadcastGatewayDescriptor] delegate:self];
	[self.broadcastUDPConnection connect];
}

- (void)setupPeerToPeerUDPConnection
{
	self.peerToPeerUDPConnection = [LFXGatewayConnection gatewayConnectionWithGatewayDescriptor:[LFXGatewayDescriptor clientPeerToPeerGatewayDescriptor] delegate:self];
	[self.peerToPeerUDPConnection connect];
}

- (void)connectionStatesDidChange
{
	BOOL newIsConnected = NO;
	for (LFXGatewayConnection *aGatewayConnection in self.gatewayConnections.allValues)
	{
		if (aGatewayConnection.connectionState == LFXGatewayConnectionStateConnected)
		{
			newIsConnected = YES;
			break;
		}
	}
	
	self.isConnected = newIsConnected;
	
	self.gatewayDiscoveryController.discoveryMode = self.isConnected ? LFXGatewayDiscoveryModeNormal : LFXGatewayDiscoveryModeActivelySearching;
	
	[self logConnectionStates];
}

- (void)logConnectionStates
{
	LFXLogError(@"Current Connections:");
	LFXLogError(@"... Broadcast UDP: %@", self.broadcastUDPConnection);
	LFXLogError(@"... Peer to Peer UDP: %@", self.peerToPeerUDPConnection);
	LFXLogError(@"... Gateway Connections:");
	for (LFXGatewayConnection *aConnection in self.gatewayConnections.allValues)
	{
		LFXLogError(@"... ... %@", aConnection);
	}
}

#pragma mark - Message Sending

- (void)sendMessage:(LFXMessage *)message
{
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
			if (message.prefersUDPOverTCP)
			{
				[connections lfx_addObjectIfNonNil:udpConnection];
				[connections lfx_addObjectIfNonNil:tcpConnection];
			}
			else
			{
				[connections lfx_addObjectIfNonNil:tcpConnection];
				[connections lfx_addObjectIfNonNil:udpConnection];
			}
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
	[self sendObserverCallbacksForMessage:message];
}

- (void)sendBroadcastUDPMessage:(LFXMessage *)message
{
	[self sendMessage:message onConnection:self.broadcastUDPConnection];
	[self sendObserverCallbacksForMessage:message];
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

#pragma mark - LFXGatewayConnectionDelegate

- (void)gatewayConnectionDidConnect:(LFXGatewayConnection *)connection
{
	LFXLogInfo(@"Connection %@ did connect", connection);
	[self connectionStatesDidChange];
	[self.delegate transportManager:self didConnectToGateway:connection.gatewayDescriptor];
}

- (void)gatewayConnection:(LFXGatewayConnection *)connection didDisconnectWithError:(NSError *)error
{
	LFXLogInfo(@"Connection %@ did disconnect: %@", connection, error.localizedDescription);
	if (connection == self.broadcastUDPConnection)
	{
		[self.broadcastUDPConnection disconnect];
		self.broadcastUDPConnection.delegate = nil;
		[self performSelector:@selector(setupBroadcastUDPConnection) withObject:nil afterDelay:1.0];
	}
	else if (connection == self.peerToPeerUDPConnection)
	{
		[self.peerToPeerUDPConnection disconnect];
		self.peerToPeerUDPConnection.delegate = nil;
		[self performSelector:@selector(setupPeerToPeerUDPConnection) withObject:nil afterDelay:3.0];
	}
	else
	{
		[self.gatewayConnections removeObjectForKey:connection.gatewayDescriptor];
	}
	[self connectionStatesDidChange];
	[self.delegate transportManager:self didDisconnectFromGateway:connection.gatewayDescriptor];
}

- (void)gatewayConnection:(LFXGatewayConnection *)connection didReceiveMessage:(LFXMessage *)message fromHost:(NSString *)host
{
	host = host.lfx_IPv4StringByStrippingIPv6Prefix;
	
	message.gatewayDescriptor = connection.gatewayDescriptor;
	message.sourceNetworkHost = host;
	[self sendObserverCallbacksForMessage:message];
}

#pragma mark - LFXGatewayDiscoveryControllerDelegate

- (void)gatewayDiscoveryController:(LFXGatewayDiscoveryController *)table didUpdateEntry:(LFXGatewayDiscoveryTableEntry *)tableEntry entryIsNew:(BOOL)entryIsNew
{
	LFXLogVerbose(@"Received %@ gateway discovery entry: %@", entryIsNew ? @"a new" : @"an updated", tableEntry);
	
	LFXGatewayDescriptor *gateway = tableEntry.gatewayDescriptor;
	if (gateway.port == 0)
	{
		LFXLogInfo(@"Service %@/%@:%u unavailable (port == 0), ignoring", gateway.protocolString, gateway.host, gateway.port);
		return;
	}
	
	LFXGatewayConnection *existingConnection = self.gatewayConnections[gateway];
	if (existingConnection == nil)
	{
		LFXLogInfo(@"Service %@/%@:%u has no existing connection, connecting", gateway.protocolString, gateway.host, gateway.port);
		LFXGatewayConnection *newConnection = [LFXGatewayConnection gatewayConnectionWithGatewayDescriptor:gateway delegate:self];
		[newConnection connect];
		self.gatewayConnections[gateway] = newConnection;
		[self connectionStatesDidChange];
	}
}

@end
