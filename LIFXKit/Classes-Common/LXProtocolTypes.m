//===========================================================================
//
//	LIFX Protocol Implementation for Objective-C (auto-generated)
//
//===========================================================================


#import "LXProtocolTypes.h"
#import "LFXMacros.h"


//===========================================================================


#pragma pack(push, 1)
typedef struct LXProtocolDeviceSetSite_t {
	uint8_t site[6];
} LXProtocolDeviceSetSite_t;
#pragma pack(pop)

@implementation LXProtocolDeviceSetSite

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceSetSite *newObject = [LXProtocolDeviceSetSite new];
	LXProtocolDeviceSetSite_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.site = [NSData dataWithBytes:structValue.site length:sizeof(structValue.site)];
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceSetSite_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceSetSite_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	if (self.site.length != sizeof(structValue.site)) LFXLogWarn(@"Warning: %@.site (%@) isn't the correct length (%tu)", NSStringFromClass(self.class), self.site, sizeof(structValue.site));
	[self.site getBytes:structValue.site length:sizeof(structValue.site)];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(site)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateSite_t {
	uint8_t site[6];
} LXProtocolDeviceStateSite_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateSite

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateSite *newObject = [LXProtocolDeviceStateSite new];
	LXProtocolDeviceStateSite_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.site = [NSData dataWithBytes:structValue.site length:sizeof(structValue.site)];
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateSite_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateSite_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	if (self.site.length != sizeof(structValue.site)) LFXLogWarn(@"Warning: %@.site (%@) isn't the correct length (%tu)", NSStringFromClass(self.class), self.site, sizeof(structValue.site));
	[self.site getBytes:structValue.site length:sizeof(structValue.site)];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(site)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetPanGateway

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceSetPanGateway_t {
	BOOL enabled;
} LXProtocolDeviceSetPanGateway_t;
#pragma pack(pop)

@implementation LXProtocolDeviceSetPanGateway

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceSetPanGateway *newObject = [LXProtocolDeviceSetPanGateway new];
	LXProtocolDeviceSetPanGateway_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.enabled = structValue.enabled;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceSetPanGateway_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceSetPanGateway_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.enabled = self.enabled;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(enabled)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStatePanGateway_t {
	LXProtocolDeviceService service;
	uint32_t port;
} LXProtocolDeviceStatePanGateway_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStatePanGateway

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStatePanGateway *newObject = [LXProtocolDeviceStatePanGateway new];
	LXProtocolDeviceStatePanGateway_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.service = structValue.service;
	newObject.port = structValue.port;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStatePanGateway_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStatePanGateway_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.service = self.service;
	structValue.port = self.port;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(service), SelfKey(port)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetTime

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceSetTime_t {
	uint64_t time;
} LXProtocolDeviceSetTime_t;
#pragma pack(pop)

@implementation LXProtocolDeviceSetTime

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceSetTime *newObject = [LXProtocolDeviceSetTime new];
	LXProtocolDeviceSetTime_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.time = structValue.time;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceSetTime_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceSetTime_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.time = self.time;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(time)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateTime_t {
	uint64_t time;
} LXProtocolDeviceStateTime_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateTime

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateTime *newObject = [LXProtocolDeviceStateTime new];
	LXProtocolDeviceStateTime_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.time = structValue.time;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateTime_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateTime_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.time = self.time;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(time)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetResetSwitch

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateResetSwitch_t {
	uint8_t position;
} LXProtocolDeviceStateResetSwitch_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateResetSwitch

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateResetSwitch *newObject = [LXProtocolDeviceStateResetSwitch new];
	LXProtocolDeviceStateResetSwitch_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.position = structValue.position;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateResetSwitch_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateResetSwitch_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.position = self.position;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(position)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetDummyLoad

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceSetDummyLoad_t {
	BOOL on;
} LXProtocolDeviceSetDummyLoad_t;
#pragma pack(pop)

@implementation LXProtocolDeviceSetDummyLoad

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceSetDummyLoad *newObject = [LXProtocolDeviceSetDummyLoad new];
	LXProtocolDeviceSetDummyLoad_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.on = structValue.on;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceSetDummyLoad_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceSetDummyLoad_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.on = self.on;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(on)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateDummyLoad_t {
	BOOL on;
} LXProtocolDeviceStateDummyLoad_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateDummyLoad

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateDummyLoad *newObject = [LXProtocolDeviceStateDummyLoad new];
	LXProtocolDeviceStateDummyLoad_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.on = structValue.on;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateDummyLoad_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateDummyLoad_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.on = self.on;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(on)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetMeshInfo

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateMeshInfo_t {
	float signal;
	uint32_t tx;
	uint32_t rx;
	int16_t mcu_temperature;
} LXProtocolDeviceStateMeshInfo_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateMeshInfo

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateMeshInfo *newObject = [LXProtocolDeviceStateMeshInfo new];
	LXProtocolDeviceStateMeshInfo_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.signal = structValue.signal;
	newObject.tx = structValue.tx;
	newObject.rx = structValue.rx;
	newObject.mcu_temperature = structValue.mcu_temperature;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateMeshInfo_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateMeshInfo_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.signal = self.signal;
	structValue.tx = self.tx;
	structValue.rx = self.rx;
	structValue.mcu_temperature = self.mcu_temperature;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(signal), SelfKey(tx), SelfKey(rx), SelfKey(mcu_temperature)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetMeshFirmware

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateMeshFirmware_t {
	uint64_t build;
	uint64_t install;
	uint32_t version;
} LXProtocolDeviceStateMeshFirmware_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateMeshFirmware

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateMeshFirmware *newObject = [LXProtocolDeviceStateMeshFirmware new];
	LXProtocolDeviceStateMeshFirmware_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.build = structValue.build;
	newObject.install = structValue.install;
	newObject.version = structValue.version;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateMeshFirmware_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateMeshFirmware_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.build = self.build;
	structValue.install = self.install;
	structValue.version = self.version;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(build), SelfKey(install), SelfKey(version)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetWifiInfo

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateWifiInfo_t {
	float signal;
	uint32_t tx;
	uint32_t rx;
	int16_t mcu_temperature;
} LXProtocolDeviceStateWifiInfo_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateWifiInfo

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateWifiInfo *newObject = [LXProtocolDeviceStateWifiInfo new];
	LXProtocolDeviceStateWifiInfo_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.signal = structValue.signal;
	newObject.tx = structValue.tx;
	newObject.rx = structValue.rx;
	newObject.mcu_temperature = structValue.mcu_temperature;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateWifiInfo_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateWifiInfo_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.signal = self.signal;
	structValue.tx = self.tx;
	structValue.rx = self.rx;
	structValue.mcu_temperature = self.mcu_temperature;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(signal), SelfKey(tx), SelfKey(rx), SelfKey(mcu_temperature)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetWifiFirmware

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateWifiFirmware_t {
	uint64_t build;
	uint64_t install;
	uint32_t version;
} LXProtocolDeviceStateWifiFirmware_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateWifiFirmware

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateWifiFirmware *newObject = [LXProtocolDeviceStateWifiFirmware new];
	LXProtocolDeviceStateWifiFirmware_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.build = structValue.build;
	newObject.install = structValue.install;
	newObject.version = structValue.version;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateWifiFirmware_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateWifiFirmware_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.build = self.build;
	structValue.install = self.install;
	structValue.version = self.version;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(build), SelfKey(install), SelfKey(version)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetPower

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceSetPower_t {
	uint16_t level;
} LXProtocolDeviceSetPower_t;
#pragma pack(pop)

