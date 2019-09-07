//
//  BLESendData.m
//  Potensic
//
//  Created by chen hua on 2019/4/1.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "BLESendData.h"
#import "BLEPacket.h"
#import "SetParameterBaseMode.h"

@implementation BLESendData

// APP控制云台模式(单次发送)
+(NSData *)sendPhone_Platform_Mode:(BLE_Phone_Platform_Mode)mode{
    
    Byte data[1];
    data[0] = mode;
    uint8_t cmd = 0xA4;
    uint8_t lens = 1;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}

// APP控制云台三个轴速度模式下运行(单次发送)
+ (NSData *)sendShaftSpeedWithPitchStatus:(BOOL)pitchIsOn
                               pitchSpeed:(int8_t)pitchSpeed
                               rollStatus:(BOOL)rollIsOn
                                rollSpeed:(int8_t)rollSpeed
                                yawStatus:(BOOL)yawIsOn
                                 yawSpeed:(int8_t)yawSpeed{
    
    Byte data[6];
    data[0] = pitchIsOn?1:2;
    data[1] = pitchSpeed;
    
    data[2] = rollIsOn?1:2;
    data[3] = rollSpeed;
    
    data[4] = yawIsOn?1:2;
    data[5] = yawSpeed;
    
    uint8_t cmd = 0xA5;
    uint8_t lens = 6;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}

// APP控制云台功能(单次发送) 关机 待机
+ (NSData *)sendPlatform_WorkState:(BLE_Platform_WorkState)workState{
    
    Byte data[1];
    data[0] = workState;
    uint8_t cmd = 0xA6;
    uint8_t lens = 1;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}


// APP控制云台升级(单次发送)
+ (NSData *)sendPlatformUpdate{
    
    Byte data[1];
    data[0] = 1;
    uint8_t cmd = 0xA8;
    uint8_t lens = 1;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}

// APP控制云台校准(单次发送) 进入校准模式 + 具体执行过程
+ (NSData *)sendPlatform_Calibration:(BLE_Control_Platform_Calibration)platform_Calibration{
    
    Byte data[1];
    data[0] = platform_Calibration;
    uint8_t cmd = 0xA9;
    uint8_t lens = 1;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}


//APP 控制跟踪
+ (NSData *)sendPlatform_control_Tracking:(BLE_Control_Tracking_Status)controlTrack{
    
    Byte data[1];
    data[0] = controlTrack;
    uint8_t cmd = 0xAD;
    uint8_t lens = 1;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}

////手柄控制变焦(zoom)和对焦(focus)切换状态
//+ (NSData *)sendPlatformSwitchZoomOrFocus:(BLE_Phone_SwitchZoomOrFocus)zoomOrFocus{
//    
//    Byte data[1];
//    data[0] = zoomOrFocus;
//    uint8_t cmd = 0xAC;
//    uint8_t lens = 1;
//    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
//}

+(NSData *)packDataWithCmd:(uint8_t)cmd AndData:(NSData *)data{
    
    
    int len = data.length + 6;
    uint8_t *dataBytePtr = (uint8_t *)[data bytes];
    Byte bytes[len];
    bytes[0] = 0x55;
    bytes[1] = 0xaa;
    bytes[2] = cmd;
    bytes[3] = data.length;
    memcpy(bytes+4, dataBytePtr, data.length);
    uint8_t checksum1 = 0;
    uint8_t checksum2 = 0;
    checksum1 = cmd;
    checksum2 = checksum1;
    checksum1 += data.length;
    checksum2 += checksum1;
    
    for (int i = 0; i < data.length; i++) {
        checksum1 += dataBytePtr[i];
        checksum2 += checksum1;
    }
    bytes[4+data.length] = checksum1;
    bytes[4+data.length+1] = checksum2;
    return [NSData dataWithBytes:bytes length:len];
}


////全景功能控制
//+(NSData *)panoramaCtontrolWithData0:(uint8_t)data0{
//
//    Byte data[1];
//    data[0] = data0;
//    uint8_t cmd = 0xB3;
//    uint8_t lens = 1;
//    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
//}
//
//
////全景功能设置位置
//+(NSData *)panoramaSetPostitionWithIndex:(uint8_t)index
//                          pitchEffective:(uint8_t)pitchEffective
//                              pitchAngle:(int16_t)pitchAngle
//                            yawEffective:(uint8_t)yawEffective
//                              yawAngle:(int16_t)yawAngle{
//
//    Byte data[8];
//    data[0] = 1;
//    data[1] = index;
//    data[2] = pitchEffective;
//    data[3] = pitchEffective%256;
//    data[4] = pitchEffective/256;
//    data[5] = yawEffective;
//    data[6] = yawAngle%256;
//    data[7] = yawAngle/256;
//    uint8_t cmd = 0xB4;
//    uint8_t lens = 8;
//    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
//}

//发送云台速度
+ (NSData *)sendPlatform_SpeedMode:(BLE_Control_SpeedMode)speedMode{
    Byte data[1];
    data[0] = speedMode;
    uint8_t cmd = 0xB5;
    uint8_t lens = 1;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}


//获取云台信息
+ (NSData *)sendSynPlatformInfo{
    
    Byte data[1];
    data[0] = 1;
    uint8_t cmd = 0xB8;
    uint8_t lens = 1;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}

//漂移校准
+(NSData *)sendDirftCalibration{
    
    Byte data[1];
    data[0] = 1;
    uint8_t cmd = 0xBC;
    uint8_t lens = 1;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}


//设置云台参数
+(NSData *)sendSetParamBaseDataWithArr:(NSArray *)parammeterArr{
    
    
    Byte data[12];
//    data[0] = 1;
    uint8_t cmd = 0xb7;
    uint8_t lens = 12;
    SetParameterBaseMode *mode1  = parammeterArr[0];
    SetParameterBaseMode *mode2 = parammeterArr[1];
    SetParameterBaseMode *mode3 = parammeterArr[2];
    
    data[0] = mode1.CtrlRate;
    data[1] = mode1.CtrlDeadband;
    data[2] = mode1.RockerCtrlRate;
    data[3] = mode1.RockerCtrlDeadband;
    
    data[4] = mode2.CtrlRate;
    data[5] = mode2.CtrlDeadband;
    data[6] = mode2.RockerCtrlRate;
    data[7] = mode2.RockerCtrlDeadband;
    
    data[8] = mode3.CtrlRate;
    data[9] = mode3.CtrlDeadband;
    data[10] = mode3.RockerCtrlRate;
    data[11] = mode3.RockerCtrlDeadband;
    
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}

//全景设置
+(NSData *)sendPlatformMode:(BLE_PanoramaType)panoramaType{
    
    Byte data[1];
    data[0] = panoramaType;
    uint8_t cmd = 0xB3;
    uint8_t lens = 1;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}


//发送全景模式序列号
+(NSData *)sendPlatformIndex:(NSInteger)indexAngle  platformMode:(BLE_PanoramaType)panoramaType{
    
    Byte data[2];
    data[0] = panoramaType;
    data[1] = indexAngle;
    uint8_t cmd = 0xB4;
    uint8_t lens = 2;
    return [BLEPacket sendControlDatawithBytes:data cmd:cmd length:lens];
}

@end
