//
//  BLE_KeyType_Command.h
//  Potensic
//
//  Created by chen hua on 2019/4/1.
//  Copyright © 2019 chen hua. All rights reserved.
//

#ifndef BLE_KeyType_Command_h
#define BLE_KeyType_Command_h


//按键类型
typedef NS_ENUM(NSInteger, BLE_KeyType_Command ){
    
    BLE_KeyType_Command_POWER_KEY    = 0,   //电源按键
    BLE_KeyType_Command_MENU_KEY     = 1,   //菜单按键
    BLE_KeyType_Command_FOCUS_KEY    = 2,   //对焦按键
    BLE_KeyType_Command_MODE_KEY     = 3,   //模式按键
    
    BLE_KeyType_Command_RECORD_KEY   = 4,   //录像按键
    BLE_KeyType_Command_FLASH_KEY    = 5,   //闪光按键
    BLE_KeyType_Command_DETAL_KEY    = 6,   //详情按键
    BLE_KeyType_Command_PHOTO_KEY    = 7,   //拍照按键
    
    BLE_KeyType_Command_FOLLOW_KEY   = 8,   //跟随模式按键
    BLE_KeyType_Command_EXPOSURE_KEY = 9,   //曝光按键
    BLE_KeyType_Command_PLAYBACK_KEY = 10,  //回放按键
    BLE_KeyType_Command_LENS_KEY     = 11,  //Lens按键 
    BLE_KeyType_Command_RESOUL_KEY   = 12,  //分辨率按键
};


//按键动作类型
typedef NS_ENUM(NSInteger, BLE_KeyActionType_Command ){
    
    BLE_KeyActionType_Command_SHORT_KEY_ACTION     = 1,   //短按动作
    BLE_KeyActionType_Command_LONG_KEY_ACTION      = 2,   //长按动作
    BLE_KeyActionType_Command_DOUBLE_KEY_ACTION    = 3,   //双击动作
};


//电池状态
//按键动作类型
typedef NS_ENUM(NSInteger, BLE_Battery_State ){
    
    BLE_Battery_State_Normal           = 1,   //正常状态
    BLE_Battery_State_Charge           = 2,   //充电模式
    BLE_Battery_State_LowPower         = 3,   //低电模式
    BLE_Battery_State_Standby          = 4,   //待机模式
    BLE_Battery_State_ReadyToTurnOff   = 5,   //准备关机模式
};

//APP控制云台模式(单次发送)
typedef NS_ENUM(NSInteger, BLE_Phone_Platform_Mode ){
    
    BLE_Control_Platform_FollowIngMode           = 0,   //跟随模式(pitch,roll跟随姿态，yaw跟电机位置)
    BLE_Control_Platform_LockMode                = 1,   //锁定模式(pitch,roll跟随姿态,yaw轴跟随姿态)
    BLE_Control_Platform_FullFollowIngMode       = 2,   //全跟随模式(roll跟随姿态,pitch, yaw跟电机位置)
    BLE_Control_Platform_MaddogMode              = 3,   //疯狗模式(快速响应。roll跟随姿态,pitch, yaw跟电机位置) FPV
};

//APP控制云台模式(单次发送) 云台工作状态
typedef NS_ENUM(NSInteger, BLE_Platform_WorkState ){
    
    BLE_Platform_WorkState_ShutDown              = 1,  //关机
    BLE_Platform_WorkState_Standby               = 2,  //待机
};

//APP控制云台模式(单次发送) APP控制跟踪状态
typedef NS_ENUM(NSInteger, BLE_Control_Tracking_Status){
    
    BLE_Control_Tracking_Status_StartTracking         = 1,  //开始跟踪
    BLE_Control_Tracking_Status_TrackingLoss          = 2,  //跟踪丢失
    BLE_Control_Tracking_Status_StopTracking          = 3,  //停止跟踪
};


//APP控制云台速度
typedef NS_ENUM(NSInteger, BLE_Control_SpeedMode){
    
    BLE_Control_SpeedMode_Slow         = 0,  //步行模式
    BLE_Control_SpeedMode_Sport        = 1,  //运动模式
    BLE_Control_SpeedMode_Custom       = 2,  //自定义模式

};

