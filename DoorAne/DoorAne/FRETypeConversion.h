//
//  FRETypeConversion.h
//  GameCenterIosExtension
//
//  Created by Richard Lord on 25/01/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#ifndef GameCenterIosExtension_FRETypeConversion_h
#define GameCenterIosExtension_FRETypeConversion_h

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

FREResult GC_FREGetObjectAsString( FREObject object, NSString** value );

FREResult GC_FRENewObjectFromString( NSString* string, FREObject* asString );
FREResult GC_FRENewObjectFromDate( NSDate* date, FREObject* asDate );

FREResult GC_FRESetObjectPropertyString( FREObject asObject, const uint8_t* propertyName, NSString* value );
FREResult GC_FRESetObjectPropertyBool( FREObject asObject, const uint8_t* propertyName, uint32_t value );
FREResult GC_FRESetObjectPropertyInt( FREObject asObject, const uint8_t* propertyName, int32_t value );
FREResult GC_FRESetObjectPropertyNum( FREObject asObject, const uint8_t* propertyName, double value );
FREResult GC_FRESetObjectPropertyDate( FREObject asObject, const uint8_t* propertyName, NSDate* value );

#endif
