//
//  LFXMacros.h
//  LIFX
//
//  Created by Nick Forge on 9/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


// Logging

extern int LFXLogLevel;

#define LFXLogLevelVerbose	4
#define LFXLogLevelInfo		3
#define LFXLogLevelWarn		2
#define LFXLogLevelError	1
#define LFXLogLevelNone		0


#define LFXLogVerbose(...)	LFXLog(LFXLogLevelVerbose, __VA_ARGS__)
#define LFXLogInfo(...)		LFXLog(LFXLogLevelInfo, __VA_ARGS__)
#define LFXLogWarn(...)		LFXLog(LFXLogLevelWarn, __VA_ARGS__)
#define LFXLogError(...)	LFXLog(LFXLogLevelError, __VA_ARGS__)


#define LFXLog(level, ...)	do { if (level <= LFXLogLevel) NSLog(__VA_ARGS__); } while (0)


// This can be put into methods that should be overriden (without calling super) to throw
// a warning at runtime
#define LFXLogImplementMethod() LFXLogError(@"Implement me: %s", __PRETTY_FUNCTION__)


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



