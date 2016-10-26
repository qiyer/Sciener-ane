//
//
//  当前版本：r2.0
//
//  Created by 谢元潮 on 14-4-25.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

#define fileServiceString         @"1910"
#define fileSubWriteString      @"fff2"
#define fileSubReadString      @"fff4"
#define fileService             0x1910
#define fileSubWrite            0xfff2
#define fileSubRead             0xfff4

/**错误码*/

typedef NS_ENUM(NSInteger, TTError)
{
      TTErrorHadReseted = 0,                              //锁可能已被重置
      TTErrorDataCRCError = 0x01,                     //CRC校验出错
      TTErrorNoPermisston = 0x02,                      //身份校验失败，无操作权限(非管理员)
      TTErrorIsWrongPS = 0x03,                        //管理员密码不正确
      TTErrorNoMemory = 0x04,                          //存储空间不足, 超出保存用户的最大数量
      TTErrorInSettingMode = 0x05,                     //处于设置模式(开门必须处于非设置模式)
      TTErrorNoAdmin = 0x06,                          //不存在管理员
      TTErrorIsNotSettingMode = 0x07,                 //处于非设置模式(添加管理员必须处于设置模式)
      TTErrorIsWrongDynamicPS = 0x08,                 //动态密码错误(约定数字于随机数之和错误)
      TTErrorIsNoPower = 0x0a,                        //电池没电, 无法开门
      TTErrorResetKeyboardPs = 0x0b,                  //设置900密码失败
      TTErrorUpdateKeyboardIndex = 0x0c,              //更新键盘密码序列出错
      TTErrorIsInvalidFlag = 0x0d,                    //失效flag
      TTErrorEkeyOutOfDate = 0x0e,                       //ekey过期
      TTErrorEkeyNotToDate = 0x11,                     //未到有效期
      TTErrorAesKey = 0x12,                           //获取锁信息AesKey错误
      TTErrorICFail = 0x13,                           //IC卡操作失败或当前状态不允许添加IC卡
      TTErrorPasswordNotExist = 0x15,					//删除或者修改的密码不存在
      TTErrorNoFree_Memory = 0x16,						//存储空间不足（比如添加密码时，超过存储容量）
      TTErrorInvalidParaLength = 0x17,							//参数长度无效
      TTErrorCardNotExist =	0x18							//IC卡不存在

    
    
};
//键盘密码类型
typedef NS_ENUM(NSInteger, KeyboardPsType)
{
    KeyboardPsTypeNone = -1,            //不确定类型
    KeyboardPsTypeNormalAll_Date = 1,   //永久密码
    KeyboardPsTypeLimitTimes = 2,       //单次密码
    KeyboardPsTypeLimitDate = 3         //时限密码
};

//密码 IC卡等操作类型
typedef NS_ENUM(NSInteger,OprationType)
{
    OprationTypeClear = 1,  //清空
    OprationTypeAdd = 2,     //添加
    OprationTypeDelete = 3,    //删除
    OprationTypeModify = 4,    //修改
    OprationTypeQuery = 5     //查询
    
};

//添加IC卡返回的状态类型
typedef NS_ENUM(NSInteger,AddICState)
{
    AddICStateHadAdd = 1,  //识别到IC卡并成功添加
    AddICStateCanAdd = 2,    //成功启动添加IC卡模式
    
};

//回调 TTSDK代理
@protocol TTSDKDelegate <NSObject>
@required
/**
 * 相关回调 错误码
 */
-(void)TTError:(TTError)error command:(int)command errorMsg:(NSString*)errorMsg;
/**
 *  蓝牙搜索到设备的回调
 *  @return 返回的是 蓝牙广播里的值
 */
-(void)onFoundDevice_peripheral:(CBPeripheral *)peripheral RSSI:(NSNumber*)rssi lockName:(NSString*)lockName mac:(NSString*)mac advertisementData:(NSDictionary *)advertisementData isContainAdmin:(BOOL)isContainAdmin protocolCategory:(int)protocolCategory;

/**
 *  已经连接上蓝牙
 */
-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName;
/**
 *  断开与蓝牙的连接
 */
-(void)onBTDisconnect_peripheral:(CBPeripheral*)periphera;

@optional

/**
 *  获取锁的版本号成功
 */
