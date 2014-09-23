//
//  UIView+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 5/11/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LFXExtensions)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

- (void)lfx_fadeToAlpha:(CGFloat)alpha duration:(NSTimeInterval)duration;

@end