//手柄控制变焦(zoom)和对焦(focus)切换状态
typedef NS_ENUM(NSInteger, BLE_Phone_SwitchZoomOrFocus){
    
    BLE_Phone_SwitchZoom         = 0,  //变焦状态(默认)
    BLE_Phone_SwitchFocus        = 1,  //对焦状态
};

//APP控制云台微调(单次发送)
typedef NS_ENUM(NSInteger, BLE_Control_Platform_FineTuning){
    
    BLE_Control_Platform_FineTuning_Pitch         = 1,  //pitch轴微调
    BLE_Control_Platform_FineTuning_Roll          = 2,  //roll 轴微调
    BLE_Control_Platform_FineTuning_Yaw           = 3,  //yaw 轴微调
};

//APP控制云台校准(单次发送) 具体实施过程
typedef NS_ENUM(NSInteger, BLE_Control_Platform_Calibration){
    
    BLE_Control_Platform_Calibration_Pitch_Start         = 1,  //pitch电机校准开始
    BLE_Control_Platform_Calibration_Pitch_End           = 2,  //pitch电机校准结束
    
    BLE_Control_Platform_Calibration_Roll_Start          = 3,  //roll 电机校准开始
    BLE_Control_Platform_Calibration_Roll_End            = 4,  //roll 电机校准结束
    
    BLE_Control_Platform_Calibration_Yaw_Start           = 5,  //yaw电机校准开始
    BLE_Control_Platform_Calibration_Yaw_End             = 6,  //yaw电机校准结束
    
    BLE_Control_Platform_Calibration_Angle_Start         = 7,  //云台角度校准开始
    BLE_Control_Platform_Calibration_Angle_End           = 8,  //云台角度校准结束
    
    BLE_Control_Platform_Calibration_Gyroscopes_Offset_Start        = 9,  //校准陀螺仪offset开始
    BLE_Control_Platform_Calibration_Gyroscopes_Offset_End          = 10, //校准陀螺仪offset结束
    
    BLE_Control_Platform_Calibration_Gyroscopes_Orthogonal_Start    = 11,  //陀螺仪正交校准开始
    BLE_Control_Platform_Calibration_Gyroscopes_Orthogonal_End      = 12,  //陀螺仪正交校准结束
    
    BLE_Control_Platform_Calibration_Acceleration_Start             = 13,  //加速度校准开始
    BLE_Control_Platform_Calibration_Acceleration_Face_1            = 14,  //加速度校准第1面
    
    BLE_Control_Platform_Calibration_Acceleration_Face_2            = 15,  //加速度校准第2面
    BLE_Control_Platform_Calibration_Acceleration_Face_3            = 16,  //加速度校准第3面
    
    BLE_Control_Platform_Calibration_Acceleration_Face_4            = 17,  //加速度校准第4面
    BLE_Control_Platform_Calibration_Acceleration_Face_5            = 18,  //加速度校准第5面
    BLE_Control_Platform_Calibration_Acceleration_Face_6            = 19,  //加速度校准第6面
    BLE_Control_Platform_Calibration_Acceleration_End               = 20,  //加速度校准结束
    
    BLE_Control_Platform_Calibration_Rocker_Start                   = 25,  //摇杆校准开始
    BLE_Control_Platform_Calibration_Rocker_End                     = 26,  //摇杆校准结束
    BLE_Control_Platform_Calibration_Enter                          = 0x33,//进入校准模式
};


//全景功能控制模式

typedef NS_ENUM(NSInteger, BLE_PanoramaType){
    
    BLE_Phone_panorama_Normal     = 0,  //正常模式
    BLE_Phone_panorama_180        = 1,     //180全景模式
    BLE_Phone_panorama_360        = 2,     //360度全景模式
    BLE_Phone_panorama_3chen3     = 3,     //3X3全景模式
};

typedef struct {
    
    int8_t CtrlRate;
    int8_t CtrlDeadband;
    int8_t RockerCtrlRate;
    int8_t RockerCtrlDeadband;
}SetParamBase;


typedef struct{
    
    uint8_t pMode[10];//设备名称
    uint8_t pSN[10];//设备序列号
    float pVerison;//设备版本号码
}pInfo_Type;

#endif /* BLE_KeyType_Command_h */
