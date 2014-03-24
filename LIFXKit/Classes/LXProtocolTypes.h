//===========================================================================
//
//	LIFX Protocol Header for Objective-C (auto-generated)
//
//===========================================================================

#import "Structle.h"

typedef NS_ENUM(uint8_t, LXProtocolDeviceService) {
	LX_PROTOCOL_DEVICE_SERVICE_UDP = 1,
	LX_PROTOCOL_DEVICE_SERVICE_TCP = 2,
};

typedef NS_ENUM(uint8_t, LXProtocolLightWaveform) {
	LX_PROTOCOL_LIGHT_WAVEFORM_SAW = 0,
	LX_PROTOCOL_LIGHT_WAVEFORM_SINE = 1,
	LX_PROTOCOL_LIGHT_WAVEFORM_HALF_SINE = 2,
	LX_PROTOCOL_LIGHT_WAVEFORM_TRIANGLE = 3,
	LX_PROTOCOL_LIGHT_WAVEFORM_PULSE = 4,
};

typedef NS_ENUM(uint8_t, LXProtocolWifiInterface) {
	LX_PROTOCOL_WIFI_INTERFACE_SOFT_AP = 1,
	LX_PROTOCOL_WIFI_INTERFACE_STATION = 2,
};

typedef NS_ENUM(uint8_t, LXProtocolWifiSecurity) {
	LX_PROTOCOL_WIFI_SECURITY_UNKNOWN = 0,
	LX_PROTOCOL_WIFI_SECURITY_OPEN = 1,
	LX_PROTOCOL_WIFI_SECURITY_WEP_PSK = 2,
	LX_PROTOCOL_WIFI_SECURITY_WPA_TKIP_PSK = 3,
	LX_PROTOCOL_WIFI_SECURITY_WPA_AES_PSK = 4,
	LX_PROTOCOL_WIFI_SECURITY_WPA2_AES_PSK = 5,
	LX_PROTOCOL_WIFI_SECURITY_WPA2_TKIP_PSK = 6,
	LX_PROTOCOL_WIFI_SECURITY_WPA2_MIXED_PSK = 7,
};

typedef NS_ENUM(uint8_t, LXProtocolWifiStatus) {
	LX_PROTOCOL_WIFI_STATUS_CONNECTING = 0,
	LX_PROTOCOL_WIFI_STATUS_CONNECTED = 1,
	LX_PROTOCOL_WIFI_STATUS_FAILED = 2,
	LX_PROTOCOL_WIFI_STATUS_OFF = 3,
};

