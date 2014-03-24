//
//  UIView+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 5/11/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "UIView+LFXExtensions.h"

@implementation UIView (LFXExtensions)


- (CGFloat)left
{
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newLeft
{
	CGRect frameRect = self.frame;
	frameRect.origin.x = newLeft;
	self.frame = frameRect;
}


- (CGFloat)top
{
	return self.frame.origin.y;
}


- (void)setTop:(CGFloat)newTop
{
	CGRect frameRect = self.frame;
	frameRect.origin.y = newTop;
	self.frame = frameRect;
}


- (CGFloat)right
{
	return self.frame.origin.x + self.frame.size.width;
}


- (void)setRight:(CGFloat)newRight
{
	CGRect frameRect = self.frame;
	frameRect.origin.x = newRight - frameRect.size.width;
	self.frame = frameRect;
}


- (CGFloat)bottom
{
	return self.frame.origin.y + self.frame.size.height;
}


- (void)setBottom:(CGFloat)newBottom
{
	CGRect frameRect = self.frame;
	frameRect.origin.y = newBottom - frameRect.size.height;
	self.frame = frameRect;
}


- (CGFloat)width
{
	return self.frame.size.width;
}


- (void)setWidth:(CGFloat)newWidth
{
	CGRect frameRect = self.frame;
	frameRect.size.width = newWidth;
	self.frame = frameRect;
}


- (CGFloat)height
{
	return self.frame.size.height;
}


- (void)setHeight:(CGFloat)newHeight
{
	CGRect frameRect = self.frame;
	frameRect.size.height = newHeight;
	self.frame = frameRect;
}


- (CGFloat)centerX
{
	return self.center.x;
}


- (void)setCenterX:(CGFloat)newCenterX
{
	self.center = CGPointMake(newCenterX, self.center.y);
}


- (CGFloat)centerY
{
	return self.center.y;
}


- (void)setCenterY:(CGFloat)newCenterY
{
	self.center = CGPointMake(self.center.x, newCenterY);
}


- (CGPoint)origin
{
	return self.frame.origin;
}


- (void)setOrigin:(CGPoint)newOrigin
{
	CGRect frameRect = self.frame;
	frameRect.origin = newOrigin;
	self.frame = frameRect;
}


- (CGSize)size
{
	return self.frame.size;
}


- (void)setSize:(CGSize)newSize
{
	CGRect frameRect = self.frame;
	frameRect.size = newSize;
	self.frame = frameRect;
}

- (void)setLeft:(CGFloat)left right:(CGFloat)right
{
	CGRect frameRect = self.frame;
	frameRect.origin.x = left;
	frameRect.size.width = right - left;
	self.frame = frameRect;
}

- (void)setTop:(CGFloat)top bottom:(CGFloat)bottom
{
	CGRect frameRect = self.frame;
	frameRect.origin.y = top;
	frameRect.size.height = bottom - top;
	self.frame = frameRect;
}

- (void)lfx_fadeToAlpha:(CGFloat)alpha duration:(NSTimeInterval)duration
{
	[UIView animateWithDuration:duration animations:^{
		self.alpha = alpha;
	}];
}


@end
