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


typedef NS_ENUM(NSInteger, LFXMessageQosPriority) {
    LFXMessageQosPriorityLow = -1,
    LFXMessageQosPriorityNormal = 0,
	LFXMessageQosPriorityHigh = 1,
};


/*
 
 LFXMessage represents a message between a LIFX Client and a LIFX Device. The frame and
 routing information for each message is extracted using the structs in LXProtocol.h, and
 the payloads for protocol messages are found in the Structle-generated code in
 LXProtocolTypes. LXProtocolMessages contains LFXMessage subclasses which simply map the
 message names to their message type codes and Structle class that should be used to
 decode the payload for that message type.
 
 */


typedef LXProtocolType LFXMessageType;


NSString * NSStringFromLFXMessageType(LFXMessageType messageType);


typedef NS_ENUM(NSInteger, LFXMessageDirection) {
	LFXMessageDirectionIncoming,
	LFXMessageDirectionOutgoing,
};


typedef NS_ENUM(NSInteger, LFXMessageSource) {
	LFXMessageSourceDevice,
	LFXMessageSourceClient,
};

@interface LFXMessage : NSObject <NSCopying>


+ (LFXMessageType)messageType;									// Subclasses will override this
@property (nonatomic, readonly) LFXMessageType messageType;		// Wrapper around +messageType


@property (nonatomic, readonly) LFXMessageDirection messageDirection;	// Incoming/Outgoing
@property (nonatomic, readonly) LFXMessageSource messageSource;			// Device/Client


@property (nonatomic) LFXGatewayDescriptor *gatewayDescriptor;		// Will be set by the Gateway Connection the message is sent/received from



// For incoming and outgoing messages
@property (nonatomic) LFXBinaryPath *path;




// LIFX Protocol Header Properties
@property (nonatomic) uint16_t size;
@property (nonatomic) uint16_t protocol;
@property (nonatomic) uint64_t atTime;


@property (nonatomic) Structle *payload;



//--------------------------
//
//	Incoming Messages
//



// This is the factory method that should be used for data off the network.
// It will automatically select the correct LFXMessage subclass.
+ (LFXMessage *)messageWithMessageData:(NSData *)data;





//--------------------------
//
//	Outgoing Messages
//

@property (nonatomic) LFXTarget *target;
@property (nonatomic) NSInteger qosPriority;

// Convenience Constructors for Outgoing Messages
+ (instancetype)messageWithTarget:(LFXTarget *)target;
+ (instancetype)messageWithTarget:(LFXTarget *)target qosPriority:(NSInteger)qosPriority;

+ (instancetype)messageWithBinaryPath:(LFXBinaryPath *)path;


// Returns the message in binary protocol format to be sent over the wire
- (NSData *)messageDataRepresentation;






// Subclassing

+ (Class)payloadClass;


- (NSString *)niceLoggingDescription;

@end

