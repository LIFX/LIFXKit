//
//  LFXMessage.m
//  LIFX
//
//  Created by Nick Forge on 6/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXMessage.h"
#import "LXProtocol.h"
#import "LFXExtensions.h"


@interface LFXMessage ()

// Designated Initialisers
- (instancetype)init;								// Use this to create a new outgoing message
- (instancetype)initWithMessageData:(NSData *)data;	// Use this to parse an incoming message

+ (Class)subclassForMessageType:(LFXMessageType)messageType;

@end

@implementation LFXMessage

+ (Class)subclassForMessageType:(LFXMessageType)messageType
{
	static NSDictionary *subclassesByMessageTypeDictionary;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary *lookupTable = [NSMutableDictionary new];
		NSArray *classes = lfx_ClassGetSubclasses([LFXMessage class]);
		for (Class aSubclass in classes)
		{
			LFXMessageType aMessageType = [(LFXMessage *)aSubclass messageType];
			if (aMessageType != 0) {
				lookupTable[@(aMessageType)] = aSubclass;
			}
			else {
				LFXLogWarn(@"Warning: LFXMessage subclass %@ returned a messageType of 0", NSStringFromClass(aSubclass));
			}
		}
		subclassesByMessageTypeDictionary = lookupTable;
	});
	return subclassesByMessageTypeDictionary[@(messageType)];
}

+ (LFXMessage *)messageWithMessageData:(NSData *)data
{
	uint8_t bytes[data.length];
	[data getBytes:bytes];
	
	lx_frame_t frame = *((lx_frame_t *) &bytes);
	if (!frame.addressable)
	{
		// We don't know how to deal with non-addressable messages, but the bulbs are sometimes not setting this flag correctly
		LFXLogWarn(@"Warning: Message claims to be non-addressable: %@", data);
		return nil;
	}
	
	lx_protocol_t protocol = *((lx_protocol_t*)&bytes);
	if (frame.protocol != LX_PROTOCOL_V1)
	{
//		LFXLogWarn(@"Handling non-protocol message of protocol %i", frame.protocol);
		return [[LFXMessage alloc] initWithNonProtocolMessageData:data];
	}
	
	Class class = [self subclassForMessageType:protocol.type];
	if (!class)
	{
		LFXLogError(@"ERROR: unknown message type '%i'. The appropriate class may need to be registered in %s", protocol.type, __PRETTY_FUNCTION__);
		class = [LFXMessage class];
	}
	return [[class alloc] initWithMessageData:data];
}

- (instancetype)initWithMessageData:(NSData *)data
{
	if ((self = [super init]))
	{
		_messageDirection = LFXMessageDirectionIncoming;
		
		uint8_t bytes[data.length];
		[data getBytes:bytes];
		
		lx_protocol_t protocol = *((lx_protocol_t*)&bytes);
		
		_size = protocol.size;
		_protocol = protocol.protocol;
		_atTime = protocol.at_time;
		
		LFXSiteID *site = [LFXSiteID siteIDWithData:lfx_NSDataWithPointer(protocol.site)];
		LFXBinaryTargetID *target = protocol.tagged ? [LFXBinaryTargetID groupTargetIDWithTagField:*((tagField_t *)&protocol.target)] : [LFXBinaryTargetID deviceTargetIDWithData:[NSData dataWithBytes:protocol.target length:6]];
		_path = [LFXBinaryPath pathWithSiteID:site targetID:target];
		
		NSUInteger prePayloadLength = __offsetof(lx_protocol_t, payload);
		NSUInteger payloadLength = data.length > prePayloadLength ? data.length - prePayloadLength : 0;
		NSData *payloadData = [data subdataWithRange:NSMakeRange(prePayloadLength, payloadLength)];
		self.payload = [[[self class] payloadClass] objectWithData:payloadData];
	}
	return self;
}

- (instancetype)initWithNonProtocolMessageData:(NSData *)data
{
	if ((self = [super init]))
	{
		_messageDirection = LFXMessageDirectionIncoming;
		
		uint8_t bytes[data.length];
		[data getBytes:bytes];
		
		lx_frame_address_t frame = *((lx_frame_address_t*)&bytes);
		
		_size = frame.size;
		_protocol = frame.protocol;
		
		LFXSiteID *site = [LFXSiteID siteIDWithData:lfx_NSDataWithPointer(frame.site)];
		LFXBinaryTargetID *target = frame.tagged ? [LFXBinaryTargetID groupTargetIDWithTagField:*((tagField_t *)&frame.target)] : [LFXBinaryTargetID deviceTargetIDWithData:[NSData dataWithBytes:frame.target length:6]];
		_path = [LFXBinaryPath pathWithSiteID:site targetID:target];
	}
	return self;
}

- (instancetype)init
{
	if ((self = [super init]))
	{
		_messageDirection = LFXMessageDirectionOutgoing;
		_protocol = LX_PROTOCOL_V1;
		
		self.payload = [[[self class] payloadClass] new];
	}
	return self;
}

