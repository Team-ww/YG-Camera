//
//  BLEPlatformStatus.h
//  Potensic
//
//  Created by chen hua on 2019/4/2.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLE_KeyType_Command.h"
#import "SetParameterBaseMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLEPlatformStatus : NSObject


//电池状态  正常/充电/低电/待机/准备关机模式
@property(nonatomic,assign)BLE_Battery_State battery_state;


//电池电量 0 -100
@property(nonatomic,assign)int batteryValue;

//云台模式 跟随模式 ，锁定模式，全跟随，疯狗模式  DATA[2]  =  云台运行模式
@property(nonatomic,assign)BLE_Phone_Platform_Mode platform_Mode;

//云台情景模式  DATA[3]  =  云台情景模式
@property(nonatomic,assign)BLE_Control_SpeedMode speedMode;

@property(nonatomic,assign)BOOL canZoom;

//设备名称
@property(nonatomic,strong)NSString *pMode;
//设备序列号
@property(nonatomic,strong)NSString *pSN;
//设备版本号码
@property(nonatomic,strong)NSString *pVersion;

@property(nonatomic,strong)SetParameterBaseMode *setParamBase_ptich;
@property(nonatomic,strong)SetParameterBaseMode *setParamBase_roll;
@property(nonatomic,strong)SetParameterBaseMode *setParamBase_yaw;

//全景模式  人为设置
@property(nonatomic,assign)BLE_PanoramaType   panoramaType;

//获取电池信息
- (void)getBatteryInfoWithData:(NSData *)data;


//获取云台模式信息
- (void)getPlatformModeWithData:(NSData *)data;


// 按键类型控制
- (void)updateKeyAndActionTypeCommandWithData:(NSData *)data completionBlock:(void(^_Nullable)(BLE_KeyType_Command keyTye, BLE_KeyActionType_Command action))resultHandler;


//2、    按键消息2(20hz发送)
//发送:
//CMD = 0xA1,LENS = 4
//DATA[0:1]  =  type 编码器类型 1 focus,2 detial
//DATA[2:3]  =  val 编码值 int16_t 类型 -1 or 1
//负值代表逆时针旋转，正值代表顺时针旋转。
- (void)updateKeyMessageWithData:(NSData *)data completionBlock:(void(^_Nullable)(uint16_t codeType1, int16_t rotationType1))resultHandler;


//是否可以控制变焦 DATA[0]  =  0 变焦状态(默认) DATA[0]  =  1 对焦状态
- (void)updateZoomOrFocusWithData:(NSData *)data completionBlock:(void(^_Nullable)(uint8_t value))resultHandler;



//手柄控制变焦(zoom)和对焦(focus)切换状态
//发送:
//CMD  =  0xAC, LENS = 1
//DATA[0]  =  0 变焦状态(默认)
//DATA[0]  =  1 对焦状态
//接收方返回:
//CMD  =  0xAC, LENS = 0


//获取云台版本信息
- (void)getSynPlatformVersionWithData:(NSData *)data;

//漂移校准
- (BOOL)getCalibrationInfoWithData:(NSData *)data;

//获取云台遥感数据
- (void)getPlatform_ParametersWithData:(NSData *)data;

//解析设置的云台数据回复
- (BOOL)getSetParameterData:(NSData *)data;

//全景模式下序列号
- (NSInteger)getIndexParameterData:(NSData *)data;


@end

NS_ASSUME_NONNULL_END
