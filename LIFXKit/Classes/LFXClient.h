//
//  LFXClient.h
//  LIFX
//
//  Created by Nick Forge on 12/12/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXNetworkContext;
@protocol LFXClientObserver;


@interface LFXClient : NSObject

// Designated Factory Method

+ (LFXClient *)sharedClient;


@property (nonatomic, readonly) LFXNetworkContext *localNetworkContext;


// Observers
- (void)addClientObserver:(id <LFXClientObserver>)observer;
- (void)removeClientObserver:(id <LFXClientObserver>)observer;

@end



@protocol LFXClientObserver <NSObject>

@optional
- (void)client:(LFXClient *)client networkContextDidConnect:(LFXNetworkContext *)networkContext;
- (void)client:(LFXClient *)client networkContextDidDisconnect:(LFXNetworkContext *)networkContext;

@end