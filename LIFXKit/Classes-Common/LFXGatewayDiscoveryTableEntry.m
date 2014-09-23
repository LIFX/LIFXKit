//
//  LFXGatewayDiscoveryTableEntry.m
//  LIFX
//
//  Created by Nick Forge on 13/10/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXGatewayDiscoveryTableEntry.h"
#import "LFXExtensions.h"

@implementation LFXGatewayDiscoveryTableEntry

- (NSString *)description
{
	return [self lfx_descriptionWithPropertyKeys:@[SelfKey(gatewayDescriptor), SelfKey(lastDiscoveryResponseDate)]];
}

@end