@implementation LXProtocolDeviceSetPower

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceSetPower *newObject = [LXProtocolDeviceSetPower new];
	LXProtocolDeviceSetPower_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.level = structValue.level;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceSetPower_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceSetPower_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.level = self.level;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(level)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStatePower_t {
	uint16_t level;
} LXProtocolDeviceStatePower_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStatePower

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStatePower *newObject = [LXProtocolDeviceStatePower new];
	LXProtocolDeviceStatePower_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.level = structValue.level;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStatePower_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStatePower_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.level = self.level;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(level)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetLabel

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceSetLabel_t {
	uint8_t label[32];
} LXProtocolDeviceSetLabel_t;
#pragma pack(pop)

@implementation LXProtocolDeviceSetLabel

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceSetLabel *newObject = [LXProtocolDeviceSetLabel new];
	LXProtocolDeviceSetLabel_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	//newObject.label = @((char *)structValue.label);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t labelTempBuffer[200];
	memset(labelTempBuffer, 0, sizeof(labelTempBuffer));
	memcpy(labelTempBuffer, structValue.label, sizeof(structValue.label));
	newObject.label = @((char *)labelTempBuffer);
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceSetLabel_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceSetLabel_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	if (self.label.length >= sizeof(structValue.label)) LFXLogWarn(@"Warning: %@.label (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.label, sizeof(structValue.label));
	[self.label getBytes:structValue.label maxLength:sizeof(structValue.label) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.label.length) remainingRange:NULL];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(label)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateLabel_t {
	uint8_t label[32];
} LXProtocolDeviceStateLabel_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateLabel

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateLabel *newObject = [LXProtocolDeviceStateLabel new];
	LXProtocolDeviceStateLabel_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	//newObject.label = @((char *)structValue.label);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t labelTempBuffer[200];
	memset(labelTempBuffer, 0, sizeof(labelTempBuffer));
	memcpy(labelTempBuffer, structValue.label, sizeof(structValue.label));
	newObject.label = @((char *)labelTempBuffer);
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateLabel_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateLabel_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	if (self.label.length >= sizeof(structValue.label)) LFXLogWarn(@"Warning: %@.label (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.label, sizeof(structValue.label));
	[self.label getBytes:structValue.label maxLength:sizeof(structValue.label) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.label.length) remainingRange:NULL];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(label)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetTags

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceSetTags_t {
	uint64_t tags;
} LXProtocolDeviceSetTags_t;
#pragma pack(pop)

@implementation LXProtocolDeviceSetTags

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceSetTags *newObject = [LXProtocolDeviceSetTags new];
	LXProtocolDeviceSetTags_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.tags = structValue.tags;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceSetTags_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceSetTags_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.tags = self.tags;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(tags)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateTags_t {
	uint64_t tags;
} LXProtocolDeviceStateTags_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateTags

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateTags *newObject = [LXProtocolDeviceStateTags new];
	LXProtocolDeviceStateTags_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.tags = structValue.tags;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateTags_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateTags_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.tags = self.tags;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(tags)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceGetTagLabels_t {
	uint64_t tags;
} LXProtocolDeviceGetTagLabels_t;
#pragma pack(pop)

@implementation LXProtocolDeviceGetTagLabels

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceGetTagLabels *newObject = [LXProtocolDeviceGetTagLabels new];
	LXProtocolDeviceGetTagLabels_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.tags = structValue.tags;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceGetTagLabels_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceGetTagLabels_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.tags = self.tags;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(tags)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceSetTagLabels_t {
	uint64_t tags;
	uint8_t label[32];
} LXProtocolDeviceSetTagLabels_t;
#pragma pack(pop)

@implementation LXProtocolDeviceSetTagLabels

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceSetTagLabels *newObject = [LXProtocolDeviceSetTagLabels new];
	LXProtocolDeviceSetTagLabels_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.tags = structValue.tags;
	//newObject.label = @((char *)structValue.label);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t labelTempBuffer[200];
	memset(labelTempBuffer, 0, sizeof(labelTempBuffer));
	memcpy(labelTempBuffer, structValue.label, sizeof(structValue.label));
	newObject.label = @((char *)labelTempBuffer);
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceSetTagLabels_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceSetTagLabels_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.tags = self.tags;
	if (self.label.length >= sizeof(structValue.label)) LFXLogWarn(@"Warning: %@.label (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.label, sizeof(structValue.label));
	[self.label getBytes:structValue.label maxLength:sizeof(structValue.label) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.label.length) remainingRange:NULL];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(tags), SelfKey(label)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateTagLabels_t {
	uint64_t tags;
	uint8_t label[32];
} LXProtocolDeviceStateTagLabels_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateTagLabels

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateTagLabels *newObject = [LXProtocolDeviceStateTagLabels new];
	LXProtocolDeviceStateTagLabels_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.tags = structValue.tags;
	//newObject.label = @((char *)structValue.label);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t labelTempBuffer[200];
	memset(labelTempBuffer, 0, sizeof(labelTempBuffer));
	memcpy(labelTempBuffer, structValue.label, sizeof(structValue.label));
	newObject.label = @((char *)labelTempBuffer);
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateTagLabels_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateTagLabels_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.tags = self.tags;
	if (self.label.length >= sizeof(structValue.label)) LFXLogWarn(@"Warning: %@.label (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.label, sizeof(structValue.label));
	[self.label getBytes:structValue.label maxLength:sizeof(structValue.label) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.label.length) remainingRange:NULL];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(tags), SelfKey(label)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetVersion

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateVersion_t {
	uint32_t vendor;
	uint32_t product;
	uint32_t version;
} LXProtocolDeviceStateVersion_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateVersion

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateVersion *newObject = [LXProtocolDeviceStateVersion new];
	LXProtocolDeviceStateVersion_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.vendor = structValue.vendor;
	newObject.product = structValue.product;
	newObject.version = structValue.version;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateVersion_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateVersion_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.vendor = self.vendor;
	structValue.product = self.product;
	structValue.version = self.version;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(vendor), SelfKey(product), SelfKey(version)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetInfo

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateInfo_t {
	uint64_t time;
	uint64_t uptime;
	uint64_t downtime;
} LXProtocolDeviceStateInfo_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateInfo

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateInfo *newObject = [LXProtocolDeviceStateInfo new];
	LXProtocolDeviceStateInfo_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.time = structValue.time;
	newObject.uptime = structValue.uptime;
	newObject.downtime = structValue.downtime;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateInfo_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateInfo_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.time = self.time;
	structValue.uptime = self.uptime;
	structValue.downtime = self.downtime;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(time), SelfKey(uptime), SelfKey(downtime)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceGetMcuRailVoltage

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateMcuRailVoltage_t {
	uint32_t voltage;
} LXProtocolDeviceStateMcuRailVoltage_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateMcuRailVoltage

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateMcuRailVoltage *newObject = [LXProtocolDeviceStateMcuRailVoltage new];
	LXProtocolDeviceStateMcuRailVoltage_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.voltage = structValue.voltage;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateMcuRailVoltage_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateMcuRailVoltage_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.voltage = self.voltage;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(voltage)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceSetFactoryTestMode_t {
	BOOL on;
} LXProtocolDeviceSetFactoryTestMode_t;
#pragma pack(pop)

