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


@interface LFXMessageDeviceGetPanGateway : LFXMessage

@property (nonatomic) LXProtocolDeviceGetPanGateway* payload;

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


@interface LFXMessageDeviceReboot : LFXMessage

@property (nonatomic) LXProtocolDeviceReboot* payload;

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


@interface LFXMessageLightGet : LFXMessage

@property (nonatomic) LXProtocolLightGet* payload;

@end


//===========================================================================


@interface LFXMessageLightSet : LFXMessage

@property (nonatomic) LXProtocolLightSet* payload;

@end


//===========================================================================


@interface LFXMessageLightSetWaveform : LFXMessage

@property (nonatomic) LXProtocolLightSetWaveform* payload;

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


@interface LFXMessageWanConnectPlain : LFXMessage

@property (nonatomic) LXProtocolWanConnectPlain* payload;

@end


//===========================================================================


@interface LFXMessageWanConnectKey : LFXMessage

@property (nonatomic) LXProtocolWanConnectKey* payload;

@end


//===========================================================================


@interface LFXMessageWanStateConnect : LFXMessage

@property (nonatomic) LXProtocolWanStateConnect* payload;

@end


//===========================================================================


@interface LFXMessageWanSub : LFXMessage

@property (nonatomic) LXProtocolWanSub* payload;

@end


//===========================================================================


@interface LFXMessageWanUnsub : LFXMessage

@property (nonatomic) LXProtocolWanUnsub* payload;

@end


//===========================================================================


@interface LFXMessageWanStateSub : LFXMessage

@property (nonatomic) LXProtocolWanStateSub* payload;

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

