//
//  LFXLightDetailViewController.h
//  LIFX Browser Mac
//
//  Created by Chris Miles on 23/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class  LFXLight;


@interface LFXLightDetailViewController : NSViewController

@property (strong, nonatomic) LFXLight *light;

@end