@implementation LXProtocolDeviceSetFactoryTestMode

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceSetFactoryTestMode *newObject = [LXProtocolDeviceSetFactoryTestMode new];
	LXProtocolDeviceSetFactoryTestMode_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.on = structValue.on;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceSetFactoryTestMode_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceSetFactoryTestMode_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.on = self.on;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(on)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceDisableFactoryTestMode

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolDeviceStateFactoryTestMode_t {
	BOOL on;
	BOOL disabled;
} LXProtocolDeviceStateFactoryTestMode_t;
#pragma pack(pop)

@implementation LXProtocolDeviceStateFactoryTestMode

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolDeviceStateFactoryTestMode *newObject = [LXProtocolDeviceStateFactoryTestMode new];
	LXProtocolDeviceStateFactoryTestMode_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.on = structValue.on;
	newObject.disabled = structValue.disabled;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolDeviceStateFactoryTestMode_t);
}

- (NSData *)dataValue
{
	LXProtocolDeviceStateFactoryTestMode_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.on = self.on;
	structValue.disabled = self.disabled;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(on), SelfKey(disabled)];
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceSetReboot

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceStateReboot

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================


@implementation LXProtocolDeviceAcknowledgement

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightHsbk_t {
	uint16_t hue;
	uint16_t saturation;
	uint16_t brightness;
	uint16_t kelvin;
} LXProtocolLightHsbk_t;
#pragma pack(pop)

@implementation LXProtocolLightHsbk

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightHsbk *newObject = [LXProtocolLightHsbk new];
	LXProtocolLightHsbk_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.hue = structValue.hue;
	newObject.saturation = structValue.saturation;
	newObject.brightness = structValue.brightness;
	newObject.kelvin = structValue.kelvin;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightHsbk_t);
}

- (NSData *)dataValue
{
	LXProtocolLightHsbk_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.hue = self.hue;
	structValue.saturation = self.saturation;
	structValue.brightness = self.brightness;
	structValue.kelvin = self.kelvin;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(hue), SelfKey(saturation), SelfKey(brightness), SelfKey(kelvin)];
}
	
@end


//===========================================================================


@implementation LXProtocolLightGet

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightSetColor_t {
	uint8_t stream;
	LXProtocolLightHsbk_t color;
	uint32_t duration;
} LXProtocolLightSetColor_t;
#pragma pack(pop)

@implementation LXProtocolLightSetColor

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightSetColor *newObject = [LXProtocolLightSetColor new];
	LXProtocolLightSetColor_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.stream = structValue.stream;
	newObject.color = [LXProtocolLightHsbk objectWithData:[NSData dataWithBytes:&(structValue.color) length:sizeof(structValue.color)]];
	newObject.duration = structValue.duration;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightSetColor_t);
}

- (NSData *)dataValue
{
	LXProtocolLightSetColor_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.stream = self.stream;
	[[self.color dataValue] getBytes:&(structValue.color) length:sizeof(structValue.color)];
	structValue.duration = self.duration;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(stream), SelfKey(color), SelfKey(duration)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightSetWaveformOptional_t {
	uint8_t stream;
	BOOL transient;
	LXProtocolLightHsbk_t color;
	uint32_t period;
	float cycles;
	int16_t skew_ratio;
	LXProtocolLightWaveform waveform;
	BOOL set_hue;
	BOOL set_saturation;
	BOOL set_brightness;
	BOOL set_kelvin;
} LXProtocolLightSetWaveformOptional_t;
#pragma pack(pop)

@implementation LXProtocolLightSetWaveformOptional

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightSetWaveformOptional *newObject = [LXProtocolLightSetWaveformOptional new];
	LXProtocolLightSetWaveformOptional_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.stream = structValue.stream;
	newObject.transient = structValue.transient;
	newObject.color = [LXProtocolLightHsbk objectWithData:[NSData dataWithBytes:&(structValue.color) length:sizeof(structValue.color)]];
	newObject.period = structValue.period;
	newObject.cycles = structValue.cycles;
	newObject.skew_ratio = structValue.skew_ratio;
	newObject.waveform = structValue.waveform;
	newObject.set_hue = structValue.set_hue;
	newObject.set_saturation = structValue.set_saturation;
	newObject.set_brightness = structValue.set_brightness;
	newObject.set_kelvin = structValue.set_kelvin;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightSetWaveformOptional_t);
}