typedef NS_ENUM(uint16_t, LXProtocolType) {
	LX_PROTOCOL_DEVICE_SET_SITE = 1,
	LX_PROTOCOL_DEVICE_GET_PAN_GATEWAY = 2,
	LX_PROTOCOL_DEVICE_STATE_PAN_GATEWAY = 3,
	LX_PROTOCOL_DEVICE_GET_TIME = 4,
	LX_PROTOCOL_DEVICE_SET_TIME = 5,
	LX_PROTOCOL_DEVICE_STATE_TIME = 6,
	LX_PROTOCOL_DEVICE_GET_RESET_SWITCH = 7,
	LX_PROTOCOL_DEVICE_STATE_RESET_SWITCH = 8,
	LX_PROTOCOL_DEVICE_GET_DUMMY_LOAD = 9,
	LX_PROTOCOL_DEVICE_SET_DUMMY_LOAD = 10,
	LX_PROTOCOL_DEVICE_STATE_DUMMY_LOAD = 11,
	LX_PROTOCOL_DEVICE_GET_MESH_INFO = 12,
	LX_PROTOCOL_DEVICE_STATE_MESH_INFO = 13,
	LX_PROTOCOL_DEVICE_GET_MESH_FIRMWARE = 14,
	LX_PROTOCOL_DEVICE_STATE_MESH_FIRMWARE = 15,
	LX_PROTOCOL_DEVICE_GET_WIFI_INFO = 16,
	LX_PROTOCOL_DEVICE_STATE_WIFI_INFO = 17,
	LX_PROTOCOL_DEVICE_GET_WIFI_FIRMWARE = 18,
	LX_PROTOCOL_DEVICE_STATE_WIFI_FIRMWARE = 19,
	LX_PROTOCOL_DEVICE_GET_POWER = 20,
	LX_PROTOCOL_DEVICE_SET_POWER = 21,
	LX_PROTOCOL_DEVICE_STATE_POWER = 22,
	LX_PROTOCOL_DEVICE_GET_LABEL = 23,
	LX_PROTOCOL_DEVICE_SET_LABEL = 24,
	LX_PROTOCOL_DEVICE_STATE_LABEL = 25,
	LX_PROTOCOL_DEVICE_GET_TAGS = 26,
	LX_PROTOCOL_DEVICE_SET_TAGS = 27,
	LX_PROTOCOL_DEVICE_STATE_TAGS = 28,
	LX_PROTOCOL_DEVICE_GET_TAG_LABELS = 29,
	LX_PROTOCOL_DEVICE_SET_TAG_LABELS = 30,
	LX_PROTOCOL_DEVICE_STATE_TAG_LABELS = 31,
	LX_PROTOCOL_DEVICE_GET_VERSION = 32,
	LX_PROTOCOL_DEVICE_STATE_VERSION = 33,
	LX_PROTOCOL_DEVICE_GET_INFO = 34,
	LX_PROTOCOL_DEVICE_STATE_INFO = 35,
	LX_PROTOCOL_DEVICE_GET_MCU_RAIL_VOLTAGE = 36,
	LX_PROTOCOL_DEVICE_STATE_MCU_RAIL_VOLTAGE = 37,
	LX_PROTOCOL_DEVICE_REBOOT = 38,
	LX_PROTOCOL_DEVICE_SET_FACTORY_TEST_MODE = 39,
	LX_PROTOCOL_DEVICE_DISABLE_FACTORY_TEST_MODE = 40,
	LX_PROTOCOL_LIGHT_GET = 101,
	LX_PROTOCOL_LIGHT_SET = 102,
	LX_PROTOCOL_LIGHT_SET_WAVEFORM = 103,
	LX_PROTOCOL_LIGHT_SET_DIM_ABSOLUTE = 104,
	LX_PROTOCOL_LIGHT_SET_DIM_RELATIVE = 105,
	LX_PROTOCOL_LIGHT_SET_RGBW = 106,
	LX_PROTOCOL_LIGHT_STATE = 107,
	LX_PROTOCOL_LIGHT_GET_RAIL_VOLTAGE = 108,
	LX_PROTOCOL_LIGHT_STATE_RAIL_VOLTAGE = 109,
	LX_PROTOCOL_LIGHT_GET_TEMPERATURE = 110,
	LX_PROTOCOL_LIGHT_STATE_TEMPERATURE = 111,
	LX_PROTOCOL_WAN_CONNECT_PLAIN = 201,
	LX_PROTOCOL_WAN_CONNECT_KEY = 202,
	LX_PROTOCOL_WAN_STATE_CONNECT = 203,
	LX_PROTOCOL_WAN_SUB = 204,
	LX_PROTOCOL_WAN_UNSUB = 205,
	LX_PROTOCOL_WAN_STATE_SUB = 206,
	LX_PROTOCOL_WIFI_GET = 301,
	LX_PROTOCOL_WIFI_SET = 302,
	LX_PROTOCOL_WIFI_STATE = 303,
	LX_PROTOCOL_WIFI_GET_ACCESS_POINT = 304,
	LX_PROTOCOL_WIFI_SET_ACCESS_POINT = 305,
	LX_PROTOCOL_WIFI_STATE_ACCESS_POINT = 306,
	LX_PROTOCOL_SENSOR_GET_AMBIENT_LIGHT = 401,
	LX_PROTOCOL_SENSOR_STATE_AMBIENT_LIGHT = 402,
	LX_PROTOCOL_SENSOR_GET_DIMMER_VOLTAGE = 403,
	LX_PROTOCOL_SENSOR_STATE_DIMMER_VOLTAGE = 404,
};



