//
//  LFXMessageObservationDescriptor.h
//  LIFX
//
//  Created by Nick Forge on 18/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LFXMessage;

typedef void (^LFXMessageObserverCallback)(LFXMessage *message);


@interface LFXMessageObservationDescriptor : NSObject

// All Observation Descriptors have a callback
@property (nonatomic, copy) LFXMessageObserverCallback callback;

// Observers that were created with an 'observer object' will have this property set
@property (nonatomic, weak) id observingObject;

// An unsafe_unretained reference to .observingObject is stored, and this method can
// be used to compare the two. This is encapsulated to limit the potential scope of
// dead reference bugs.
- (BOOL)observingObjectWasEqualTo:(id)object;

@end