- (NSData *)dataValue
{
	LXProtocolLightSetWaveformOptional_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.stream = self.stream;
	structValue.transient = self.transient;
	[[self.color dataValue] getBytes:&(structValue.color) length:sizeof(structValue.color)];
	structValue.period = self.period;
	structValue.cycles = self.cycles;
	structValue.skew_ratio = self.skew_ratio;
	structValue.waveform = self.waveform;
	structValue.set_hue = self.set_hue;
	structValue.set_saturation = self.set_saturation;
	structValue.set_brightness = self.set_brightness;
	structValue.set_kelvin = self.set_kelvin;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(stream), SelfKey(transient), SelfKey(color), SelfKey(period), SelfKey(cycles), SelfKey(skew_ratio), SelfKey(waveform), SelfKey(set_hue), SelfKey(set_saturation), SelfKey(set_brightness), SelfKey(set_kelvin)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightSetWaveform_t {
	uint8_t stream;
	BOOL transient;
	LXProtocolLightHsbk_t color;
	uint32_t period;
	float cycles;
	int16_t skew_ratio;
	LXProtocolLightWaveform waveform;
} LXProtocolLightSetWaveform_t;
#pragma pack(pop)

@implementation LXProtocolLightSetWaveform

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightSetWaveform *newObject = [LXProtocolLightSetWaveform new];
	LXProtocolLightSetWaveform_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.stream = structValue.stream;
	newObject.transient = structValue.transient;
	newObject.color = [LXProtocolLightHsbk objectWithData:[NSData dataWithBytes:&(structValue.color) length:sizeof(structValue.color)]];
	newObject.period = structValue.period;
	newObject.cycles = structValue.cycles;
	newObject.skew_ratio = structValue.skew_ratio;
	newObject.waveform = structValue.waveform;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightSetWaveform_t);
}

- (NSData *)dataValue
{
	LXProtocolLightSetWaveform_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.stream = self.stream;
	structValue.transient = self.transient;
	[[self.color dataValue] getBytes:&(structValue.color) length:sizeof(structValue.color)];
	structValue.period = self.period;
	structValue.cycles = self.cycles;
	structValue.skew_ratio = self.skew_ratio;
	structValue.waveform = self.waveform;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(stream), SelfKey(transient), SelfKey(color), SelfKey(period), SelfKey(cycles), SelfKey(skew_ratio), SelfKey(waveform)];
}
	
@end


//===========================================================================


@implementation LXProtocolLightGetPower

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightSetPower_t {
	uint16_t level;
	uint32_t duration;
} LXProtocolLightSetPower_t;
#pragma pack(pop)

@implementation LXProtocolLightSetPower

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightSetPower *newObject = [LXProtocolLightSetPower new];
	LXProtocolLightSetPower_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.level = structValue.level;
	newObject.duration = structValue.duration;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightSetPower_t);
}

- (NSData *)dataValue
{
	LXProtocolLightSetPower_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.level = self.level;
	structValue.duration = self.duration;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(level), SelfKey(duration)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightStatePower_t {
	uint16_t level;
} LXProtocolLightStatePower_t;
#pragma pack(pop)

@implementation LXProtocolLightStatePower

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightStatePower *newObject = [LXProtocolLightStatePower new];
	LXProtocolLightStatePower_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.level = structValue.level;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightStatePower_t);
}

- (NSData *)dataValue
{
	LXProtocolLightStatePower_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.level = self.level;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(level)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightSetSimpleEvent_t {
	uint8_t index;
	uint64_t time;
	uint16_t power;
	uint32_t duration;
	LXProtocolLightSetWaveform_t waveform;
} LXProtocolLightSetSimpleEvent_t;
#pragma pack(pop)

@implementation LXProtocolLightSetSimpleEvent

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightSetSimpleEvent *newObject = [LXProtocolLightSetSimpleEvent new];
	LXProtocolLightSetSimpleEvent_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.index = structValue.index;
	newObject.time = structValue.time;
	newObject.power = structValue.power;
	newObject.duration = structValue.duration;
	newObject.waveform = [LXProtocolLightSetWaveform objectWithData:[NSData dataWithBytes:&(structValue.waveform) length:sizeof(structValue.waveform)]];
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightSetSimpleEvent_t);
}

- (NSData *)dataValue
{
	LXProtocolLightSetSimpleEvent_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.index = self.index;
	structValue.time = self.time;
	structValue.power = self.power;
	structValue.duration = self.duration;
	[[self.waveform dataValue] getBytes:&(structValue.waveform) length:sizeof(structValue.waveform)];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(index), SelfKey(time), SelfKey(power), SelfKey(duration), SelfKey(waveform)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightGetSimpleEvent_t {
	uint8_t index;
} LXProtocolLightGetSimpleEvent_t;
#pragma pack(pop)

@implementation LXProtocolLightGetSimpleEvent

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightGetSimpleEvent *newObject = [LXProtocolLightGetSimpleEvent new];
	LXProtocolLightGetSimpleEvent_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.index = structValue.index;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightGetSimpleEvent_t);
}

- (NSData *)dataValue
{
	LXProtocolLightGetSimpleEvent_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.index = self.index;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(index)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightStateSimpleEvent_t {
	uint8_t index;
	uint64_t time;
	uint16_t power;
	uint32_t duration;
	LXProtocolLightSetWaveform_t waveform;
	uint16_t max;
} LXProtocolLightStateSimpleEvent_t;
#pragma pack(pop)

@implementation LXProtocolLightStateSimpleEvent

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightStateSimpleEvent *newObject = [LXProtocolLightStateSimpleEvent new];
	LXProtocolLightStateSimpleEvent_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.index = structValue.index;
	newObject.time = structValue.time;
	newObject.power = structValue.power;
	newObject.duration = structValue.duration;
	newObject.waveform = [LXProtocolLightSetWaveform objectWithData:[NSData dataWithBytes:&(structValue.waveform) length:sizeof(structValue.waveform)]];
	newObject.max = structValue.max;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightStateSimpleEvent_t);
}

- (NSData *)dataValue
{
	LXProtocolLightStateSimpleEvent_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.index = self.index;
	structValue.time = self.time;
	structValue.power = self.power;
	structValue.duration = self.duration;
	[[self.waveform dataValue] getBytes:&(structValue.waveform) length:sizeof(structValue.waveform)];
	structValue.max = self.max;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(index), SelfKey(time), SelfKey(power), SelfKey(duration), SelfKey(waveform), SelfKey(max)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightSetDimAbsolute_t {
	int16_t brightness;
	uint32_t duration;
} LXProtocolLightSetDimAbsolute_t;
#pragma pack(pop)

@implementation LXProtocolLightSetDimAbsolute

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightSetDimAbsolute *newObject = [LXProtocolLightSetDimAbsolute new];
	LXProtocolLightSetDimAbsolute_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.brightness = structValue.brightness;
	newObject.duration = structValue.duration;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightSetDimAbsolute_t);
}

