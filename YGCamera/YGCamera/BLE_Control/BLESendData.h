//
//  BLESendData.h
//  Potensic
//
//  Created by chen hua on 2019/4/1.
//  Copyright © 2019 chen hua. All rights reserved.
// 
#import <Foundation/Foundation.h>
#import "BLEPacket.h"
#import "BLE_KeyType_Command.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLESendData : NSObject


// APP控制云台模式(单次发送)
+ (NSData *)sendPhone_Platform_Mode:(BLE_Phone_Platform_Mode)mode;

// APP控制云台三个轴速度模式下运行(单次发送)
+ (NSData *)sendShaftSpeedWithPitchStatus:(BOOL)pitchIsOn
                               pitchSpeed:(int8_t)pitchSpeed
                               rollStatus:(BOOL)rollIsOn
                                rollSpeed:(int8_t)rollSpeed
                                yawStatus:(BOOL)yawIsOn
                                 yawSpeed:(int8_t)yawSpeed;


//APP 控制跟踪
+ (NSData *)sendPlatform_control_Tracking:(BLE_Control_Tracking_Status)controlTrack;

////手柄控制变焦(zoom)和对焦(focus)切换状态
//+ (NSData *)sendPlatformSwitchZoomOrFocus:(BLE_Phone_SwitchZoomOrFocus)zoomOrFocus;




// APP控制云台升级(单次发送)
+ (NSData *)sendPlatformUpdate;

// APP控制云台校准(单次发送)
+ (NSData *)sendPlatform_Calibration:(BLE_Control_Platform_Calibration)platform_Calibration;

// APP控制云台功能(单次发送) 关机 待机
+ (NSData *)sendPlatform_WorkState:(BLE_Platform_WorkState)workState;//// APP控制云台微调(单次发送)
//+ (NSData *)send;

+(NSData *)packDataWithCmd:(uint8_t)cmd AndData:(NSData *)data;


////全景功能控制
//+(NSData *)panoramaCtontrolWithData0:(uint8_t)data0;
//
////全景功能设置位置
//+(NSData *)panoramaSetPostitionWithIndex:(uint8_t)index
//                          pitchEffective:(uint8_t)pitchEffective
//                              pitchAngle:(int16_t)pitchAngle
//                            yawEffective:(uint8_t)yawEffective
//                                yawAngle:(int16_t)yawAngle;


//发送云台速度
+ (NSData *)sendPlatform_SpeedMode:(BLE_Control_SpeedMode)speedMode;

//获取云台信息
+ (NSData *)sendSynPlatformInfo;

//APP控制云台校准  0xA9


//漂移校准
+(NSData *)sendDirftCalibration;


//设置云台参数
+(NSData *)sendSetParamBaseDataWithArr:(NSArray *)parammeterArr;



//全景设置模式
+(NSData *)sendPlatformMode:(BLE_PanoramaType)panoramaType;

//发送全景模式序列号
+(NSData *)sendPlatformIndex:(NSInteger)indexAngle  platformMode:(BLE_PanoramaType)panoramaType;


@end

NS_ASSUME_NONNULL_END
