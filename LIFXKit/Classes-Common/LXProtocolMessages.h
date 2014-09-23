//===========================================================================
//
//	LIFX Protocol Messages Header for Objective-C (auto-generated)
//
//===========================================================================

#import "LXProtocolTypes.h"
#import "LFXMessage.h"

typedef LXProtocolType LFXMessageType;

//===========================================================================


@interface LFXMessageDeviceSetSite : LFXMessage

@property (nonatomic) LXProtocolDeviceSetSite* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateSite : LFXMessage

@property (nonatomic) LXProtocolDeviceStateSite* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetPanGateway : LFXMessage

@property (nonatomic) LXProtocolDeviceGetPanGateway* payload;

@end


//===========================================================================


@interface LFXMessageDeviceSetPanGateway : LFXMessage

@property (nonatomic) LXProtocolDeviceSetPanGateway* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStatePanGateway : LFXMessage

@property (nonatomic) LXProtocolDeviceStatePanGateway* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetTime : LFXMessage

@property (nonatomic) LXProtocolDeviceGetTime* payload;

@end


//===========================================================================


@interface LFXMessageDeviceSetTime : LFXMessage

@property (nonatomic) LXProtocolDeviceSetTime* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateTime : LFXMessage

@property (nonatomic) LXProtocolDeviceStateTime* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetResetSwitch : LFXMessage

@property (nonatomic) LXProtocolDeviceGetResetSwitch* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateResetSwitch : LFXMessage

@property (nonatomic) LXProtocolDeviceStateResetSwitch* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetDummyLoad : LFXMessage

@property (nonatomic) LXProtocolDeviceGetDummyLoad* payload;

@end


//===========================================================================


@interface LFXMessageDeviceSetDummyLoad : LFXMessage

@property (nonatomic) LXProtocolDeviceSetDummyLoad* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateDummyLoad : LFXMessage

@property (nonatomic) LXProtocolDeviceStateDummyLoad* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetMeshInfo : LFXMessage

@property (nonatomic) LXProtocolDeviceGetMeshInfo* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateMeshInfo : LFXMessage

@property (nonatomic) LXProtocolDeviceStateMeshInfo* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetMeshFirmware : LFXMessage

@property (nonatomic) LXProtocolDeviceGetMeshFirmware* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateMeshFirmware : LFXMessage

@property (nonatomic) LXProtocolDeviceStateMeshFirmware* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetWifiInfo : LFXMessage

@property (nonatomic) LXProtocolDeviceGetWifiInfo* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateWifiInfo : LFXMessage

@property (nonatomic) LXProtocolDeviceStateWifiInfo* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetWifiFirmware : LFXMessage

@property (nonatomic) LXProtocolDeviceGetWifiFirmware* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateWifiFirmware : LFXMessage

@property (nonatomic) LXProtocolDeviceStateWifiFirmware* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetPower : LFXMessage

@property (nonatomic) LXProtocolDeviceGetPower* payload;

@end


//===========================================================================


@interface LFXMessageDeviceSetPower : LFXMessage

@property (nonatomic) LXProtocolDeviceSetPower* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStatePower : LFXMessage

@property (nonatomic) LXProtocolDeviceStatePower* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetLabel : LFXMessage

@property (nonatomic) LXProtocolDeviceGetLabel* payload;

@end


//===========================================================================


@interface LFXMessageDeviceSetLabel : LFXMessage

@property (nonatomic) LXProtocolDeviceSetLabel* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateLabel : LFXMessage

@property (nonatomic) LXProtocolDeviceStateLabel* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetTags : LFXMessage

@property (nonatomic) LXProtocolDeviceGetTags* payload;

@end


//===========================================================================


@interface LFXMessageDeviceSetTags : LFXMessage

@property (nonatomic) LXProtocolDeviceSetTags* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateTags : LFXMessage

@property (nonatomic) LXProtocolDeviceStateTags* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetTagLabels : LFXMessage

@property (nonatomic) LXProtocolDeviceGetTagLabels* payload;

@end


//===========================================================================


@interface LFXMessageDeviceSetTagLabels : LFXMessage

@property (nonatomic) LXProtocolDeviceSetTagLabels* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateTagLabels : LFXMessage

@property (nonatomic) LXProtocolDeviceStateTagLabels* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetVersion : LFXMessage

