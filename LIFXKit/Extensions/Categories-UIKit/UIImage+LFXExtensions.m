//
//  UIImage+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 26/10/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "UIImage+LFXExtensions.h"

@implementation UIImage (LFXExtensions)

+ (UIImage *)lfx_imageWithSolidColor:(UIColor *)color size:(CGSize)size
{
	BOOL colorIsOpaque = NO;// color.alphaComponent == 1.0;
	UIGraphicsBeginImageContextWithOptions(size, colorIsOpaque, 1.0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[color set];
	CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end