-(void)onGetProtocolVersion:(NSString*)versionStr;
/**
 *  添加管理员成功
 *  adminPS 管理员密码 管理员开门时校验管理员身份的
 *  lockkey 约定数开门使用
 *  aesKey  开门使用
 *  version 版本号 由（protocolType.protocolVersion.scene.groupId.orgId组成）
 *  mac  mac地址 唯一标识
 *  timestamp 时间戳
 *  pwdInfo  生成的加密密码数据
 *  electricQuantity 如果为-1 则表示没有获取到电量
 *  adminPassword  管理员开门密码 添加指令时传进来的数据
 *  deletePassword  管理员删除密码  添加指令时传进来的数据
 *  characteristic  锁的特征值 三代锁才有:4个字节，每个字节的每一位，代表一个功能 0	支持密码 1支持IC卡 2支持指纹 3支持Bong手环 4~7保留 
                    比如支持密码，则四个字节的特征值为 00 00 00 01，支持密码及IC卡，则为00 00 00 03  没有特征值为-1
 */
-(void)onAddAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)versionStr mac:(NSString*)mac timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo electricQuantity:(int)electricQuantity adminPassword:(NSString*)adminPassward deletePassword:(NSString*)deletePassward Characteristic:(int)characteristic ;

-(void)onAddAdministrator_password:(NSString*)password key:(NSString*)key aesKey:(NSString*)aesKeyData version:(NSString*)versionStr mac:(NSString*)mac __attribute__((deprecated("不建议使用")));
/**
 *  校准时间成功
 */
-(void)onSetLockTime;
/**
 *  开锁成功   参数lockTime是锁里的时间（只有三代锁有这个时间，其他为0）
 */
-(void)onUnlockWithLockTime:(NSTimeInterval)lockTime;
/**
 *  上锁成功  指车位锁
 */
-(void)onLock;
/**
 *  设置管理员开门密码成功
 */
-(void)onSetAdminKeyboardPassword;
/**
 *  设置管理员删除密码成功
 */
-(void)onSetAdminDeleteKeyboardPassword;
/**
 *  重置键盘密码成功
 */
-(void)onResetKeyboardPassword_timestamp:(NSString *)timestamp pwdInfo:(NSString *)pwdInfo;
/**
 *  重置电子钥匙成功
 */
-(void)onResetEkey;
/**
 *  恢复出厂设置 (只有三代锁有)
 */
-(void)onResetLock;
/**
 *  读取开锁记录 IC卡记录成功的回调 (只有三代锁有)
 */
- (void)onGetOperateLog_LockOpenRecordStr:(NSString *)LockOpenRecordStr;
/**
 *  删除单个键盘密码 (只有三代锁有)
 */
- (void)OnDeleteUserKeyBoardPassword;
/**
 *  获取特征值 (只有三代锁有)
 */
- (void)onGetDeviceCharacteristic:(int)characteristic;
/**
 *  添加IC卡
 *
 *  @param state    1 识别到IC卡并成功添加  2成功启动添加IC卡模式
 *  @param ICNumber  状态1包含卡号，其他状态无卡号字段
 */
- (void)onAddICWithState:(AddICState)state ICNumber:(NSString*)ICNumber;
/**
 *   清空IC卡 (只有三代锁有)
 */
- (void)onClearIC;
/**
 *   删除IC卡 (只有三代锁有)
 */
- (void)onDeleteIC;
/**
 *   修改IC卡 (只有三代锁有)
 */
- (void)onModifyIC;
/**
 *  获取锁时间 (只有三代锁有)
 */
- (void)onGetLockTime:(NSTimeInterval)lockTime;
/**
 *  低电量报警 (只有LOCK锁有)
 */
- (void)onLowPower;

/**
 *  开始扫描
 */
-(void)onStartBTDeviceScan;
/**
 *  断开扫描
 */
-(void)onStopBTDeviceScan;

@end


//以下是接口
@interface TTLock : NSObject<CBPeripheralDelegate,CBCentralManagerDelegate>

//用来设置SDK是否打印Log的接口，YES打印，NO不打印 默认为No
+ (void)setDebug:(BOOL)debug;

@property (nonatomic, assign) id <TTSDKDelegate> delegate;
/**中心设备对象*/
@property (nonatomic,strong) CBCentralManager *manager;
/**服务器上用户的唯一标识，用于锁内部存储开锁记录*/
@property (nonatomic, strong) NSString *uid;
/**记录唯一标识*/
@property (nonatomic,strong) NSString* uniqueid;
/**三代锁中广播的一个信号值 0表示不连接 其他表示连接*/
@property (nonatomic,readonly) int allowUnlock;
/**车位锁 升为yes 降为no*/
@property (nonatomic) BOOL parklockAction;



/**初始化科蓝牙类
 * @param scienerDelegate
 * @return
 */
-(id)initWithDelegate:(id<TTSDKDelegate>)TTDelegate;


/** 启动蓝牙
 * @param
 * @return
 */
-(void)setupBlueTooth;
/** 开始扫描附近的蓝牙
 * @param
 * @return
 */
-(void)startBTDeviceScan;
/** 停止扫描附近的蓝牙
 * @param
 * @return
 */
