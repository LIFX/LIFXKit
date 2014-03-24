//
//  LFXMessage.h
//  LIFX
//
//  Created by Nick Forge on 6/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXBinaryPath.h"
#import "LFXSiteID.h"
#import "LFXBinaryTargetID.h"
#import "LXProtocolTypes.h"
#import "LFXGatewayDescriptor.h"
#import "Structle.h"
#import "LFXTarget.h"
@class LFXGatewayDescriptor;

/*
 
 LFXMessage represents a message between a LIFX Client and a LIFX Device. The frame and
 routing information for each message is extracted using the structs in LXProtocol.h, and
 the payloads for protocol messages are found in the Structle-generated code in
 LXProtocolTypes. LXProtocolMessages contains LFXMessage subclasses which simply map the
 message names to their message type codes and Structle class that should be used to
 decode the payload for that message type.
 
 */


typedef LXProtocolType LFXMessageType;

typedef enum {
	LFXMessageDirectionIncoming,
	LFXMessageDirectionOutgoing,
} LFXMessageDirection;


@interface LFXMessage : NSObject <NSCopying>

// This is the factory method which should be used for data off the network.
// It will automatically select the correct class and handle parsing for you.
+ (LFXMessage *)messageWithMessageData:(NSData *)data;

// Designated Initialisers
- (instancetype)initWithMessageData:(NSData *)data;	// Use this to parse an incoming message
- (instancetype)init;								// Use this to create a new outgoing message

- (NSData *)messageDataRepresentation;




// Convenience Constructors
+ (instancetype)messageWithTarget:(LFXTarget *)target;

+ (instancetype)messageWithBinaryPath:(LFXBinaryPath *)path;


@property (nonatomic) NSDate *timestamp;		// When the message was received (incoming) or created (outgoing)

@property (nonatomic) LFXMessageDirection messageDirection;		// incoming/outgoing
@property (nonatomic) LFXGatewayDescriptor *gatewayDescriptor;	// will be set by the message router when sent/received

// Network host (this will be set by the Message Router to be the host of the receiving
// network connection). For outgoing messages, this will be nil.
@property (nonatomic) NSString *sourceNetworkHost;

+ (LFXMessageType)messageType;					// Subclasses should override this

- (LFXMessageType)messageType;					// Wrapper around +messageType


// This is a state message, from a device
- (BOOL)isAResponseMessage;

// For outgoing messages
@property (nonatomic) LFXTarget *target;


// LIFX Protocol Header Properties
@property (nonatomic) uint16_t size;
@property (nonatomic) uint16_t protocol;
@property (nonatomic) LFXBinaryPath *path;
@property (nonatomic) uint64_t atTime;

// Convenience Wrappers
@property (nonatomic, readonly) NSString *messageTypeAsString;


// Subclassing

@property (nonatomic) Structle *payload;
+ (Class)payloadClass;


- (NSString *)niceLoggingDescription;


// Non-protocol messages
@property (nonatomic) BOOL isNonProtocolMessage;
@property (nonatomic) NSData *rawData;


// Routing Preferences
@property (nonatomic) BOOL prefersUDPOverTCP;

@end

