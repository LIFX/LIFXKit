//
//  LFXLANTransportManager.h
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXTransportManager.h"
@class LFXGatewayConnection;

@interface LFXLANTransportManager : LFXTransportManager

@property (nonatomic, readonly) LFXGatewayConnection *broadcastUDPConnection;
@property (nonatomic, readonly) LFXGatewayConnection *peerToPeerUDPConnection;

- (void)sendBroadcastUDPMessage:(LFXMessage *)message;

@end
