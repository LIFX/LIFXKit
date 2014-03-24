//
//  UIApplication+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 4/11/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "UIApplication+LFXExtensions.h"

@implementation UIApplication (LFXExtensions)

- (NSString *)lfx_documentsFolderPath
{
	static NSString *path = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	});
	return path;
}

- (NSString *)lfx_tempFolderPath
{
	static NSString *path;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		path = NSTemporaryDirectory();
	});
	return path;
}

@end
