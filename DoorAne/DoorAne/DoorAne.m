//
//  DoorAne.m
//  DoorAne
//
//  Created by qiye on 16/10/11.
//  Copyright © 2016年 door. All rights reserved.
//

#import "DoorAne.h"
#import "TTUtils.h"
#import "FRETypeConversion.h"
#import <objc/runtime.h>
#import <objc/message.h>

FREContext myCtx = nil;

static DoorAne *sharedInstance = nil;

@implementation DoorAne

+ (DoorAne *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

-(NSDate*)formateDateFromStringToDate:(NSString*)dateStr format:(NSString*)format
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    
    NSDate *date=[formatter dateFromString:dateStr];
    
    
    return date;
    
    
}

- (id)copy
{
    return self;
}

-(void)initDoor:(NSString* )openID aesKey:(NSString*) aeskey lockKey:(NSString*) lockkey version:(NSString*) version
startDate:(NSString*) startDate endDate:(NSString*) endDate logPos:(int32_t) logPos
{
    self.openType = @"0";
    self.isAutoOpen = YES;
    self.uuid = openID;
    self.aesKey = aeskey;
    self.lockkey = lockkey;
    self.version = version;
    
    self.startDate = startDate;
    self.endDate = endDate;
    self.invalidFlag = logPos;
    
    if(_TTObject==nil){
        _TTObject = [[TTLock alloc]initWithDelegate:self];
        self.TTObject.uid = self.uuid;
        [_TTObject setupBlueTooth];
    }
    [DoorAne dispatchEvent:@"sdk初始化" withMessage:@"初始化成功"];
}

-(void)initRefreshDoor:(NSString* )openID aesKey:(NSString*) aeskey lockKey:(NSString*) lockkey version:(NSString*) version
      startDate:(NSString*) startDate endDate:(NSString*) endDate logPos:(int32_t) logPos fDate:(NSString*) fDate
{
    self.openType = @"1";
    self.isAutoOpen = YES;
    self.uuid = openID;
    self.aesKey = aeskey;
    self.lockkey = lockkey;
    self.version = version;
    
    self.startDate = startDate;
    self.endDate = endDate;
    self.invalidFlag = logPos;
    self.refreshDate = fDate;
    
    if(_TTObject==nil){
        _TTObject = [[TTLock alloc]initWithDelegate:self];
        self.TTObject.uid = self.uuid;
        [_TTObject setupBlueTooth];
    }
    [DoorAne dispatchEvent:@"sdk初始化" withMessage:@"初始化成功"];
}

-(void)initAdmins:(NSString* )openID admin:(NSString*)admin aesKey:(NSString*) aeskey lockKey:(NSString*) lockkey version:(NSString*) version logPos:(int32_t) logPos
{
    self.openType = @"2";
    self.isAutoOpen = YES;
    self.uuid = openID;
    self.aesKey = aeskey;
    self.lockkey = lockkey;
    self.version = version;
    

    self.invalidFlag = logPos;
    self.adminPwd = admin;
    
    if(_TTObject==nil){
        _TTObject = [[TTLock alloc]initWithDelegate:self];
        self.TTObject.uid = self.uuid;
        [_TTObject setupBlueTooth];
    }
    [DoorAne dispatchEvent:@"sdk初始化" withMessage:@"初始化成功"];
}

-(void)initData:(NSString* )openID aesKey:(NSString*) aeskey lockKey:(NSString*) lockkey version:(NSString*) version
      startDate:(NSString*) startDate endDate:(NSString*) endDate logPos:(int32_t) logPos
{
    self.openType = @"0";
    self.isAutoOpen = NO;
    self.uuid = openID;
    self.aesKey = aeskey;
    self.lockkey = lockkey;
    self.version = version;
    
    self.startDate = startDate;
    self.endDate = endDate;
    self.invalidFlag = logPos;
    
    if(_TTObject==nil){
        _TTObject = [[TTLock alloc]initWithDelegate:self];
        self.TTObject.uid = self.uuid;
        [_TTObject setupBlueTooth];
    }
    [DoorAne dispatchEvent:@"sdk初始化" withMessage:@"初始化成功"];
}

-(void)connect{
    [_TTObject startBTDeviceScan];
}

-(void)disconnect{
    if(self.peripheral){
        [_TTObject disconnect:self.peripheral];
    }
    [_TTObject stopBTDeviceScan];
}