@property (nonatomic) LXProtocolDeviceGetVersion* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateVersion : LFXMessage

@property (nonatomic) LXProtocolDeviceStateVersion* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetInfo : LFXMessage

@property (nonatomic) LXProtocolDeviceGetInfo* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateInfo : LFXMessage

@property (nonatomic) LXProtocolDeviceStateInfo* payload;

@end


//===========================================================================


@interface LFXMessageDeviceGetMcuRailVoltage : LFXMessage

@property (nonatomic) LXProtocolDeviceGetMcuRailVoltage* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateMcuRailVoltage : LFXMessage

@property (nonatomic) LXProtocolDeviceStateMcuRailVoltage* payload;

@end


//===========================================================================


@interface LFXMessageDeviceSetFactoryTestMode : LFXMessage

@property (nonatomic) LXProtocolDeviceSetFactoryTestMode* payload;

@end


//===========================================================================


@interface LFXMessageDeviceDisableFactoryTestMode : LFXMessage

@property (nonatomic) LXProtocolDeviceDisableFactoryTestMode* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateFactoryTestMode : LFXMessage

@property (nonatomic) LXProtocolDeviceStateFactoryTestMode* payload;

@end


//===========================================================================


@interface LFXMessageDeviceSetReboot : LFXMessage

@property (nonatomic) LXProtocolDeviceSetReboot* payload;

@end


//===========================================================================


@interface LFXMessageDeviceStateReboot : LFXMessage

@property (nonatomic) LXProtocolDeviceStateReboot* payload;

@end


//===========================================================================


@interface LFXMessageDeviceAcknowledgement : LFXMessage

@property (nonatomic) LXProtocolDeviceAcknowledgement* payload;

@end


//===========================================================================


@interface LFXMessageLightGet : LFXMessage

@property (nonatomic) LXProtocolLightGet* payload;

@end


//===========================================================================


@interface LFXMessageLightSetColor : LFXMessage

@property (nonatomic) LXProtocolLightSetColor* payload;

@end


//===========================================================================


@interface LFXMessageLightSetWaveformOptional : LFXMessage

@property (nonatomic) LXProtocolLightSetWaveformOptional* payload;

@end


//===========================================================================


@interface LFXMessageLightSetWaveform : LFXMessage

@property (nonatomic) LXProtocolLightSetWaveform* payload;

@end


//===========================================================================


@interface LFXMessageLightGetPower : LFXMessage

@property (nonatomic) LXProtocolLightGetPower* payload;

@end


//===========================================================================


@interface LFXMessageLightSetPower : LFXMessage

@property (nonatomic) LXProtocolLightSetPower* payload;

@end


//===========================================================================


@interface LFXMessageLightStatePower : LFXMessage

@property (nonatomic) LXProtocolLightStatePower* payload;

@end


//===========================================================================


@interface LFXMessageLightSetSimpleEvent : LFXMessage

@property (nonatomic) LXProtocolLightSetSimpleEvent* payload;

@end


//===========================================================================


@interface LFXMessageLightGetSimpleEvent : LFXMessage

@property (nonatomic) LXProtocolLightGetSimpleEvent* payload;

@end


//===========================================================================


@interface LFXMessageLightStateSimpleEvent : LFXMessage

@property (nonatomic) LXProtocolLightStateSimpleEvent* payload;

@end


//===========================================================================


@interface LFXMessageLightSetDimAbsolute : LFXMessage

@property (nonatomic) LXProtocolLightSetDimAbsolute* payload;

@end


//===========================================================================


@interface LFXMessageLightSetDimRelative : LFXMessage

@property (nonatomic) LXProtocolLightSetDimRelative* payload;

@end


//===========================================================================


@interface LFXMessageLightSetRgbw : LFXMessage

@property (nonatomic) LXProtocolLightSetRgbw* payload;

@end


//===========================================================================


@interface LFXMessageLightState : LFXMessage

@property (nonatomic) LXProtocolLightState* payload;

@end


//===========================================================================


@interface LFXMessageLightGetRailVoltage : LFXMessage

@property (nonatomic) LXProtocolLightGetRailVoltage* payload;

@end


//===========================================================================


@interface LFXMessageLightStateRailVoltage : LFXMessage

@property (nonatomic) LXProtocolLightStateRailVoltage* payload;

@end


//===========================================================================


@interface LFXMessageLightGetTemperature : LFXMessage

