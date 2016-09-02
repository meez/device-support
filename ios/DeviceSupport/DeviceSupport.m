//
//  DeviceSupport.m
//  DeviceSupport
//
//  Created by Peter McDonnell on 01/09/2016.
//  Copyright © 2016 Donnerwood Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceSupport.h"

@implementation DeviceSupport

@end

// C interface

static NSString *freToNSString(FREObject freVal, NSString *defaultValue);
static FREObject nsToFreString(NSString *value);
static FREObject cgToFreNumber(CGFloat value);

// Setup

/* Context Initialization */
static void exContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);

/** Context Finalization */
static void exContextFinalizer(FREContext ctx);

/* DeviceSupport Implementation */

DEFINE_ANE_FUNCTION(dsGetStatusBarHeight)
{
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    CGFloat barHeight = MIN(statusBarSize.width, statusBarSize.height);
    CGFloat barHeightPixels = barHeight*[[UIScreen mainScreen] scale];

    NSLog(@"[DeviceSupport] getStatusBarHeight()=%fdp / %fpx",barHeight,barHeightPixels);

    return cgToFreNumber(barHeightPixels);
}

DEFINE_ANE_FUNCTION(dsGetAPILevel)
{
    return cgToFreNumber(0.0f);
}

DEFINE_ANE_FUNCTION(dsRefreshView)
{
    NSLog(@"[DeviceSupport] refreshView() does nothing");

    return NULL;
}

DEFINE_ANE_FUNCTION(dsGetDeviceId)
{
    NSString *id=NULL;

    // Try for IDFV
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {

        NSLog(@"[DeviceSupport] IDFV supported");

        id=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    else
    {
        NSLog(@"[DeviceSupport] IDFV not available");
    }

    return nsToFreString(id);
}

// ANE setup

/* Extension Initialization */
void DeviceSupportExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    NSLog(@"DeviceSupport ANE Initializing");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &exContextInitializer;
    *ctxFinalizerToSet = &exContextFinalizer;
}

/* Extension Finalization */
void DeviceSupportExtFinalizer(void* extData)
{
    NSLog(@"DeviceSupport ANE Finalizing");
}

/* Context Initialization */
void exContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"DeviceSupport ANE Context Initializing");

    // Allocate array to hold function definitions
    *numFunctionsToTest = 4;
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));

    func[0].name = (const uint8_t*) "getStatusBarHeight";
    func[0].functionData = NULL;
    func[0].function = &dsGetStatusBarHeight;
    func[1].name = (const uint8_t*) "getAPILevel";
    func[1].functionData = NULL;
    func[1].function = &dsGetAPILevel;
    func[2].name = (const uint8_t*) "refreshView";
    func[2].functionData = NULL;
    func[2].function = &dsRefreshView;
    func[3].name = (const uint8_t*) "getDeviceId";
    func[3].functionData = NULL;
    func[3].function = &dsGetDeviceId;

    *functionsToSet = func;
}

/** Context Finalization */
void exContextFinalizer(FREContext ctx)
{
    NSLog(@"DeviceSupport ANE Context Finalizing");
}

// Type wrangling

/** Convert FREObject string to NSString or provide default */
NSString *freToNSString(FREObject freVal, NSString *defaultValue)
{
    uint32_t nValue;
    const uint8_t *sValue;

    if (FREGetObjectAsUTF8(freVal, &nValue, &sValue) == FRE_OK)
    {
        return [NSString stringWithUTF8String:(char*)sValue];
    }
    else
    {
        return defaultValue;
    }
}

/** Convert NSString to FREObject */
FREObject nsToFreString(NSString *value)
{
    FREObject fr=NULL;
    FREResult rc=FRENewObjectFromUTF8((uint32_t)strlen([value UTF8String]),(const uint8_t *)[value UTF8String],&fr);
    if (rc != FRE_OK)
    {
        NSLog(@"[DeviceSupport] Cannot allocate FREString [rc=%d]", rc);
        return NULL;
    }

    return fr;
}

/** Convert CGFloat to FREObject */
FREObject cgToFreNumber(CGFloat value)
{
    FREObject fr=nil;
    FREResult rc=FRENewObjectFromDouble(value, &fr);
    if(rc != FRE_OK)
    {
        NSLog(@"[DeviceSupoort] Cannot allocate FRENumber [rc=%d]",rc);
        return NULL;
    }

    return fr;
}
