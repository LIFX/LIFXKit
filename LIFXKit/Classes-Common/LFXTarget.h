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
	LFXTargetTypeComposite,
};

@interface LFXTarget : NSObject <NSCopying>

+ (LFXTarget *)broadcastTarget;
+ (LFXTarget *)deviceTargetWithDeviceID:(NSString *)deviceID;
+ (LFXTarget *)tagTargetWithTag:(NSString *)tag;
+ (LFXTarget *)compositeTargetWithTargets:(NSArray /* LFXTarget */ *)targets;

@property (nonatomic, readonly) LFXTargetType targetType;

// For LFXTargetTypeDevice
@property (nonatomic, readonly) NSString *deviceID;

// For LFXTargetTypeTag
@property (nonatomic, readonly) NSString *tag;

// For all target types - LFXTargetTypeComposite will return an array of its own targets, and the other types will return an array containing <self>
@property (nonatomic, readonly) NSArray *targets;


// This can be used for persistence.
// * = Broadcast
// #TagName = Tag
// 124f31a5 = Device
// &[*, #Kitchen, 123456] = Composite

- (NSString *)stringValue;

+ (LFXTarget *)targetWithString:(NSString *)string;

@end
