//
//  DoorAne.h
//  DoorAne
//
//  Created by qiye on 16/10/11.
//  Copyright © 2016年 door. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTLock.h"
#import "FlashRuntimeExtensions.h"

@interface DoorAne : NSObject<TTSDKDelegate>

@property (strong, nonatomic) TTLock* TTObject;

@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSString* lockkey;
@property (strong, nonatomic) NSString* aesKey;
@property (nonatomic, strong) NSString * version;
@property (nonatomic, strong) CBPeripheral * peripheral;

@property (strong, nonatomic) NSString* startDate;
@property (strong, nonatomic) NSString* endDate;
@property (strong, nonatomic) NSString* refreshDate;
@property (strong, nonatomic) NSString* adminPwd;
@property (strong, nonatomic) NSString* openType;
@property (nonatomic) int32_t invalidFlag;

@property (nonatomic) BOOL isAutoOpen;

+ (DoorAne *)sharedInstance;

+ (void)dispatchEvent:(NSString *)event withMessage:(NSString *)message;

-(void)initDoor:(NSString* )openID aesKey:(NSString*) aeskey lockKey:(NSString*) lockkey version:(NSString*) version
      startDate:(NSString*) startDate endDate:(NSString*) endDate logPos:(int32_t) logPos;

-(void)initData:(NSString* )openID aesKey:(NSString*) aeskey lockKey:(NSString*) lockkey version:(NSString*) version
      startDate:(NSString*) startDate endDate:(NSString*) endDate logPos:(int32_t) logPos;

-(void)initRefreshDoor:(NSString* )openID aesKey:(NSString*) aeskey lockKey:(NSString*) lockkey version:(NSString*) version
             startDate:(NSString*) startDate endDate:(NSString*) endDate logPos:(int32_t) logPos fDate:(NSString*) fDate;

-(void)initAdmins:(NSString* )openID admin:(NSString*)admin aesKey:(NSString*) aeskey lockKey:(NSString*) lockkey version:(NSString*) version logPos:(int32_t) logPos;

-(void)connect;

-(void)disconnect;

-(void)openDoor;

-(void)openDateDoor;

-(void)openAdminDoor;

@end

FREObject ANEinit(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]);

FREObject ANEinitData(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]);

FREObject ANEconnect(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]);

FREObject ANEdisconnect(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]);

FREObject ANEopendoor(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]);

FREObject ANEopenRefresh(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]);

FREObject ANEopenAdmin(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]);

void PushContextInitializer(void* extData,const uint8_t* ctxType,FREContext ctx,uint32_t* numFunctions,const FRENamedFunction** functions);

void PushContextFinalizer(FREContext ctx);

void PushExtFinalizer(void* extData);

void PushExtInitializer(void** extDataToSet,FREContextInitializer* ctxInitializerToSet,FREContextFinalizer* ctxFinalizerToSet);
