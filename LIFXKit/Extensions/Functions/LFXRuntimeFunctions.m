//
//  LFXRuntimeFunctions.m
//  LIFX
//
//  Created by Nick Forge on 10/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXRuntimeFunctions.h"
#import <objc/runtime.h>

NSArray *lfx_ClassGetSubclasses(Class parentClass)
{
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
	
    classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
	
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
		
        if (superClass == nil)
        {
            continue;
        }
		
        [result addObject:classes[i]];
    }
	
    free(classes);
	
    return result;
}