@property (nonatomic) LXProtocolLightGetTemperature* payload;

@end


//===========================================================================


@interface LFXMessageLightStateTemperature : LFXMessage

@property (nonatomic) LXProtocolLightStateTemperature* payload;

@end


//===========================================================================


@interface LFXMessageLightSetCalibrationCoefficients : LFXMessage

@property (nonatomic) LXProtocolLightSetCalibrationCoefficients* payload;

@end


//===========================================================================


@interface LFXMessageWanSetAuthKey : LFXMessage

@property (nonatomic) LXProtocolWanSetAuthKey* payload;

@end


//===========================================================================


@interface LFXMessageWanGetAuthKey : LFXMessage

@property (nonatomic) LXProtocolWanGetAuthKey* payload;

@end


//===========================================================================


@interface LFXMessageWanStateAuthKey : LFXMessage

@property (nonatomic) LXProtocolWanStateAuthKey* payload;

@end


//===========================================================================


@interface LFXMessageWanGet : LFXMessage

@property (nonatomic) LXProtocolWanGet* payload;

@end


//===========================================================================


@interface LFXMessageWanSet : LFXMessage

@property (nonatomic) LXProtocolWanSet* payload;

@end


//===========================================================================


@interface LFXMessageWanState : LFXMessage

@property (nonatomic) LXProtocolWanState* payload;

@end


//===========================================================================


@interface LFXMessageWanSetKeepAlive : LFXMessage

@property (nonatomic) LXProtocolWanSetKeepAlive* payload;

@end


//===========================================================================


@interface LFXMessageWanStateKeepAlive : LFXMessage

@property (nonatomic) LXProtocolWanStateKeepAlive* payload;

@end


//===========================================================================


@interface LFXMessageWanSetHost : LFXMessage

@property (nonatomic) LXProtocolWanSetHost* payload;

@end


//===========================================================================


@interface LFXMessageWanGetHost : LFXMessage

@property (nonatomic) LXProtocolWanGetHost* payload;

@end


//===========================================================================


@interface LFXMessageWanStateHost : LFXMessage

@property (nonatomic) LXProtocolWanStateHost* payload;

@end


//===========================================================================


@interface LFXMessageWifiGet : LFXMessage

@property (nonatomic) LXProtocolWifiGet* payload;

@end


//===========================================================================


@interface LFXMessageWifiSet : LFXMessage

@property (nonatomic) LXProtocolWifiSet* payload;

@end


//===========================================================================


@interface LFXMessageWifiState : LFXMessage

@property (nonatomic) LXProtocolWifiState* payload;

@end


//===========================================================================


@interface LFXMessageWifiGetAccessPoints : LFXMessage

@property (nonatomic) LXProtocolWifiGetAccessPoints* payload;

@end


//===========================================================================


@interface LFXMessageWifiStateAccessPoints : LFXMessage

@property (nonatomic) LXProtocolWifiStateAccessPoints* payload;

@end


//===========================================================================


@interface LFXMessageWifiGetAccessPoint : LFXMessage

@property (nonatomic) LXProtocolWifiGetAccessPoint* payload;

@end


//===========================================================================


@interface LFXMessageWifiSetAccessPoint : LFXMessage

@property (nonatomic) LXProtocolWifiSetAccessPoint* payload;

@end


//===========================================================================


@interface LFXMessageWifiStateAccessPoint : LFXMessage

@property (nonatomic) LXProtocolWifiStateAccessPoint* payload;

@end


//===========================================================================


@interface LFXMessageWifiSetAccessPointBroadcast : LFXMessage

@property (nonatomic) LXProtocolWifiSetAccessPointBroadcast* payload;

@end


//===========================================================================


@interface LFXMessageSensorGetAmbientLight : LFXMessage

@property (nonatomic) LXProtocolSensorGetAmbientLight* payload;

@end


//===========================================================================


@interface LFXMessageSensorStateAmbientLight : LFXMessage

@property (nonatomic) LXProtocolSensorStateAmbientLight* payload;

@end


//===========================================================================


@interface LFXMessageSensorGetDimmerVoltage : LFXMessage

@property (nonatomic) LXProtocolSensorGetDimmerVoltage* payload;

@end


//===========================================================================


@interface LFXMessageSensorStateDimmerVoltage : LFXMessage

@property (nonatomic) LXProtocolSensorStateDimmerVoltage* payload;

@end


//===========================================================================