-(void)openDoor{
    self.TTObject.uid = self.uuid;
    self.TTObject.uniqueid = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    [DoorAne dispatchEvent:@"onBTConnectSuccess_peripheral" withMessage:@"蓝牙对接成功－>普通用户开门"];
    NSDate * startDate = [self formateDateFromStringToDate:@"200001010000" format:@"yyyyMMddHHmm"];
    NSDate * endDate = [self formateDateFromStringToDate:@"209912312359" format:@"yyyyMMddHHmm"];
    if(![self.startDate isEqualToString:@"0"]){
        startDate = [NSDate dateWithTimeIntervalSince1970:self.startDate.integerValue];
    }
    if(![self.endDate isEqualToString:@"0"]){
        endDate = [NSDate dateWithTimeIntervalSince1970:self.endDate.integerValue];
    }
    //普通用户开门
    [self.TTObject unlockByUser_lockKey:self.lockkey aesKey:self.aesKey startDate:startDate endDate:endDate version:self.version unlockFlag:self.invalidFlag];
}

-(void)openDateDoor{
    self.TTObject.uid = self.uuid;
    self.TTObject.uniqueid = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    [DoorAne dispatchEvent:@"onBTConnectSuccess_peripheral" withMessage:@"蓝牙对接成功－>普通用户开门"];
    NSDate * startDate = [self formateDateFromStringToDate:@"200001010000" format:@"yyyyMMddHHmm"];
    NSDate * endDate = [self formateDateFromStringToDate:@"209912312359" format:@"yyyyMMddHHmm"];
    if(![self.startDate isEqualToString:@"0"]){
        startDate = [NSDate dateWithTimeIntervalSince1970:self.startDate.integerValue];
    }
    if(![self.endDate isEqualToString:@"0"]){
        endDate = [NSDate dateWithTimeIntervalSince1970:self.endDate.integerValue];
    }
    NSDate * fDate = [self formateDateFromStringToDate:self.refreshDate format:@"yyyyMMddHHmm"];
    //普通用户开门
    [self.TTObject calibationTimeAndUnlock_lockKey:self.lockkey aesKey:self.aesKey startDate:startDate endDate:endDate version:self.version unlockFlag:self.invalidFlag referenceTime:fDate];
}

-(void)openAdminDoor{
    self.TTObject.uid = self.uuid;
    self.TTObject.uniqueid = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    [DoorAne dispatchEvent:@"onBTConnectSuccess_peripheral" withMessage:@"蓝牙对接成功－>普通用户开门"];
    //管理员开门
    [self.TTObject unlockByAdministrator_adminPS:self.adminPwd lockKey:self.lockkey aesKey:self.aesKey version:self.version unlockFlag:self.invalidFlag];
}

-(void)TTError:(TTError)error command:(int)command errorMsg:(NSString *)errorMsg{
    [DoorAne dispatchEvent:@"TTError#" withMessage:[NSString stringWithFormat:@"ERROR:%ld COMAND %d errorMsg%@",(long)error,command,errorMsg]];
    NSLog(@"%@",[NSString stringWithFormat:@"ERROR:%ld COMAND %d errorMsg%@",(long)error,command,errorMsg]);
}

//蓝牙搜索，连接相关回调
-(void)onFoundDevice_peripheral:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary *)advertisementData isContainAdmin:(BOOL)isContainAdmin protocolCategory:(int)protocolCategory{
    //查找本地有没有这把锁的钥匙 如果有就进行连接
    if ( rssi.intValue >= RSSI_SETTING_1m &&rssi.intValue != 127) {
        [DoorAne dispatchEvent:@"onFoundDevice_peripheral" withMessage:[NSString stringWithFormat:@"搜索到进行连接时的RSSI %@",rssi]];
        NSLog(@"搜索到进行连接时的RSSI %@",rssi);
        self.peripheral = peripheral;
        [_TTObject connect:peripheral];
    }
}

-(void)onBTDisconnect_peripheral:(CBPeripheral *)periphera
{
    NSLog(@"断开蓝牙 disconnect");
    [DoorAne dispatchEvent:@"onBTDisconnect_peripheral" withMessage:@"断开蓝牙 disconnect"];
}

