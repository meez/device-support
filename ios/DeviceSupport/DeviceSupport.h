//
//  DeviceSupport.h
//  DeviceSupport
//
//  Created by Peter McDonnell on 01/09/2016.
//  Copyright © 2016 Donnerwood Media. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#endif

#define ANE_EXPORT extern __attribute__((visibility("default")))

@interface DeviceSupport : NSObject

@end

// C interface

/* DeviceSupport Interface */

DEFINE_ANE_FUNCTION(dsGetStatusBarHeight);
DEFINE_ANE_FUNCTION(dsGetAPILevel);
DEFINE_ANE_FUNCTION(dsRefreshView);
DEFINE_ANE_FUNCTION(dsGetDeviceId);

// ANE setup

/* Extension Initialization */
ANE_EXPORT void DeviceSupportExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);

/* Extension Finalization */
ANE_EXPORT void DeviceSupportExtFinalizer(void* extData);
