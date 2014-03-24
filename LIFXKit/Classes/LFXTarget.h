//
//  LFXTarget.h
//  LIFX
//
//  Created by Nick Forge on 4/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LFXTargetType) {
	LFXTargetTypeBroadcast,
	LFXTargetTypeDevice,
	LFXTargetTypeTag,
};

@interface LFXTarget : NSObject

+ (LFXTarget *)broadcastTarget;
+ (LFXTarget *)deviceTargetWithDeviceID:(NSString *)deviceID;
+ (LFXTarget *)tagTargetWithTag:(NSString *)tag;

@property (nonatomic) LFXTargetType targetType;

@property (nonatomic, readonly) NSString *deviceID;
@property (nonatomic, readonly) NSString *tag;


// This can be used for persistence.
// * = Broadcast
// #TagName = Tag
// 124f31a5 = Device

- (NSString *)stringValue;

+ (LFXTarget *)targetWithString:(NSString *)string;

@end