-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName{
    
    self.TTObject.uid = self.uuid;
    self.TTObject.uniqueid = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    [DoorAne dispatchEvent:@"onBTConnectSuccess_peripheral" withMessage:@"蓝牙对接成功－>普通用户开门"];
    NSDate * startDate = [self formateDateFromStringToDate:@"200001010000" format:@"yyyyMMddHHmm"];
    NSDate * endDate = [self formateDateFromStringToDate:@"209912312359" format:@"yyyyMMddHHmm"];
    if(![self.startDate isEqualToString:@"0"]){
        startDate = [NSDate dateWithTimeIntervalSince1970:self.startDate.integerValue];
    }
    if(![self.endDate isEqualToString:@"0"]){
        endDate = [NSDate dateWithTimeIntervalSince1970:self.endDate.integerValue];
    }
    if(self.isAutoOpen ){
        [DoorAne dispatchEvent:@"onBTConnectSuccess_peripheral" withMessage:@"申请开门"];
        if([self.openType isEqualToString:@"0"]){
            //普通用户开门
            [self.TTObject unlockByUser_lockKey:self.lockkey aesKey:self.aesKey startDate:startDate endDate:endDate version:self.version unlockFlag:self.invalidFlag];
        }else if([self.openType isEqualToString:@"1"]){
            [self openDateDoor];
        }else{
            [self openAdminDoor];
        }

    }
}

//开锁成功
-(void)onUnlockWithLockTime:(NSTimeInterval)lockTime{
    
    [DoorAne dispatchEvent:@"onUnlockWithLockTime" withMessage:@"开锁成功!"];
    [self performSelector:@selector(disconnect) withObject:nil afterDelay:1.0];
}

+ (void)dispatchEvent:(NSString *)event withMessage:(NSString *)message
{
    
    NSString *eventName = event ? event : @"LOGGING";
    NSString *messageText = message ? message : @"";
    FREDispatchStatusEventAsync(myCtx, (const uint8_t *)[eventName UTF8String], (const uint8_t *)[messageText UTF8String]);
    
}

@end



//ane 初始化，as那边调用
FREObject ANEinit(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]){
    
    NSString * code = @"ane_deal";
    NSString * level = @"sucess";
    
    
    NSString*  uuid;
    NSString* lockkey;
    NSString* aesKey;
    NSString* version;
    
    NSString* startDate;
    NSString* endDate;
    int32_t logPos;
    
    
    GC_FREGetObjectAsString(argv[0], &uuid);
    GC_FREGetObjectAsString(argv[1], &lockkey);
    GC_FREGetObjectAsString(argv[2], &aesKey);
    GC_FREGetObjectAsString(argv[3], &version);
    GC_FREGetObjectAsString(argv[4], &startDate);
    GC_FREGetObjectAsString(argv[5], &endDate);
    FREGetObjectAsInt32(argv[6], &logPos);
    
    NSString * aaa= [NSString stringWithFormat:@"%@  %@  %@  %@",uuid,lockkey,aesKey,version];
    level = aaa;
    FREDispatchStatusEventAsync(ctx, (const uint8_t *)[code UTF8String],(const uint8_t *) [level UTF8String]);
    
    [[DoorAne sharedInstance] initDoor:uuid aesKey:aesKey lockKey:lockkey version:version startDate:startDate endDate:endDate logPos:logPos];

    return nil;
    
}

FREObject ANEinitData(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]){
    
    NSString * code = @"ane_deal";
    NSString * level = @"sucess";
    
    
    NSString*  uuid;
    NSString* lockkey;
    NSString* aesKey;
    NSString* version;
    
    NSString* startDate;
    NSString* endDate;
    int32_t logPos;
    
    
    GC_FREGetObjectAsString(argv[0], &uuid);
    GC_FREGetObjectAsString(argv[1], &lockkey);
    GC_FREGetObjectAsString(argv[2], &aesKey);
    GC_FREGetObjectAsString(argv[3], &version);
    GC_FREGetObjectAsString(argv[4], &startDate);
    GC_FREGetObjectAsString(argv[5], &endDate);
    FREGetObjectAsInt32(argv[6], &logPos);
    
    NSString * aaa= [NSString stringWithFormat:@"%@  %@  %@  %@",uuid,lockkey,aesKey,version];
    level = aaa;
    FREDispatchStatusEventAsync(ctx, (const uint8_t *)[code UTF8String],(const uint8_t *) [level UTF8String]);
    
    [[DoorAne sharedInstance] initData:uuid aesKey:aesKey lockKey:lockkey version:version startDate:startDate endDate:endDate logPos:logPos];
    
    return nil;
    
}