//===========================================================================


@interface LXProtocolDeviceSetSite : Structle

@property (nonatomic) NSData * site; // 6 bytes

@end


//===========================================================================


@interface LXProtocolDeviceGetPanGateway : Structle


@end


//===========================================================================


@interface LXProtocolDeviceStatePanGateway : Structle

@property (nonatomic) LXProtocolDeviceService service;
@property (nonatomic) uint32_t port;

@end


//===========================================================================


@interface LXProtocolDeviceGetTime : Structle


@end


//===========================================================================


@interface LXProtocolDeviceSetTime : Structle

@property (nonatomic) uint64_t time;

@end


//===========================================================================


@interface LXProtocolDeviceStateTime : Structle

@property (nonatomic) uint64_t time;

@end


//===========================================================================


@interface LXProtocolDeviceGetResetSwitch : Structle


@end


//===========================================================================


@interface LXProtocolDeviceStateResetSwitch : Structle

@property (nonatomic) uint8_t position;

@end


//===========================================================================


@interface LXProtocolDeviceGetDummyLoad : Structle


@end


//===========================================================================


@interface LXProtocolDeviceSetDummyLoad : Structle

@property (nonatomic) BOOL on;

@end


//===========================================================================


@interface LXProtocolDeviceStateDummyLoad : Structle

@property (nonatomic) BOOL on;

@end


//===========================================================================


@interface LXProtocolDeviceGetMeshInfo : Structle


@end


//===========================================================================


@interface LXProtocolDeviceStateMeshInfo : Structle

@property (nonatomic) float signal;
@property (nonatomic) uint32_t tx;
@property (nonatomic) uint32_t rx;
@property (nonatomic) int16_t mcu_temperature;

@end


//===========================================================================


@interface LXProtocolDeviceGetMeshFirmware : Structle


@end


//===========================================================================


@interface LXProtocolDeviceStateMeshFirmware : Structle

@property (nonatomic) uint64_t build;
@property (nonatomic) uint64_t install;
@property (nonatomic) uint32_t version;

@end


//===========================================================================


@interface LXProtocolDeviceGetWifiInfo : Structle


@end


//===========================================================================


@interface LXProtocolDeviceStateWifiInfo : Structle

@property (nonatomic) float signal;
@property (nonatomic) uint32_t tx;
@property (nonatomic) uint32_t rx;
@property (nonatomic) int16_t mcu_temperature;

@end


//===========================================================================


@interface LXProtocolDeviceGetWifiFirmware : Structle


@end


//===========================================================================


@interface LXProtocolDeviceStateWifiFirmware : Structle

@property (nonatomic) uint64_t build;
@property (nonatomic) uint64_t install;
@property (nonatomic) uint32_t version;

@end


//===========================================================================


@interface LXProtocolDeviceGetPower : Structle


@end


//===========================================================================


@interface LXProtocolDeviceSetPower : Structle

@property (nonatomic) uint16_t level;

@end


//===========================================================================


@interface LXProtocolDeviceStatePower : Structle

@property (nonatomic) uint16_t level;

@end


//===========================================================================


@interface LXProtocolDeviceGetLabel : Structle


@end


//===========================================================================


@interface LXProtocolDeviceSetLabel : Structle

@property (nonatomic) NSString * label; // 32 characters max

@end


//===========================================================================


@interface LXProtocolDeviceStateLabel : Structle

@property (nonatomic) NSString * label; // 32 characters max

@end


//===========================================================================


@interface LXProtocolDeviceGetTags : Structle


@end


//===========================================================================


@interface LXProtocolDeviceSetTags : Structle

@property (nonatomic) uint64_t tags;

@end


//===========================================================================


@interface LXProtocolDeviceStateTags : Structle