-(void)stopBTDeviceScan;

/** 连接蓝牙
 * @param peripheral
 * @return
 */
-(void)connect:(CBPeripheral *)peripheral;

/** 断开蓝牙连接
 * @param peripheral
 * @return
 */
-(void) disconnect:(CBPeripheral *)peripheral;

/** 取消连接蓝牙
 * @param access_token 访问令牌
 * @return int
 */
-(void)cancelConnectPeripheral:(CBPeripheral *)peripheral;


/**
 *  获取锁电量
 */
-(int)getPower;
/** 获取锁版本
 * @param
 * @return
 */
-(void)getProtocolVersion;

/**
 *  添加管理员
 *
 *  @param advertisementData  蓝牙广播的数据advertisementData
 *  @param adminPassward      管理员密码（车位锁不用传）
 *  @param deletePassward     删除密码（车位锁与三代锁不用传）
 *  密码范围:二代锁7-10位数字 三代锁 4-8位数字
 */
-(void)addAdministrator_advertisementData:(NSDictionary *)advertisementData adminPassword:(NSString*)adminPassward deletePassword:(NSString*)deletePassward;

/** 管理员开锁 （用的是手机时间校准）
 * @param password
 * @param key
 * @return
 */
-(void)unlockByAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag;

/** 管理员开锁 （用的是referenceTime校准）
 * @param password
 * @param key
 * @return
 */
-(void)unlockByAdministrator_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag referenceTime:(NSDate *)referenceTime;


/** eKey开锁
 * @param key
 * @param startDate
 * @param endDate
 * @return
 */
-(void)unlockByUser_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey startDate:(NSDate*)startDate endDate:(NSDate*)endDate version:(NSString*)version unlockFlag:(int)flag;

/**  eKey 校准锁的时钟并开锁，和referenceTime一致
 * @param password
 * @param key
 * @return
 */
-(void)calibationTimeAndUnlock_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey startDate:(NSDate *)sdate endDate:(NSDate *)edate version:(NSString*)version unlockFlag:(int)flag referenceTime:(NSDate *)time;

/** 设置管理员的键盘密码
 * @param keyboardPassword
 * @param key
 * @param password
 * @return
 */
-(void)setAdminKeyBoardPassword:(NSString*)keyboardPassword adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;


/** 设置管理员的删除键盘密码
 * @param delKeyboardPassword
 * @param key
 * @param password
 * @return
 */
-(void)setAdminDeleteKeyBoardPassword:(NSString*)delKeyboardPassword adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;

/** 校准锁的时钟，和当前使用手机时间一致
 * @param password
 * @param key
 * @return
 */
-(void)setLockTime_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;
    

/** 校准锁的时钟，和传入参考时间一致
 * @param password
 * @param key
 * @return
 */
-(void)setLockTime_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag referenceTime:(NSDate *)time;
/**
 *  重置电子钥匙
 */
-(void)resetEkey_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;

/** 初始化用户键盘密码（即重置键盘密码）
 * @param password
 * @param key
 * @return
 */
-(void)resetKeyboardPassword_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;


/** 恢复出厂设置 （只有三代锁管理员有）
 * @param password
 * @param key
 * @return
 */
-(void)resetLock_adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey  version:(NSString*)version unlockFlag:(int)flag;
/**
 *  删除单个密码 （只有三代锁管理员有）
 *
 *  passwordType(可任意传）
 */
-(void)deleteOneKeyboardPassword:(NSString *)keyboardPs adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey passwordType:(KeyboardPsType)passwordType  version:(NSString*)version unlockFlag:(int)flag;

/**
 *  读取开锁记录 （只有三代锁有）
 */
- (void)getOperateLog_aesKey:(NSString*)aesKey version:(NSString *)version unlockFlag:(int)flag;

/**
 *  获取锁时间 （只有三代锁有）
 */
- (void)getLockTime_aesKey:(NSString*)aesKey version:(NSString*)version unlockFlag:(int)flag;
/**
 *  获取锁特征值 （只有三代锁有）
 */
- (void)getDeviceCharacteristic_lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey;
/**
 *  操作IC卡 （只有三代锁有）
 *  type  参考枚举OprationType
 *  ICNumber 卡号   类型:清空、添加和查询传 nil
 *  startDate endDate 开始时间和结束时间  类型修改需要传，永久有效卡期限:2000-1-1 0:0  2099-1-1 0:0）
 */
- (void)operate_type:(OprationType)type adminPS:(NSString*)adminPS lockKey:(NSString*)lockkey aesKey:(NSString*)aesKey ICNumber:(NSString*)ICNumber startDate:(NSDate*)startDate endDate:(NSDate*)endDate;


@end

