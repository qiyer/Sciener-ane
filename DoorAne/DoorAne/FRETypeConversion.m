//
//  FRETypeConversion.c
//  GameCenterIosExtension
//
//  Created by Richard Lord on 25/01/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import "FRETypeConversion.h"

FREResult GC_FREGetObjectAsString( FREObject object, NSString** value )
{
    FREResult result;
    uint32_t length = 0;
    const uint8_t* tempValue = NULL;
    
    result = FREGetObjectAsUTF8( object, &length, &tempValue );
    if( result != FRE_OK ) return result;
    
    *value = [NSString stringWithUTF8String: (char*) tempValue];
    return FRE_OK;
}

FREResult GC_FRENewObjectFromString( NSString* string, FREObject* asString )
{
    const char* utf8String = string.UTF8String;
    unsigned long length = strlen( utf8String );
    return FRENewObjectFromUTF8( length + 1, (uint8_t*) utf8String, asString );
}

FREResult GC_FRENewObjectFromDate( NSDate* date, FREObject* asDate )
{
    NSTimeInterval timestamp = date.timeIntervalSince1970 * 1000;
    FREResult result;
    FREObject time;
    result = FRENewObjectFromDouble( timestamp, &time );
    if( result != FRE_OK ) return result;
    result = FRENewObject( "Date", 0, NULL, asDate, NULL );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( *asDate, "time", time, NULL);
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

FREResult GC_FRESetObjectPropertyString( FREObject asObject, const uint8_t* propertyName, NSString* value )
{
    FREResult result;
    FREObject asValue;
    result = GC_FRENewObjectFromString( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

FREResult GC_FRESetObjectPropertyBool( FREObject asObject, const uint8_t* propertyName, uint32_t value )
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromBool( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

FREResult GC_FRESetObjectPropertyInt( FREObject asObject, const uint8_t* propertyName, int32_t value )
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromInt32( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

FREResult GC_FRESetObjectPropertyNum( FREObject asObject, const uint8_t* propertyName, double value )
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromDouble( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

FREResult GC_FRESetObjectPropertyDate( FREObject asObject, const uint8_t* propertyName, NSDate* value )
{
    FREResult result;
    FREObject asValue;
    result = GC_FRENewObjectFromDate( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}