@property (nonatomic) uint64_t tags;

@end


//===========================================================================


@interface LXProtocolDeviceGetTagLabels : Structle

@property (nonatomic) uint64_t tags;

@end


//===========================================================================


@interface LXProtocolDeviceSetTagLabels : Structle

@property (nonatomic) uint64_t tags;
@property (nonatomic) NSString * label; // 32 characters max

@end


//===========================================================================


@interface LXProtocolDeviceStateTagLabels : Structle

@property (nonatomic) uint64_t tags;
@property (nonatomic) NSString * label; // 32 characters max

@end


//===========================================================================


@interface LXProtocolDeviceGetVersion : Structle


@end


//===========================================================================


@interface LXProtocolDeviceStateVersion : Structle

@property (nonatomic) uint32_t vendor;
@property (nonatomic) uint32_t product;
@property (nonatomic) uint32_t version;

@end


//===========================================================================


@interface LXProtocolDeviceGetInfo : Structle


@end


//===========================================================================


@interface LXProtocolDeviceStateInfo : Structle

@property (nonatomic) uint64_t time;
@property (nonatomic) uint64_t uptime;
@property (nonatomic) uint64_t downtime;

@end


//===========================================================================


@interface LXProtocolDeviceGetMcuRailVoltage : Structle


@end


//===========================================================================


@interface LXProtocolDeviceStateMcuRailVoltage : Structle

@property (nonatomic) uint32_t voltage;

@end


//===========================================================================


@interface LXProtocolDeviceReboot : Structle


@end


//===========================================================================


@interface LXProtocolDeviceSetFactoryTestMode : Structle

@property (nonatomic) BOOL on;

@end


//===========================================================================


@interface LXProtocolDeviceDisableFactoryTestMode : Structle


@end


//===========================================================================


@interface LXProtocolLightHsbk : Structle

@property (nonatomic) uint16_t hue;
@property (nonatomic) uint16_t saturation;
@property (nonatomic) uint16_t brightness;
@property (nonatomic) uint16_t kelvin;

@end


//===========================================================================


@interface LXProtocolLightGet : Structle


@end


//===========================================================================


@interface LXProtocolLightSet : Structle

@property (nonatomic) uint8_t stream;
@property (nonatomic) LXProtocolLightHsbk * color;
@property (nonatomic) uint32_t duration;

@end


//===========================================================================


@interface LXProtocolLightSetWaveform : Structle

@property (nonatomic) uint8_t stream;
@property (nonatomic) BOOL transient;
@property (nonatomic) LXProtocolLightHsbk * color;
@property (nonatomic) uint32_t period;
@property (nonatomic) float cycles;
@property (nonatomic) int16_t duty_cycle;
@property (nonatomic) LXProtocolLightWaveform waveform;

@end


//===========================================================================


@interface LXProtocolLightSetDimAbsolute : Structle

@property (nonatomic) int16_t brightness;
@property (nonatomic) uint32_t duration;

@end


//===========================================================================


@interface LXProtocolLightSetDimRelative : Structle

@property (nonatomic) int32_t brightness;
@property (nonatomic) uint32_t duration;

@end


//===========================================================================


@interface LXProtocolLightRgbw : Structle

@property (nonatomic) uint16_t red;
@property (nonatomic) uint16_t green;
@property (nonatomic) uint16_t blue;
@property (nonatomic) uint16_t white;

@end


//===========================================================================


@interface LXProtocolLightSetRgbw : Structle

@property (nonatomic) LXProtocolLightRgbw * color;

@end


//===========================================================================


@interface LXProtocolLightState : Structle

@property (nonatomic) LXProtocolLightHsbk * color;
@property (nonatomic) int16_t dim;
@property (nonatomic) uint16_t power;
@property (nonatomic) NSString * label; // 32 characters max
@property (nonatomic) uint64_t tags;

@end


//===========================================================================


@interface LXProtocolLightGetRailVoltage : Structle


@end


//===========================================================================


