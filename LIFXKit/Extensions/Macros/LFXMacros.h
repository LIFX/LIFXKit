//
//  LFXMacros.h
//  LIFX
//
//  Created by Nick Forge on 9/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"


// Logging


// (from DDLog.h)
//	#define LOG_FLAG_ERROR    (1 << 0)  // 0...00001
//	#define LOG_FLAG_WARN     (1 << 1)  // 0...00010
//	#define LOG_FLAG_INFO     (1 << 2)  // 0...00100
//	#define LOG_FLAG_DEBUG    (1 << 3)  // 0...01000
//	#define LOG_FLAG_VERBOSE  (1 << 4)  // 0...10000



#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_INFO;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


#define LFXLogVerbose(...)	DDLogVerbose(__VA_ARGS__)
#define LFXLogInfo(...)	DDLogInfo(__VA_ARGS__)
#define LFXLogWarn(...)	DDLogWarn(__VA_ARGS__)
#define LFXLogError(...)	DDLogError(__VA_ARGS__)

#define LFXLogImplementMethod() DDLogError(@"Implement me: %s", __PRETTY_FUNCTION__)


// KVC Compile-time Helpers

#define Key(class, key)				(0 ? ((class *)nil).key, (NSString *)nil : @#key)
#define InstanceKey(instance, key)	(0 ? ((__typeof(instance))nil).key, (NSString *)nil : @#key)
#define SelfKey(key)				(0 ? ((__typeof(self))nil).key, (NSString *)nil : @#key)
#define ProtocolKey(protocol, key)	(0 ? ((id <protocol>)nil).key, (NSString *)nil : @#key)


// ARC Helpers

#define MakeWeakRef(oldStrongVar, newWeakVar)	__weak __typeof(oldStrongVar) newWeakVar = oldStrongVar
#define MakeBlockRef(oldVar, newBlockVar)		__block __typeof(oldVar) newBlockVar = oldVar
#define MakeStrongRef(oldRef, newStrongRef)	__strong __typeof(oldRef) newStrongRef = oldRef


// Type Casting

#define CastObject(newClass, object)	([object isKindOfClass:[newClass class]] ? (newClass *) object : (newClass *) nil)



#define CLAMP(x, min, max)  (((x) > (max)) ? (max) : (((x) < (min)) ? (min) : (x)))