- (NSData *)dataValue
{
	LXProtocolLightSetDimAbsolute_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.brightness = self.brightness;
	structValue.duration = self.duration;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(brightness), SelfKey(duration)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightSetDimRelative_t {
	int32_t brightness;
	uint32_t duration;
} LXProtocolLightSetDimRelative_t;
#pragma pack(pop)

@implementation LXProtocolLightSetDimRelative

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightSetDimRelative *newObject = [LXProtocolLightSetDimRelative new];
	LXProtocolLightSetDimRelative_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.brightness = structValue.brightness;
	newObject.duration = structValue.duration;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightSetDimRelative_t);
}

- (NSData *)dataValue
{
	LXProtocolLightSetDimRelative_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.brightness = self.brightness;
	structValue.duration = self.duration;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(brightness), SelfKey(duration)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightRgbw_t {
	uint16_t red;
	uint16_t green;
	uint16_t blue;
	uint16_t white;
} LXProtocolLightRgbw_t;
#pragma pack(pop)

@implementation LXProtocolLightRgbw

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightRgbw *newObject = [LXProtocolLightRgbw new];
	LXProtocolLightRgbw_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.red = structValue.red;
	newObject.green = structValue.green;
	newObject.blue = structValue.blue;
	newObject.white = structValue.white;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightRgbw_t);
}

- (NSData *)dataValue
{
	LXProtocolLightRgbw_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.red = self.red;
	structValue.green = self.green;
	structValue.blue = self.blue;
	structValue.white = self.white;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(red), SelfKey(green), SelfKey(blue), SelfKey(white)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightSetRgbw_t {
	LXProtocolLightRgbw_t color;
} LXProtocolLightSetRgbw_t;
#pragma pack(pop)

@implementation LXProtocolLightSetRgbw

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightSetRgbw *newObject = [LXProtocolLightSetRgbw new];
	LXProtocolLightSetRgbw_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.color = [LXProtocolLightRgbw objectWithData:[NSData dataWithBytes:&(structValue.color) length:sizeof(structValue.color)]];
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightSetRgbw_t);
}

- (NSData *)dataValue
{
	LXProtocolLightSetRgbw_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	[[self.color dataValue] getBytes:&(structValue.color) length:sizeof(structValue.color)];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(color)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightState_t {
	LXProtocolLightHsbk_t color;
	int16_t dim;
	uint16_t power;
	uint8_t label[32];
	uint64_t tags;
} LXProtocolLightState_t;
#pragma pack(pop)

@implementation LXProtocolLightState

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightState *newObject = [LXProtocolLightState new];
	LXProtocolLightState_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.color = [LXProtocolLightHsbk objectWithData:[NSData dataWithBytes:&(structValue.color) length:sizeof(structValue.color)]];
	newObject.dim = structValue.dim;
	newObject.power = structValue.power;
	//newObject.label = @((char *)structValue.label);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t labelTempBuffer[200];
	memset(labelTempBuffer, 0, sizeof(labelTempBuffer));
	memcpy(labelTempBuffer, structValue.label, sizeof(structValue.label));
	newObject.label = @((char *)labelTempBuffer);
	newObject.tags = structValue.tags;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightState_t);
}

- (NSData *)dataValue
{
	LXProtocolLightState_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	[[self.color dataValue] getBytes:&(structValue.color) length:sizeof(structValue.color)];
	structValue.dim = self.dim;
	structValue.power = self.power;
	if (self.label.length >= sizeof(structValue.label)) LFXLogWarn(@"Warning: %@.label (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.label, sizeof(structValue.label));
	[self.label getBytes:structValue.label maxLength:sizeof(structValue.label) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.label.length) remainingRange:NULL];
	structValue.tags = self.tags;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(color), SelfKey(dim), SelfKey(power), SelfKey(label), SelfKey(tags)];
}
	
@end


//===========================================================================


@implementation LXProtocolLightGetRailVoltage

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightStateRailVoltage_t {
	uint32_t voltage;
} LXProtocolLightStateRailVoltage_t;
#pragma pack(pop)

@implementation LXProtocolLightStateRailVoltage

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightStateRailVoltage *newObject = [LXProtocolLightStateRailVoltage new];
	LXProtocolLightStateRailVoltage_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.voltage = structValue.voltage;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightStateRailVoltage_t);
}

- (NSData *)dataValue
{
	LXProtocolLightStateRailVoltage_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.voltage = self.voltage;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(voltage)];
}
	
@end


//===========================================================================


@implementation LXProtocolLightGetTemperature

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightStateTemperature_t {
	int16_t temperature;
} LXProtocolLightStateTemperature_t;
#pragma pack(pop)

@implementation LXProtocolLightStateTemperature

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightStateTemperature *newObject = [LXProtocolLightStateTemperature new];
	LXProtocolLightStateTemperature_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.temperature = structValue.temperature;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightStateTemperature_t);
}

- (NSData *)dataValue
{
	LXProtocolLightStateTemperature_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.temperature = self.temperature;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(temperature)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightXyz_t {
	float x;
	float y;
	float z;
} LXProtocolLightXyz_t;
#pragma pack(pop)

@implementation LXProtocolLightXyz

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightXyz *newObject = [LXProtocolLightXyz new];
	LXProtocolLightXyz_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.x = structValue.x;
	newObject.y = structValue.y;
	newObject.z = structValue.z;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightXyz_t);
}

- (NSData *)dataValue
{
	LXProtocolLightXyz_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.x = self.x;
	structValue.y = self.y;
	structValue.z = self.z;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(x), SelfKey(y), SelfKey(z)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolLightSetCalibrationCoefficients_t {
	LXProtocolLightXyz_t r;
	LXProtocolLightXyz_t g;
	LXProtocolLightXyz_t b;
	LXProtocolLightXyz_t w;
} LXProtocolLightSetCalibrationCoefficients_t;
#pragma pack(pop)

@implementation LXProtocolLightSetCalibrationCoefficients

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolLightSetCalibrationCoefficients *newObject = [LXProtocolLightSetCalibrationCoefficients new];
	LXProtocolLightSetCalibrationCoefficients_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.r = [LXProtocolLightXyz objectWithData:[NSData dataWithBytes:&(structValue.r) length:sizeof(structValue.r)]];
	newObject.g = [LXProtocolLightXyz objectWithData:[NSData dataWithBytes:&(structValue.g) length:sizeof(structValue.g)]];
	newObject.b = [LXProtocolLightXyz objectWithData:[NSData dataWithBytes:&(structValue.b) length:sizeof(structValue.b)]];
	newObject.w = [LXProtocolLightXyz objectWithData:[NSData dataWithBytes:&(structValue.w) length:sizeof(structValue.w)]];
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolLightSetCalibrationCoefficients_t);
}

