//
//  LFXLocalNetworkContext.m
//  LIFXKit
//
//  Created by Nick Forge on 17/07/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXLocalNetworkContext.h"
#import "LFXNetworkContext+Private.h"
#import "LFXLocalTransportManager.h"

@interface LFXLocalNetworkContext ()

@end

@implementation LFXLocalNetworkContext

+ (Class)transportManagerClass
{
	return [LFXLocalTransportManager class];
}

- (NSString *)networkContextType
{
	return LFXNetworkContextTypeLocal;
}

- (NSString *)name
{
	return @"Local";
}

@end
