//
//  LFXAdHocLightCollection.h
//  LIFXKit
//
//  Created by Nick Forge on 20/06/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXLightCollection.h"
@class LFXLight;

// To create an LFXAdHocLightCollection, use -[LFXNetworkContext createAdHocLightCollection].

@interface LFXAdHocLightCollection : LFXLightCollection

- (void)addLight:(LFXLight *)light;
- (void)removeLight:(LFXLight *)light;
- (void)removeAllLights;

@end
