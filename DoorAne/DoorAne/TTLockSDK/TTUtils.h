//
// 
//  BTstackCocoa
//
//  Created by wan on 13-1-31.
//
//

#import <Foundation/Foundation.h>
#import "TTLock.h"

@interface TTUtils : NSObject

#define DEBUG_UTILS YES


#define DateFormateStringDefault @"yyyy-MM-dd HH:mm:ss"

#define RSSI_SETTING_1m -85    //对应开锁距离1m
#define RSSI_SETTING_2m -150    //对应开锁距离2m
#define RSSI_SETTING_3m -180    //对应开锁距离3m
#define RSSI_SETTING_4m -210    //对应开锁距离4m
#define RSSI_SETTING_5m -240    //对应开锁距离5m

#define DISTANCE_DEFAULT_FOR_SAVE 2.5f               // 默认保存的开锁距离

#define RSSI_SETTING_MAX -65    //对应最近距离0.5m
#define RSSI_SETTING_MIN -140

//#define RSSI_SETTING_CLOSE -60
#define RSSI_SETTING_MIDDLE_0 -85
#define RSSI_SETTING_MIDDLE_1 -100
//#define RSSI_SETTING_FAR -120

+(int)intFromHexBytes:(Byte*)bytes length:(int)dataLen;

+(NSData*)DataFromHexStr:(NSString *)hexString;

+(BOOL)isString:(NSString*)source contain:(NSString*)subStr;

+(NSString*)formateDate:(NSDate*)date format:(NSString*)format;

+(NSTimeInterval)formateDateFromString:(NSString*)dateStr format:(NSString*)format;

+(NSDate*)formateDateFromStringToDate:(NSString*)dateStr format:(NSString*)format;

+(long) getLongForBytes:(Byte*)packet;

+(void) printByteByByte:(Byte *)packet withLength:(int)length;

+(Byte)generateRandomByte;//随机数

+(void) arrayCopyWithSrc:(Byte*)src srcPos:(int)srcPos dst:(Byte*)dst dstPos:(NSUInteger)dstPos length:(NSUInteger)length;

+(void)getMacBytes:(NSString*)macStr withByte:(Byte*)macBytes;

+(void) generateDynamicPassword:(Byte*)bytes length:(int) length;

+(NSString *) generateDynamicPassword:(int) length;

+(NSData *)EncodeScienerPSBytes:(Byte *)sourceBytes length:(int)length;

+(NSData *)EncodeScienerPS:(NSString *)password;
+(NSData *)DecodeScienerPSToData:(NSData *)data;
+(NSString *)DecodeScienerPS:(NSData *)data;

+(int)RandomNumber0To9_length:(int)length;

+(int)RandomInt0To9;

+(NSString *) md5: (NSString *) inPutText;
+(NSString*)EncodeSharedKeyValue:(NSString*)edate;
+(NSString*)DecodeSharedKeyValue:(NSString*)edateStr;

@end
