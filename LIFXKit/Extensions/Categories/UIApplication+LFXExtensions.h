//
//  UIApplication+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 4/11/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (LFXExtensions)

- (NSString *)lfx_documentsFolderPath;
- (NSString *)lfx_tempFolderPath;

@end
