//
//  UITableView+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 17/12/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "UITableView+LFXExtensions.h"

@implementation UITableView (LFXExtensions)

- (CGFloat)lfx_contentHeight
{
	NSInteger lastSection = [self numberOfSections] - 1;
	return CGRectGetMaxY([self rectForSection:lastSection]);
}

@end
