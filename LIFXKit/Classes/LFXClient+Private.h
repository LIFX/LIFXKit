//
//  LFXClient+Private.h
//  LIFXKit
//
//  Created by Nick Forge on 20/03/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXClient.h"


@interface LFXClient (Private)

- (void)lfx_networkContextDidConnect:(LFXNetworkContext *)networkContext;
- (void)lfx_networkContextDidDisconnect:(LFXNetworkContext *)networkContext;

@end