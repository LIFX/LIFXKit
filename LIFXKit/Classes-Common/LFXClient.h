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

@property (nonatomic, readonly) NSArray /* LFXNetworkContext */ *networkContexts;

@property (nonatomic, readonly) LFXNetworkContext *localNetworkContext;


// Observers
- (void)addClientObserver:(id <LFXClientObserver>)observer;
- (void)removeClientObserver:(id <LFXClientObserver>)observer;

@end



@protocol LFXClientObserver <NSObject>

@optional

- (void)client:(LFXClient *)client didAddNetworkContext:(LFXNetworkContext *)networkContext;
- (void)client:(LFXClient *)client didRemoveNetworkContext:(LFXNetworkContext *)networkContext;

// Deprecated
- (void)client:(LFXClient *)client networkContextDidConnect:(LFXNetworkContext *)networkContext DEPRECATED_MSG_ATTRIBUTE("use -[LFXNetworkContextObserver networkContext:didChangeConnectionState: instead");
- (void)client:(LFXClient *)client networkContextDidDisconnect:(LFXNetworkContext *)networkContext DEPRECATED_MSG_ATTRIBUTE("use -[LFXNetworkContextObserver networkContext:didChangeConnectionState: instead");

@end