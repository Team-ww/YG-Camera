//
//  BLEPlatformStatus.m
//  Potensic
//
//  Created by chen hua on 2019/4/2.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "BLEPlatformStatus.h"



@implementation BLEPlatformStatus

//4、    电池状态(10hz发送)
//发送:
//CMD  =  0xA3, LENS = 2
//DATA[0]  =  1  正常状态
//DATA[0]  =  2  充电模式
//DATA[0]  =  3  低电模式
//DATA[0]  =  4  待机模式
//DATA[0]  =  5  准备关机模式
//
//DATA[1]  =  电池电量 (0 ~100)
//接收方返回:
//CMD  =  0xA3, LENS = 0
- (void)getBatteryInfoWithData:(NSData *)data{
    
    if (data.length < 4) {
        return;
    }
    uint8_t battery_status = 0;
    [data getBytes:&battery_status range:NSMakeRange(0, 1)];
    self.battery_state = battery_status;
    uint8_t battery_value = 0;
    [data getBytes:&battery_value range:NSMakeRange(1, 1)];
    self.batteryValue = battery_value;
    
    BLE_Phone_Platform_Mode platform_Mode = 0;
    [data getBytes:&platform_Mode range:NSMakeRange(2, 1)];
    self.platform_Mode = platform_Mode;
    
    BLE_Control_SpeedMode speedMode = 0;
    [data getBytes:&speedMode range:NSMakeRange(3, 1)];
    self.speedMode = speedMode;
}

//云台模式(10hz发送)
//CMD  =  0xA2, LENS = 1
//DATA[0]  =  0 跟随模式(pitch,roll跟随姿态，yaw跟电机位置)
//DATA[0]  =  1 锁定模式(pitch,roll跟随姿态,yaw轴镜头锁定)
//DATA[0]  =  2 全跟随模式(pitch,roll，yaw跟电机位置)
//DATA[0]  =  3 疯狗模式(快速响应。pitch,roll跟随姿态，yaw跟电机位置)
//获取云台模式信息
- (void)getPlatformModeWithData:(NSData *)data{
    
    if (data.length < 1) {
        return;
    }
    uint8_t platformMode = 0;
    [data getBytes:&platformMode range:NSMakeRange(0, 1)];
    self.platform_Mode = platformMode;
}

// 按键类型控制
- (void)updateKeyAndActionTypeCommandWithData:(NSData *)data completionBlock:(void(^_Nullable)(BLE_KeyType_Command keyTye1, BLE_KeyActionType_Command action1))resultHandler{
    
    if (data.length < 2) {
        return;
    }
    
    BLE_KeyType_Command keyType = 0;
    [data getBytes:&keyType range:NSMakeRange(0, 1)];
    BLE_KeyActionType_Command action = 0;
    [data getBytes:&action range:NSMakeRange(1, 1)];
    if (action == BLE_KeyActionType_Command_SHORT_KEY_ACTION) {
        resultHandler(keyType,action);
    }
}

//2、    按键消息2(20hz发送)
//发送:
//CMD = 0xA1,LENS = 4
//DATA[0:1]  =  type 编码器类型 1 focus,2 detial
//DATA[2:3]  =  val 编码值 int16_t 类型 -1 or 1
//负值代表逆时针旋转，正值代表顺时针旋转。
- (void)updateKeyMessageWithData:(NSData *)data completionBlock:(void(^_Nullable)(uint16_t codeType1, int16_t rotationType1))resultHandler{
    
    if (data.length < 4) {
        return;
    }
    uint16_t keyType = 0;
    [data getBytes:&keyType range:NSMakeRange(0, 2)];
    int16_t rotationType = 0;
    [data getBytes:&rotationType range:NSMakeRange(2, 2)];
    resultHandler(keyType,rotationType);
}

//是否可以控制变焦 DATA[0]  =  0 变焦状态(默认) DATA[0]  =  1 对焦状态
- (void)updateZoomOrFocusWithData:(NSData *)data completionBlock:(void(^_Nullable)(uint8_t value))resultHandler{
    
    if (data.length < 1) {
        return;
    }
    uint8_t keyValue = 0;
    [data getBytes:&keyValue range:NSMakeRange(0, 1)];
    self.canZoom = keyValue == 0 ? YES :NO;
    resultHandler(keyValue);
}

//获取云台版本信息
- (void)getSynPlatformVersionWithData:(NSData *)data{
    
    pInfo_Type pInfo;
    [data getBytes:&pInfo range:NSMakeRange(0, sizeof(pInfo))];
    NSMutableString *pModeStr;
    for (int i = 0; i < 10; i++) {
        [pModeStr appendString:[NSString stringWithFormat:@"%d",pInfo.pMode[i]]];
    }
    self.pMode = pModeStr;
    NSMutableString *pSNStr;
    for (int i = 0; i < 10; i++) {
        [pSNStr appendString:[NSString stringWithFormat:@"%d",pInfo.pSN[i]]];
    }
    self.pSN = pSNStr;
    self.pVersion = [NSString stringWithFormat:@"%.3f",pInfo.pVerison];
}

//漂移校准
- (BOOL)getCalibrationInfoWithData:(NSData *)data{
    
    uint8_t result = 0;
    [data getBytes:&result range:NSMakeRange(0, 1)];
    return result;
}


//获取云台遥感数据
- (void)getPlatform_ParametersWithData:(NSData *)data{
    
    // 获取云台参数
    SetParamBase sParamArr[3];
    [data getBytes:&sParamArr range:NSMakeRange(0, 12)];
   
    SetParamBase  setParamBase_ptich = sParamArr[0];
    if (!self.setParamBase_ptich) {
        self.setParamBase_ptich = [[SetParameterBaseMode alloc]init];
    }
    [self setParamBaseWithModel:self.setParamBase_ptich setParamBase:setParamBase_ptich];
    SetParamBase  setParamBase_yaw = sParamArr[1];
    if (!self.setParamBase_yaw) {
        self.setParamBase_yaw = [[SetParameterBaseMode alloc]init];
    }
    [self setParamBaseWithModel:self.setParamBase_yaw setParamBase:setParamBase_yaw];
    
    SetParamBase  setParamBase_roll = sParamArr[2];
    if (!self.setParamBase_roll) {
        self.setParamBase_roll = [[SetParameterBaseMode alloc]init];
    }
    [self setParamBaseWithModel:self.setParamBase_roll setParamBase:setParamBase_roll];
}

- (void)setParamBaseWithModel:(SetParameterBaseMode *)mdoe  setParamBase:(SetParamBase)setParamBase{
    
    mdoe.CtrlRate = setParamBase.CtrlRate;
    mdoe.CtrlDeadband = setParamBase.CtrlDeadband;
    mdoe.RockerCtrlRate = setParamBase.RockerCtrlRate;
    mdoe.RockerCtrlDeadband = setParamBase.RockerCtrlDeadband;
}

//解析设置的云台数据回复
- (BOOL)getSetParameterData:(NSData *)data{
    
    uint8_t result = 0;
    [data getBytes:&result range:NSMakeRange(0, 1)];
    return result;
}

//全景模式下序列号
- (NSInteger)getIndexParameterData:(NSData *)data{
    
    uint8_t result = 0;
    [data getBytes:&result range:NSMakeRange(1, 1)];
    return result;
}


@end