- (NSData *)dataValue
{
	LXProtocolLightSetCalibrationCoefficients_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	[[self.r dataValue] getBytes:&(structValue.r) length:sizeof(structValue.r)];
	[[self.g dataValue] getBytes:&(structValue.g) length:sizeof(structValue.g)];
	[[self.b dataValue] getBytes:&(structValue.b) length:sizeof(structValue.b)];
	[[self.w dataValue] getBytes:&(structValue.w) length:sizeof(structValue.w)];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(r), SelfKey(g), SelfKey(b), SelfKey(w)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWanSetAuthKey_t {
	uint8_t key[32];
} LXProtocolWanSetAuthKey_t;
#pragma pack(pop)

@implementation LXProtocolWanSetAuthKey

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWanSetAuthKey *newObject = [LXProtocolWanSetAuthKey new];
	LXProtocolWanSetAuthKey_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.key = [NSData dataWithBytes:structValue.key length:sizeof(structValue.key)];
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWanSetAuthKey_t);
}

- (NSData *)dataValue
{
	LXProtocolWanSetAuthKey_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	if (self.key.length != sizeof(structValue.key)) LFXLogWarn(@"Warning: %@.key (%@) isn't the correct length (%tu)", NSStringFromClass(self.class), self.key, sizeof(structValue.key));
	[self.key getBytes:structValue.key length:sizeof(structValue.key)];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(key)];
}
	
@end


//===========================================================================


@implementation LXProtocolWanGetAuthKey

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWanStateAuthKey_t {
	uint8_t key[32];
} LXProtocolWanStateAuthKey_t;
#pragma pack(pop)

@implementation LXProtocolWanStateAuthKey

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWanStateAuthKey *newObject = [LXProtocolWanStateAuthKey new];
	LXProtocolWanStateAuthKey_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.key = [NSData dataWithBytes:structValue.key length:sizeof(structValue.key)];
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWanStateAuthKey_t);
}

- (NSData *)dataValue
{
	LXProtocolWanStateAuthKey_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	if (self.key.length != sizeof(structValue.key)) LFXLogWarn(@"Warning: %@.key (%@) isn't the correct length (%tu)", NSStringFromClass(self.class), self.key, sizeof(structValue.key));
	[self.key getBytes:structValue.key length:sizeof(structValue.key)];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(key)];
}
	
@end


//===========================================================================


@implementation LXProtocolWanGet

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWanSet_t {
	BOOL active;
} LXProtocolWanSet_t;
#pragma pack(pop)

@implementation LXProtocolWanSet

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWanSet *newObject = [LXProtocolWanSet new];
	LXProtocolWanSet_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.active = structValue.active;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWanSet_t);
}

- (NSData *)dataValue
{
	LXProtocolWanSet_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.active = self.active;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(active)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWanState_t {
	LXProtocolWanStatus status;
} LXProtocolWanState_t;
#pragma pack(pop)

@implementation LXProtocolWanState

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWanState *newObject = [LXProtocolWanState new];
	LXProtocolWanState_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.status = structValue.status;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWanState_t);
}

- (NSData *)dataValue
{
	LXProtocolWanState_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.status = self.status;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(status)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWanSetKeepAlive_t {
	uint16_t seconds;
} LXProtocolWanSetKeepAlive_t;
#pragma pack(pop)

@implementation LXProtocolWanSetKeepAlive

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWanSetKeepAlive *newObject = [LXProtocolWanSetKeepAlive new];
	LXProtocolWanSetKeepAlive_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.seconds = structValue.seconds;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWanSetKeepAlive_t);
}

- (NSData *)dataValue
{
	LXProtocolWanSetKeepAlive_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.seconds = self.seconds;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(seconds)];
}
	
@end


//===========================================================================


@implementation LXProtocolWanStateKeepAlive

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWanSetHost_t {
	uint8_t host[32];
	BOOL insecure_skip_verify;
} LXProtocolWanSetHost_t;
#pragma pack(pop)

@implementation LXProtocolWanSetHost

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWanSetHost *newObject = [LXProtocolWanSetHost new];
	LXProtocolWanSetHost_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	//newObject.host = @((char *)structValue.host);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t hostTempBuffer[200];
	memset(hostTempBuffer, 0, sizeof(hostTempBuffer));
	memcpy(hostTempBuffer, structValue.host, sizeof(structValue.host));
	newObject.host = @((char *)hostTempBuffer);
	newObject.insecure_skip_verify = structValue.insecure_skip_verify;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWanSetHost_t);
}

- (NSData *)dataValue
{
	LXProtocolWanSetHost_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	if (self.host.length >= sizeof(structValue.host)) LFXLogWarn(@"Warning: %@.host (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.host, sizeof(structValue.host));
	[self.host getBytes:structValue.host maxLength:sizeof(structValue.host) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.host.length) remainingRange:NULL];
	structValue.insecure_skip_verify = self.insecure_skip_verify;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(host), SelfKey(insecure_skip_verify)];
}
	
@end


//===========================================================================


@implementation LXProtocolWanGetHost

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWanStateHost_t {
	uint8_t host[32];
	BOOL insecure_skip_verify;
} LXProtocolWanStateHost_t;
#pragma pack(pop)

@implementation LXProtocolWanStateHost

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWanStateHost *newObject = [LXProtocolWanStateHost new];
	LXProtocolWanStateHost_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	//newObject.host = @((char *)structValue.host);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t hostTempBuffer[200];
	memset(hostTempBuffer, 0, sizeof(hostTempBuffer));
	memcpy(hostTempBuffer, structValue.host, sizeof(structValue.host));
	newObject.host = @((char *)hostTempBuffer);
	newObject.insecure_skip_verify = structValue.insecure_skip_verify;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWanStateHost_t);
}

- (NSData *)dataValue
{
	LXProtocolWanStateHost_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	if (self.host.length >= sizeof(structValue.host)) LFXLogWarn(@"Warning: %@.host (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.host, sizeof(structValue.host));
	[self.host getBytes:structValue.host maxLength:sizeof(structValue.host) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.host.length) remainingRange:NULL];
	structValue.insecure_skip_verify = self.insecure_skip_verify;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(host), SelfKey(insecure_skip_verify)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWifiGet_t {
	LXProtocolWifiInterface interface;
} LXProtocolWifiGet_t;
#pragma pack(pop)

@implementation LXProtocolWifiGet

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWifiGet *newObject = [LXProtocolWifiGet new];
	LXProtocolWifiGet_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.interface = structValue.interface;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWifiGet_t);
}

