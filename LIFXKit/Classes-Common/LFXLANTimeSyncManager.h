//
//  LFXLANTimeSyncManager.h
//  LIFXKit
//
//  Created by Nick Forge on 4/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXTransportManager.h"
@class LFXSiteID;

@interface LFXLANTimeSyncManager : NSObject

- (id)initWithTransportManager:(LFXTransportManager *)transportManager;

@end
