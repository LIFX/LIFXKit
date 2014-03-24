//===========================================================================
//
//	LIFX Protocol Messages Implementation for Objective-C (auto-generated)
//
//===========================================================================

#import "LXProtocolMessages.h"



@implementation LFXMessageDeviceSetSite

+ (Class)payloadClass
{
	return [LXProtocolDeviceSetSite class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_SET_SITE;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetPanGateway

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetPanGateway class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_PAN_GATEWAY;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStatePanGateway

+ (Class)payloadClass
{
	return [LXProtocolDeviceStatePanGateway class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_PAN_GATEWAY;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetTime

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetTime class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_TIME;
}

@end

//===========================================================================


@implementation LFXMessageDeviceSetTime

+ (Class)payloadClass
{
	return [LXProtocolDeviceSetTime class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_SET_TIME;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateTime

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateTime class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_TIME;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetResetSwitch

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetResetSwitch class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_RESET_SWITCH;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateResetSwitch

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateResetSwitch class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_RESET_SWITCH;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetDummyLoad

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetDummyLoad class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_DUMMY_LOAD;
}

@end

//===========================================================================


@implementation LFXMessageDeviceSetDummyLoad

+ (Class)payloadClass
{
	return [LXProtocolDeviceSetDummyLoad class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_SET_DUMMY_LOAD;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateDummyLoad

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateDummyLoad class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_DUMMY_LOAD;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetMeshInfo

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetMeshInfo class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_MESH_INFO;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateMeshInfo

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateMeshInfo class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_MESH_INFO;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetMeshFirmware

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetMeshFirmware class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_MESH_FIRMWARE;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateMeshFirmware

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateMeshFirmware class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_MESH_FIRMWARE;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetWifiInfo

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetWifiInfo class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_WIFI_INFO;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateWifiInfo

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateWifiInfo class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_WIFI_INFO;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetWifiFirmware

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetWifiFirmware class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_WIFI_FIRMWARE;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateWifiFirmware

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateWifiFirmware class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_WIFI_FIRMWARE;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetPower

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetPower class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_POWER;
}

@end

//===========================================================================


@implementation LFXMessageDeviceSetPower

+ (Class)payloadClass
{
	return [LXProtocolDeviceSetPower class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_SET_POWER;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStatePower

+ (Class)payloadClass
{
	return [LXProtocolDeviceStatePower class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_POWER;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetLabel

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetLabel class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_LABEL;
}

@end

//===========================================================================


@implementation LFXMessageDeviceSetLabel

+ (Class)payloadClass
{
	return [LXProtocolDeviceSetLabel class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_SET_LABEL;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateLabel

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateLabel class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_LABEL;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetTags

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetTags class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_TAGS;
}

@end

//===========================================================================


@implementation LFXMessageDeviceSetTags

+ (Class)payloadClass
{
	return [LXProtocolDeviceSetTags class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_SET_TAGS;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateTags

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateTags class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_TAGS;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetTagLabels

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetTagLabels class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_TAG_LABELS;
}

@end

//===========================================================================


@implementation LFXMessageDeviceSetTagLabels

+ (Class)payloadClass
{
	return [LXProtocolDeviceSetTagLabels class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_SET_TAG_LABELS;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateTagLabels

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateTagLabels class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_TAG_LABELS;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetVersion

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetVersion class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_VERSION;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateVersion

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateVersion class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_VERSION;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetInfo

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetInfo class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_INFO;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateInfo

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateInfo class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_INFO;
}

@end

//===========================================================================


@implementation LFXMessageDeviceGetMcuRailVoltage

+ (Class)payloadClass
{
	return [LXProtocolDeviceGetMcuRailVoltage class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_GET_MCU_RAIL_VOLTAGE;
}

@end

//===========================================================================


@implementation LFXMessageDeviceStateMcuRailVoltage

+ (Class)payloadClass
{
	return [LXProtocolDeviceStateMcuRailVoltage class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_STATE_MCU_RAIL_VOLTAGE;
}

@end

//===========================================================================


@implementation LFXMessageDeviceReboot

+ (Class)payloadClass
{
	return [LXProtocolDeviceReboot class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_REBOOT;
}

@end

//===========================================================================


@implementation LFXMessageDeviceSetFactoryTestMode

+ (Class)payloadClass
{
	return [LXProtocolDeviceSetFactoryTestMode class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_SET_FACTORY_TEST_MODE;
}

@end

//===========================================================================


@implementation LFXMessageDeviceDisableFactoryTestMode

+ (Class)payloadClass
{
	return [LXProtocolDeviceDisableFactoryTestMode class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_DEVICE_DISABLE_FACTORY_TEST_MODE;
}

@end

//===========================================================================


@implementation LFXMessageLightGet

+ (Class)payloadClass
{
	return [LXProtocolLightGet class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_GET;
}

@end

//===========================================================================


@implementation LFXMessageLightSet

+ (Class)payloadClass
{
	return [LXProtocolLightSet class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_SET;
}

@end

//===========================================================================


@implementation LFXMessageLightSetWaveform

+ (Class)payloadClass
{
	return [LXProtocolLightSetWaveform class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_SET_WAVEFORM;
}

@end

//===========================================================================


@implementation LFXMessageLightSetDimAbsolute

+ (Class)payloadClass
{
	return [LXProtocolLightSetDimAbsolute class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_SET_DIM_ABSOLUTE;
}

@end

//===========================================================================


@implementation LFXMessageLightSetDimRelative

+ (Class)payloadClass
{
	return [LXProtocolLightSetDimRelative class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_SET_DIM_RELATIVE;
}

@end

//===========================================================================


@implementation LFXMessageLightSetRgbw

+ (Class)payloadClass
{
	return [LXProtocolLightSetRgbw class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_SET_RGBW;
}

@end

//===========================================================================


@implementation LFXMessageLightState

+ (Class)payloadClass
{
	return [LXProtocolLightState class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_STATE;
}

@end

//===========================================================================


@implementation LFXMessageLightGetRailVoltage

+ (Class)payloadClass
{
	return [LXProtocolLightGetRailVoltage class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_GET_RAIL_VOLTAGE;
}

@end

//===========================================================================


@implementation LFXMessageLightStateRailVoltage

+ (Class)payloadClass
{
	return [LXProtocolLightStateRailVoltage class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_STATE_RAIL_VOLTAGE;
}

@end

//===========================================================================


@implementation LFXMessageLightGetTemperature

+ (Class)payloadClass
{
	return [LXProtocolLightGetTemperature class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_GET_TEMPERATURE;
}

@end

//===========================================================================


@implementation LFXMessageLightStateTemperature

+ (Class)payloadClass
{
	return [LXProtocolLightStateTemperature class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_LIGHT_STATE_TEMPERATURE;
}

@end

//===========================================================================


@implementation LFXMessageWanConnectPlain

+ (Class)payloadClass
{
	return [LXProtocolWanConnectPlain class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WAN_CONNECT_PLAIN;
}

@end

//===========================================================================


@implementation LFXMessageWanConnectKey

+ (Class)payloadClass
{
	return [LXProtocolWanConnectKey class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WAN_CONNECT_KEY;
}

@end

//===========================================================================


@implementation LFXMessageWanStateConnect

+ (Class)payloadClass
{
	return [LXProtocolWanStateConnect class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WAN_STATE_CONNECT;
}

@end

//===========================================================================


@implementation LFXMessageWanSub

+ (Class)payloadClass
{
	return [LXProtocolWanSub class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WAN_SUB;
}

@end

//===========================================================================


@implementation LFXMessageWanUnsub

+ (Class)payloadClass
{
	return [LXProtocolWanUnsub class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WAN_UNSUB;
}

@end

//===========================================================================


@implementation LFXMessageWanStateSub

+ (Class)payloadClass
{
	return [LXProtocolWanStateSub class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WAN_STATE_SUB;
}

@end

//===========================================================================


@implementation LFXMessageWifiGet

+ (Class)payloadClass
{
	return [LXProtocolWifiGet class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WIFI_GET;
}

@end

//===========================================================================


@implementation LFXMessageWifiSet

+ (Class)payloadClass
{
	return [LXProtocolWifiSet class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WIFI_SET;
}

@end

//===========================================================================


@implementation LFXMessageWifiState

+ (Class)payloadClass
{
	return [LXProtocolWifiState class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WIFI_STATE;
}

@end

//===========================================================================


@implementation LFXMessageWifiGetAccessPoint

+ (Class)payloadClass
{
	return [LXProtocolWifiGetAccessPoint class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WIFI_GET_ACCESS_POINT;
}

@end

//===========================================================================


@implementation LFXMessageWifiSetAccessPoint

+ (Class)payloadClass
{
	return [LXProtocolWifiSetAccessPoint class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WIFI_SET_ACCESS_POINT;
}

@end

//===========================================================================


@implementation LFXMessageWifiStateAccessPoint

+ (Class)payloadClass
{
	return [LXProtocolWifiStateAccessPoint class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_WIFI_STATE_ACCESS_POINT;
}

@end

//===========================================================================


@implementation LFXMessageSensorGetAmbientLight

+ (Class)payloadClass
{
	return [LXProtocolSensorGetAmbientLight class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_SENSOR_GET_AMBIENT_LIGHT;
}

@end

//===========================================================================


@implementation LFXMessageSensorStateAmbientLight

+ (Class)payloadClass
{
	return [LXProtocolSensorStateAmbientLight class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_SENSOR_STATE_AMBIENT_LIGHT;
}

@end

//===========================================================================


@implementation LFXMessageSensorGetDimmerVoltage

+ (Class)payloadClass
{
	return [LXProtocolSensorGetDimmerVoltage class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_SENSOR_GET_DIMMER_VOLTAGE;
}

@end

//===========================================================================


@implementation LFXMessageSensorStateDimmerVoltage

+ (Class)payloadClass
{
	return [LXProtocolSensorStateDimmerVoltage class];
}

+ (LFXMessageType)messageType
{
	return LX_PROTOCOL_SENSOR_STATE_DIMMER_VOLTAGE;
}

@end

//===========================================================================