- (NSData *)dataValue
{
	LXProtocolWifiGet_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.interface = self.interface;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(interface)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWifiSet_t {
	LXProtocolWifiInterface interface;
	BOOL active;
} LXProtocolWifiSet_t;
#pragma pack(pop)

@implementation LXProtocolWifiSet

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWifiSet *newObject = [LXProtocolWifiSet new];
	LXProtocolWifiSet_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.interface = structValue.interface;
	newObject.active = structValue.active;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWifiSet_t);
}

- (NSData *)dataValue
{
	LXProtocolWifiSet_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.interface = self.interface;
	structValue.active = self.active;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(interface), SelfKey(active)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWifiState_t {
	LXProtocolWifiInterface interface;
	LXProtocolWifiStatus status;
	uint32_t ipv4;
	uint8_t ipv6[16];
} LXProtocolWifiState_t;
#pragma pack(pop)

@implementation LXProtocolWifiState

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWifiState *newObject = [LXProtocolWifiState new];
	LXProtocolWifiState_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.interface = structValue.interface;
	newObject.status = structValue.status;
	newObject.ipv4 = structValue.ipv4;
	newObject.ipv6 = [NSData dataWithBytes:structValue.ipv6 length:sizeof(structValue.ipv6)];
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWifiState_t);
}

- (NSData *)dataValue
{
	LXProtocolWifiState_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.interface = self.interface;
	structValue.status = self.status;
	structValue.ipv4 = self.ipv4;
	if (self.ipv6.length != sizeof(structValue.ipv6)) LFXLogWarn(@"Warning: %@.ipv6 (%@) isn't the correct length (%tu)", NSStringFromClass(self.class), self.ipv6, sizeof(structValue.ipv6));
	[self.ipv6 getBytes:structValue.ipv6 length:sizeof(structValue.ipv6)];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(interface), SelfKey(status), SelfKey(ipv4), SelfKey(ipv6)];
}
	
@end


//===========================================================================


@implementation LXProtocolWifiGetAccessPoints

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWifiStateAccessPoints_t {
	LXProtocolWifiInterface interface;
	uint8_t ssid[32];
	LXProtocolWifiSecurity security;
	int16_t strength;
	uint16_t channel;
} LXProtocolWifiStateAccessPoints_t;
#pragma pack(pop)

@implementation LXProtocolWifiStateAccessPoints

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWifiStateAccessPoints *newObject = [LXProtocolWifiStateAccessPoints new];
	LXProtocolWifiStateAccessPoints_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.interface = structValue.interface;
	//newObject.ssid = @((char *)structValue.ssid);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t ssidTempBuffer[200];
	memset(ssidTempBuffer, 0, sizeof(ssidTempBuffer));
	memcpy(ssidTempBuffer, structValue.ssid, sizeof(structValue.ssid));
	newObject.ssid = @((char *)ssidTempBuffer);
	newObject.security = structValue.security;
	newObject.strength = structValue.strength;
	newObject.channel = structValue.channel;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWifiStateAccessPoints_t);
}

- (NSData *)dataValue
{
	LXProtocolWifiStateAccessPoints_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.interface = self.interface;
	if (self.ssid.length >= sizeof(structValue.ssid)) LFXLogWarn(@"Warning: %@.ssid (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.ssid, sizeof(structValue.ssid));
	[self.ssid getBytes:structValue.ssid maxLength:sizeof(structValue.ssid) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.ssid.length) remainingRange:NULL];
	structValue.security = self.security;
	structValue.strength = self.strength;
	structValue.channel = self.channel;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(interface), SelfKey(ssid), SelfKey(security), SelfKey(strength), SelfKey(channel)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWifiGetAccessPoint_t {
	LXProtocolWifiInterface interface;
} LXProtocolWifiGetAccessPoint_t;
#pragma pack(pop)

@implementation LXProtocolWifiGetAccessPoint

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWifiGetAccessPoint *newObject = [LXProtocolWifiGetAccessPoint new];
	LXProtocolWifiGetAccessPoint_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.interface = structValue.interface;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWifiGetAccessPoint_t);
}

- (NSData *)dataValue
{
	LXProtocolWifiGetAccessPoint_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.interface = self.interface;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(interface)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWifiSetAccessPoint_t {
	LXProtocolWifiInterface interface;
	uint8_t ssid[32];
	uint8_t pass[64];
	LXProtocolWifiSecurity security;
} LXProtocolWifiSetAccessPoint_t;
#pragma pack(pop)

@implementation LXProtocolWifiSetAccessPoint

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWifiSetAccessPoint *newObject = [LXProtocolWifiSetAccessPoint new];
	LXProtocolWifiSetAccessPoint_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.interface = structValue.interface;
	//newObject.ssid = @((char *)structValue.ssid);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t ssidTempBuffer[200];
	memset(ssidTempBuffer, 0, sizeof(ssidTempBuffer));
	memcpy(ssidTempBuffer, structValue.ssid, sizeof(structValue.ssid));
	newObject.ssid = @((char *)ssidTempBuffer);
	//newObject.pass = @((char *)structValue.pass);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t passTempBuffer[200];
	memset(passTempBuffer, 0, sizeof(passTempBuffer));
	memcpy(passTempBuffer, structValue.pass, sizeof(structValue.pass));
	newObject.pass = @((char *)passTempBuffer);
	newObject.security = structValue.security;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWifiSetAccessPoint_t);
}

- (NSData *)dataValue
{
	LXProtocolWifiSetAccessPoint_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.interface = self.interface;
	if (self.ssid.length >= sizeof(structValue.ssid)) LFXLogWarn(@"Warning: %@.ssid (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.ssid, sizeof(structValue.ssid));
	[self.ssid getBytes:structValue.ssid maxLength:sizeof(structValue.ssid) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.ssid.length) remainingRange:NULL];
	if (self.pass.length >= sizeof(structValue.pass)) LFXLogWarn(@"Warning: %@.pass (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.pass, sizeof(structValue.pass));
	[self.pass getBytes:structValue.pass maxLength:sizeof(structValue.pass) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.pass.length) remainingRange:NULL];
	structValue.security = self.security;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(interface), SelfKey(ssid), SelfKey(pass), SelfKey(security)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWifiStateAccessPoint_t {
	LXProtocolWifiInterface interface;
	uint8_t ssid[32];
	uint8_t pass[32];
	LXProtocolWifiSecurity security;
} LXProtocolWifiStateAccessPoint_t;
#pragma pack(pop)

@implementation LXProtocolWifiStateAccessPoint

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWifiStateAccessPoint *newObject = [LXProtocolWifiStateAccessPoint new];
	LXProtocolWifiStateAccessPoint_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.interface = structValue.interface;
	//newObject.ssid = @((char *)structValue.ssid);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t ssidTempBuffer[200];
	memset(ssidTempBuffer, 0, sizeof(ssidTempBuffer));
	memcpy(ssidTempBuffer, structValue.ssid, sizeof(structValue.ssid));
	newObject.ssid = @((char *)ssidTempBuffer);
	//newObject.pass = @((char *)structValue.pass);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t passTempBuffer[200];
	memset(passTempBuffer, 0, sizeof(passTempBuffer));
	memcpy(passTempBuffer, structValue.pass, sizeof(structValue.pass));
	newObject.pass = @((char *)passTempBuffer);
	newObject.security = structValue.security;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWifiStateAccessPoint_t);
}