FREObject ANEopenRefresh(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]){
    
    NSString * code = @"ane_deal";
    NSString * level = @"sucess";
    
    
    NSString*  uuid;
    NSString* lockkey;
    NSString* aesKey;
    NSString* version;
    
    NSString* startDate;
    NSString* endDate;
    int32_t logPos;
    NSString* refDate;
    
    GC_FREGetObjectAsString(argv[0], &uuid);
    GC_FREGetObjectAsString(argv[1], &lockkey);
    GC_FREGetObjectAsString(argv[2], &aesKey);
    GC_FREGetObjectAsString(argv[3], &version);
    GC_FREGetObjectAsString(argv[4], &startDate);
    GC_FREGetObjectAsString(argv[5], &endDate);
    FREGetObjectAsInt32(argv[6], &logPos);
    GC_FREGetObjectAsString(argv[7], &refDate);
    
    NSString * aaa= [NSString stringWithFormat:@"%@  %@  %@  %@",uuid,lockkey,aesKey,version];
    level = aaa;
    FREDispatchStatusEventAsync(ctx, (const uint8_t *)[code UTF8String],(const uint8_t *) [level UTF8String]);
    
    [[DoorAne sharedInstance] initRefreshDoor:uuid aesKey:aesKey lockKey:lockkey version:version startDate:startDate endDate:endDate logPos:logPos fDate:refDate];
    
    return nil;
    
}

FREObject ANEopenAdmin(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]){
    
    NSString * code = @"ane_deal";
    NSString * level = @"sucess";
    
    
    NSString*  uuid;
    NSString*  admin;
    NSString* lockkey;
    NSString* aesKey;
    NSString* version;
    

    int32_t logPos;

    
    GC_FREGetObjectAsString(argv[0], &uuid);
    GC_FREGetObjectAsString(argv[1], &admin);
    GC_FREGetObjectAsString(argv[2], &lockkey);
    GC_FREGetObjectAsString(argv[3], &aesKey);
    GC_FREGetObjectAsString(argv[4], &version);
    FREGetObjectAsInt32(argv[5], &logPos);
    
    NSString * aaa= [NSString stringWithFormat:@"%@  %@  %@  %@",uuid,lockkey,aesKey,version];
    level = aaa;
    FREDispatchStatusEventAsync(ctx, (const uint8_t *)[code UTF8String],(const uint8_t *) [level UTF8String]);
    
    [[DoorAne sharedInstance] initAdmins:uuid admin:admin aesKey:aesKey lockKey:lockkey version:version logPos:logPos];
    
    return nil;
    
}

FREObject ANEconnect(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]){
    [[DoorAne sharedInstance] connect];
    
    return nil;
}

FREObject ANEdisconnect(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]){
    [[DoorAne sharedInstance] disconnect];
    
    return nil;
}

FREObject ANEopendoor(FREContext ctx,void* funcData ,uint32_t argc, FREObject argv[]){
    [[DoorAne sharedInstance] openDoor];
    
    return nil;
}

void PushContextInitializer(void* extData,const uint8_t* ctxType,FREContext ctx,uint32_t* numFunctions,const FRENamedFunction** functions)
{
    
    myCtx = ctx;
    
    *numFunctions = 7;
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction)*7);
    
    func[0].name = (const uint8_t*) "ane_deal";
    func[0].functionData = NULL;
    func[0].function = &ANEinit;
    
    func[1].name = (const uint8_t*) "ane_init";
    func[1].functionData = NULL;
    func[1].function = &ANEinitData;
    
    func[2].name = (const uint8_t*) "ane_connect";
    func[2].functionData = NULL;
    func[2].function = &ANEconnect;
    
    func[3].name = (const uint8_t*) "ane_disconnect";
    func[3].functionData = NULL;
    func[3].function = &ANEdisconnect;
    
    func[4].name = (const uint8_t*) "ane_open";
    func[4].functionData = NULL;
    func[4].function = &ANEopendoor;
    
    func[5].name = (const uint8_t*) "ane_open_time";
    func[5].functionData = NULL;
    func[5].function = &ANEopenRefresh;
    
    func[6].name = (const uint8_t*) "ane_open_admin";
    func[6].functionData = NULL;
    func[6].function = &ANEopenAdmin;
    
    *functions = func;
}

void PushContextFinalizer(FREContext ctx)
{
    return;
}

void PushExtFinalizer(void* extData)
{
    return;
}

void PushExtInitializer(void** extDataToSet,FREContextInitializer* ctxInitializerToSet,FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &PushContextInitializer;
    *ctxFinalizerToSet = &PushContextFinalizer;
    
}
