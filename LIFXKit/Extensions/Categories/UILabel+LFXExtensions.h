//
//  UILabel+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 5/02/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LFXExtensions)

- (void)lfx_fadeToText:(NSString *)text duration:(NSTimeInterval)duration;
- (void)lfx_fadeToText:(NSString *)text textColor:(UIColor *)textColor duration:(NSTimeInterval)duration;

@end