@interface LXProtocolLightStateRailVoltage : Structle

@property (nonatomic) uint32_t voltage;

@end


//===========================================================================


@interface LXProtocolLightGetTemperature : Structle


@end


//===========================================================================


@interface LXProtocolLightStateTemperature : Structle

@property (nonatomic) int16_t temperature;

@end


//===========================================================================


@interface LXProtocolWanConnectPlain : Structle

@property (nonatomic) NSString * user; // 32 characters max
@property (nonatomic) NSString * pass; // 32 characters max

@end


//===========================================================================


@interface LXProtocolWanConnectKey : Structle

@property (nonatomic) NSData * key; // 32 bytes

@end


//===========================================================================


@interface LXProtocolWanStateConnect : Structle

@property (nonatomic) NSData * key; // 32 bytes

@end


//===========================================================================


@interface LXProtocolWanSub : Structle

@property (nonatomic) NSData * target; // 8 bytes
@property (nonatomic) NSData * site; // 6 bytes
@property (nonatomic) BOOL device;

@end


//===========================================================================


@interface LXProtocolWanUnsub : Structle

@property (nonatomic) NSData * target; // 8 bytes
@property (nonatomic) NSData * site; // 6 bytes
@property (nonatomic) BOOL device;

@end


//===========================================================================


@interface LXProtocolWanStateSub : Structle

@property (nonatomic) NSData * target; // 8 bytes
@property (nonatomic) NSData * site; // 6 bytes
@property (nonatomic) BOOL device;

@end


//===========================================================================


@interface LXProtocolWifiGet : Structle

@property (nonatomic) LXProtocolWifiInterface interface;

@end


//===========================================================================


@interface LXProtocolWifiSet : Structle

@property (nonatomic) LXProtocolWifiInterface interface;
@property (nonatomic) BOOL active;

@end


//===========================================================================


@interface LXProtocolWifiState : Structle

@property (nonatomic) LXProtocolWifiInterface interface;
@property (nonatomic) LXProtocolWifiStatus status;
@property (nonatomic) uint32_t ipv4;
@property (nonatomic) NSData * ipv6; // 16 bytes

@end


//===========================================================================


@interface LXProtocolWifiGetAccessPoint : Structle


@end


//===========================================================================


@interface LXProtocolWifiSetAccessPoint : Structle

@property (nonatomic) LXProtocolWifiInterface interface;
@property (nonatomic) NSString * ssid; // 32 characters max
@property (nonatomic) NSString * pass; // 64 characters max
@property (nonatomic) LXProtocolWifiSecurity security;

@end


//===========================================================================


@interface LXProtocolWifiStateAccessPoint : Structle

@property (nonatomic) LXProtocolWifiInterface interface;
@property (nonatomic) NSString * ssid; // 32 characters max
@property (nonatomic) LXProtocolWifiSecurity security;
@property (nonatomic) int16_t strength;
@property (nonatomic) uint16_t channel;

@end


//===========================================================================


@interface LXProtocolSensorGetAmbientLight : Structle


@end


//===========================================================================


@interface LXProtocolSensorStateAmbientLight : Structle

@property (nonatomic) float lux;

@end


//===========================================================================


@interface LXProtocolSensorGetDimmerVoltage : Structle


@end


//===========================================================================


@interface LXProtocolSensorStateDimmerVoltage : Structle

@property (nonatomic) uint32_t voltage;

@end


//===========================================================================


@interface LXFrame : Structle

@property (nonatomic) uint16_t size;
@property (nonatomic) uint16_t _protocol;
@property (nonatomic) uint32_t reserved;

@end


//===========================================================================


@interface LXFrameAddress : Structle

@property (nonatomic) uint16_t size;
@property (nonatomic) uint16_t _protocol;
@property (nonatomic) uint32_t reserved1;
@property (nonatomic) NSData * target; // 8 bytes
@property (nonatomic) NSData * site; // 6 bytes
@property (nonatomic) uint16_t routing;

@end


//===========================================================================