- (NSData *)messageDataRepresentation
{
	NSMutableData *data = [NSMutableData new];
	
	lx_protocol_t protocol;
	memset(&protocol, 0, sizeof(protocol));
	
	protocol.size = _size;
	protocol.protocol = _protocol;
	protocol.addressable = 1;
	protocol.at_time = _atTime;
	protocol.type = [self messageType];
	
	[_path.siteID.dataValue getBytes:protocol.site];
	
	if (_path.targetID.targetType == LFXBinaryTargetTypeDevice)
	{
		protocol.tagged = 0;
		[_path.targetID.deviceDataValue getBytes:protocol.target];
	}
	else
	{
		protocol.tagged = 1;
		tagField_t tagField = _path.targetID.groupTagField;
		memcpy(protocol.target, &tagField, sizeof(tagField));
	}
	
	NSData *payloadData = self.payload.dataValue;
	NSUInteger prePayloadLength = __offsetof(lx_protocol_t, payload);
	protocol.size = prePayloadLength + payloadData.length;
	[data appendBytes:&protocol length:prePayloadLength];
	[data appendData:payloadData];
	
	return data;
}

+ (instancetype)messageWithTarget:(LFXTarget *)target
{
	LFXMessage *message = [[self alloc] init];
	message.target = target;
	return message;
}

+ (instancetype)messageWithTarget:(LFXTarget *)target qosPriority:(NSInteger)qosPriority
{
	LFXMessage *message = [[self alloc] init];
	message.target = target;
	message.qosPriority = qosPriority;
	return message;
}

+ (instancetype)messageWithBinaryPath:(LFXBinaryPath *)path
{
	LFXMessage *message = [[self alloc] init];
	message.path = path;
	return message;
}

+ (LFXMessageType)messageType
{
	return 0;
}

- (LFXMessageType)messageType
{
	return [[self class] messageType];
}

+ (Class)payloadClass
{
	return nil;
}

- (LFXMessageSource)messageSource
{
	if
	(self.messageType == LX_PROTOCOL_DEVICE_STATE_DUMMY_LOAD ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_INFO ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_LABEL ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_MCU_RAIL_VOLTAGE ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_MESH_FIRMWARE ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_MESH_INFO ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_PAN_GATEWAY ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_POWER ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_RESET_SWITCH ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_TAG_LABELS ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_TAGS ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_TIME ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_VERSION ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_WIFI_FIRMWARE ||
	 self.messageType == LX_PROTOCOL_DEVICE_STATE_WIFI_INFO ||
	 self.messageType == LX_PROTOCOL_LIGHT_STATE ||
	 self.messageType == LX_PROTOCOL_LIGHT_STATE_RAIL_VOLTAGE ||
	 self.messageType == LX_PROTOCOL_LIGHT_STATE_TEMPERATURE) return LFXMessageSourceDevice;
	return LFXMessageSourceClient;
}

- (NSString *)description
{
	NSMutableString *str = [NSMutableString new];
	[str appendFormat:@"<%@ %p>", self.class, self];
	[str appendString:self.messageDirection == LFXMessageDirectionOutgoing ? @" out" : @" in"];
	[str appendFormat:@" target = %@, path = %@, protocol = %i, type = %i", _target, _path.debugStringValue, _protocol, self.messageType];
	for (NSString *aPropertyKey in self.payload.propertyKeysToBeAddedToDescription)
	{
		[str appendFormat:@" %@ = %@", aPropertyKey, [self.payload valueForKey:aPropertyKey]];
	}
	return str;
}

- (NSString *)niceLoggingDescription
{
	NSMutableString *str = [NSMutableString new];
	
	NSString *messageName = NSStringFromClass(self.class);
	if ([messageName hasPrefix:@"LFXMessage"]) messageName = [messageName substringFromIndex:@"LFXMessage".length];
	[str appendString:messageName];
	[str appendFormat:@" path = %@,", _path.debugStringValue];
	for (NSString *aPropertyKey in self.payload.propertyKeysToBeAddedToDescription)
	{
		[str appendFormat:@" %@ = %@", aPropertyKey, [self.payload valueForKey:aPropertyKey]];
	}
	return str;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	LFXMessage *message = [[self class] new];
	message->_messageDirection = self->_messageDirection;
	message->_gatewayDescriptor = self->_gatewayDescriptor;
	message->_size = self->_size;
	message->_protocol = self->_protocol;
	message->_path = self->_path;
	message->_target = self->_target;
	message->_atTime = self->_atTime;
	message->_payload = self->_payload;
	message->_qosPriority = self->_qosPriority;
	return message;
}

@end



NSString * NSStringFromLFXMessageType(LFXMessageType messageType)
{
	Class subClass = [LFXMessage subclassForMessageType:messageType];
	return [NSStringFromClass(subClass) lfx_substringFromIndexIfItExists:[NSStringFromClass([LFXMessage class]) length]];
}


