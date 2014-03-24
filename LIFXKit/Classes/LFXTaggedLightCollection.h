//
//  LFXTaggedLightCollection.h
//  LIFX
//
//  Created by Nick Forge on 3/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXLightCollection.h"
@class LFXLight;

@interface LFXTaggedLightCollection : LFXLightCollection



// Each LFXTaggedLightCollection uniquely corresponds to a particular
@property (nonatomic, readonly) NSString *tag;


// Returns YES on success, or NO if there was already a tag with that name
- (BOOL)renameWithNewTag:(NSString *)tag;


// Use these methods to manage light/tag relationships
- (void)addLight:(LFXLight *)light;
- (void)removeLight:(LFXLight *)light;
- (void)removeAllLights;

@end