- (NSData *)dataValue
{
	LXProtocolWifiStateAccessPoint_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.interface = self.interface;
	if (self.ssid.length >= sizeof(structValue.ssid)) LFXLogWarn(@"Warning: %@.ssid (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.ssid, sizeof(structValue.ssid));
	[self.ssid getBytes:structValue.ssid maxLength:sizeof(structValue.ssid) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.ssid.length) remainingRange:NULL];
	if (self.pass.length >= sizeof(structValue.pass)) LFXLogWarn(@"Warning: %@.pass (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.pass, sizeof(structValue.pass));
	[self.pass getBytes:structValue.pass maxLength:sizeof(structValue.pass) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.pass.length) remainingRange:NULL];
	structValue.security = self.security;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(interface), SelfKey(ssid), SelfKey(pass), SelfKey(security)];
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolWifiSetAccessPointBroadcast_t {
	LXProtocolWifiInterface interface;
	uint8_t ssid[32];
	uint8_t pass[64];
	LXProtocolWifiSecurity security;
	uint8_t key[16];
} LXProtocolWifiSetAccessPointBroadcast_t;
#pragma pack(pop)

@implementation LXProtocolWifiSetAccessPointBroadcast

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolWifiSetAccessPointBroadcast *newObject = [LXProtocolWifiSetAccessPointBroadcast new];
	LXProtocolWifiSetAccessPointBroadcast_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.interface = structValue.interface;
	//newObject.ssid = @((char *)structValue.ssid);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t ssidTempBuffer[200];
	memset(ssidTempBuffer, 0, sizeof(ssidTempBuffer));
	memcpy(ssidTempBuffer, structValue.ssid, sizeof(structValue.ssid));
	newObject.ssid = @((char *)ssidTempBuffer);
	//newObject.pass = @((char *)structValue.pass);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t passTempBuffer[200];
	memset(passTempBuffer, 0, sizeof(passTempBuffer));
	memcpy(passTempBuffer, structValue.pass, sizeof(structValue.pass));
	newObject.pass = @((char *)passTempBuffer);
	newObject.security = structValue.security;
	//newObject.key = @((char *)structValue.key);
	// Temporary hack to handle non-null-terminated string buffers. -[NSString -initWithBytes:length:encoding:] seems to have some sort of nasty bug, I suspect that it isn't copying the byte buffer properly
	uint8_t keyTempBuffer[200];
	memset(keyTempBuffer, 0, sizeof(keyTempBuffer));
	memcpy(keyTempBuffer, structValue.key, sizeof(structValue.key));
	newObject.key = @((char *)keyTempBuffer);
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolWifiSetAccessPointBroadcast_t);
}

- (NSData *)dataValue
{
	LXProtocolWifiSetAccessPointBroadcast_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.interface = self.interface;
	if (self.ssid.length >= sizeof(structValue.ssid)) LFXLogWarn(@"Warning: %@.ssid (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.ssid, sizeof(structValue.ssid));
	[self.ssid getBytes:structValue.ssid maxLength:sizeof(structValue.ssid) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.ssid.length) remainingRange:NULL];
	if (self.pass.length >= sizeof(structValue.pass)) LFXLogWarn(@"Warning: %@.pass (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.pass, sizeof(structValue.pass));
	[self.pass getBytes:structValue.pass maxLength:sizeof(structValue.pass) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.pass.length) remainingRange:NULL];
	structValue.security = self.security;
	if (self.key.length >= sizeof(structValue.key)) LFXLogWarn(@"Warning: %@.key (%@) is longer than the maximum length (%tu)", NSStringFromClass(self.class), self.key, sizeof(structValue.key));
	[self.key getBytes:structValue.key maxLength:sizeof(structValue.key) usedLength:NULL encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, self.key.length) remainingRange:NULL];
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(interface), SelfKey(ssid), SelfKey(pass), SelfKey(security), SelfKey(key)];
}
	
@end


//===========================================================================


@implementation LXProtocolSensorGetAmbientLight

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolSensorStateAmbientLight_t {
	float lux;
} LXProtocolSensorStateAmbientLight_t;
#pragma pack(pop)

@implementation LXProtocolSensorStateAmbientLight

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolSensorStateAmbientLight *newObject = [LXProtocolSensorStateAmbientLight new];
	LXProtocolSensorStateAmbientLight_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.lux = structValue.lux;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolSensorStateAmbientLight_t);
}

- (NSData *)dataValue
{
	LXProtocolSensorStateAmbientLight_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.lux = self.lux;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(lux)];
}
	
@end


//===========================================================================


@implementation LXProtocolSensorGetDimmerVoltage

- (NSData *)dataValue
{
	return nil;
}
	
@end


//===========================================================================

#pragma pack(push, 1)
typedef struct LXProtocolSensorStateDimmerVoltage_t {
	uint32_t voltage;
} LXProtocolSensorStateDimmerVoltage_t;
#pragma pack(pop)

@implementation LXProtocolSensorStateDimmerVoltage

+ (instancetype)objectWithData:(NSData *)data
{
	LXProtocolSensorStateDimmerVoltage *newObject = [LXProtocolSensorStateDimmerVoltage new];
	LXProtocolSensorStateDimmerVoltage_t structValue;
	if (data.length != sizeof(structValue)) {
		LFXLogWarn(@"Warning: data size (%tu) isn't equal to struct size (%tu) for %@", data.length, sizeof(structValue), NSStringFromClass(self.class));
	}
	memset(&structValue, 0, sizeof(structValue));
	[data getBytes:&structValue length:sizeof(structValue)];

	newObject.voltage = structValue.voltage;
	
	return newObject;
}

+ (NSUInteger)dataSize
{
	return sizeof(LXProtocolSensorStateDimmerVoltage_t);
}

- (NSData *)dataValue
{
	LXProtocolSensorStateDimmerVoltage_t structValue;
	memset(&structValue, 0, sizeof(structValue));
	
	structValue.voltage = self.voltage;
	
	return [NSData dataWithBytes:&structValue length:sizeof(structValue)];
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[SelfKey(voltage)];
}
	
@end


//===========================================================================

