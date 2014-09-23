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
		path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
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

- (NSString *)lfx_cachesFolderPath
{
	static NSString *path = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
	});
	return path;
}

- (NSString *)lfx_applicationSupportFolderPath
{
	static NSString *path = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		path = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
	});
	return path;
}

- (NSString *)lfx_LIFXApplicationSupportFolderPath
{
	return [self.lfx_applicationSupportFolderPath stringByAppendingPathComponent:@"LIFX"];
}

- (NSString *)lfx_bundleShortVersionString
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
