//
//  CameraController.h
//  Potensic
//
//  Created by chen hua on 2019/3/20.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GCDMyTimer.h"
#import "CHImageTarget.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AVCapture_WhiteBalance_Mode) {
    
    AVCapture_WhiteBalance_Mode_Auto       = 0,
    AVCapture_WhiteBalance_Mode_Clear      = 1,
    AVCapture_WhiteBalance_Mode_Overcast   = 2,
    AVCapture_WhiteBalance_Mode_FluorescentLamp  = 3,
    AVCapture_WhiteBalance_Mode_IncandescentLamp = 4,
};

typedef NS_ENUM(NSInteger, AVCapture_capturePhotoMode) {
    
    AVCapture_capturePhotoMode_normal      = 0,
    AVCapture_capturePhotoMode_menu180      = 1,
    AVCapture_capturePhotoMode_menu360   = 2,
    
//
//    AVCapture_capturePhotoMode_slowModel  = 3,//慢动作
//    AVCapture_capturePhotoMode_trackTime  = 4,//动态延时
//    AVCapture_capturePhotoMode_xqkk = 5,   //静态延时
//    AVCapture_capturePhotoMode_vague = 6,  //希区柯克
};

typedef NS_ENUM(NSInteger, AVCapture_videoMode) {
    
    AVCapture_videoMode_normal      = 0,
    AVCapture_videoMode_slowModel      = 3,//慢动作
    AVCapture_videoMode_trackTime   = 4,//动态延时
     AVCapture_videoMode_xqkk   = 5, //静态延时
    AVCapture_videoMode_vague = 6,  //希区柯克
};


typedef NS_ENUM(NSInteger, AVCapture_ScreenMode) {
    
    AVCapture_ScreenMode_custom      = 0,
    AVCapture_ScreenMode_sport      = 1,
    AVCapture_ScreenMode_slow   = 2,

};


@protocol CameraControllerDelegate <NSObject>

- (void)deviceConfigurationFailedWithError:(NSError *)error;
- (void)mediaCaptureFailedWithError:(NSError *)error;
- (void)assetLibraryWriteFailedWithError:(NSError *)error;
-(void)didCameraDataOutput:(CMSampleBufferRef)sampleBuffer;

@end

@interface CameraController : NSObject

@property(nonatomic,weak)id<CameraControllerDelegate> delegate;
@property(nonatomic,weak) id <CHImageTarget> imageTarget;
@property(nonatomic,strong,readonly)AVCaptureSession *captureSession;
@property(nonatomic, getter = isRecording) BOOL recording;


- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;

- (AVCaptureDevice *)activeDevice;

/** Media Capture Methods **/

- (void)captureStillImageWithResultHandler:(void(^_Nullable)(UIImage * _Nullable result, NSError * _Nullable error))resultHandler capturePhoto_mode:(AVCapture_capturePhotoMode)capturePhoto_mode;;

- (BOOL)isStillCaptureImage;

//Video recording
- (void)startRecording;
- (void)stopRecording;
- (BOOL)isRecording;


//Capture Switch

// Camera Device Support                                                    // 3
- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;


//parameter setting Session

//闪光灯  打开 、关闭、自动
- (void)setFlashState:(AVCaptureFlashMode)flashMode;

////白平衡  自动 晴天 阴天 荧光灯 白炽灯 白平衡模式
//- (void)whiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode;

//白平衡  自动 晴天 阴天 荧光灯 白炽灯 白平衡模式
- (void)whiteBalanceMode:(AVCapture_WhiteBalance_Mode)whiteBalanceMode;


//手动设置白平衡色温
- (void)setWhiteBalanceTemperature:(int)temperature;

//手机防抖 开关
- (void)cameraAntiShakeMode:(AVCaptureVideoStabilizationMode)sabilizationMode;

//ISO 设置  0.0 - 1.0 光感度  46 -736
-(void)cameraBackgroundDidChangeISO:(CGFloat)iso;

//EV  设置   -8.0 - 8.0 曝光补偿
- (void)cameraBackgroundDidChangeEV:(CGFloat)EV;

//SEC 设置 快门速度/间隔 1/2s  苹果上用曝光时间表示
- (void)cameraBackgroundDidChangeShutter_interval:(CGFloat)shutter_interval;

//WB  数值设置增加或降低色温
-(void)cameraBackgroundDidChangeWB:(CGFloat)WB;

//调解焦距 0.0-1.0
- (void)cameraBackgroundDidChangeFocus:(CGFloat)focus;

//数码变焦  1-3倍
- (void)cameraBackgroundDidChangeZoom:(CGFloat)zoom;

//HDR 开启关闭
- (void)cameraBackgroundDidChangeHDR:(BOOL)HDR;

//延时摄影   减小帧间隔录像  类比运动相机一帧持续时间
- (void)cameraBackgroundDidChangeDelayedPhotography:(CGFloat)videoFramePerDuration;

//慢动作拍摄  加大帧到240开启 否则关闭
- (void)cameraBackgroundDidChangeSlowMotion:(BOOL)slowMotion;

//拍照定时   3s 5s 10s   做法倒计时
-(void)cameraBackgroundDidChangeCountDownTimer:(int)time;

//设置分辨率  帧率
- (void)cameraBackgroundDidChangeVideoQuality:(AVCaptureSessionPreset)videoQuality desiredFPS:(CGFloat)desiredFPS;

//获取内存 见DeviceInfo
//获取电量 见DeviceInfo
//parameter getting Session

//当前焦距
- (CGFloat)getDeviceFocus;

//是否防抖
- (BOOL)isSabilizationMode;

//HDR 状态
- (BOOL)isHDROpen;

//数码变焦缩放级别
- (CGFloat)getDeviceZoom;

//分辨率
- (AVCaptureSessionPreset)getVideoQuality;

//EV值
- (CGFloat)getDeviceEV;

//WB
- (CGFloat)getDeviceWB;

//ISO值
- (CGFloat)getDeviceISO;

//闪光灯状态
- (AVCaptureFlashMode)getDeviceFlashState;

//白平衡模式
- (AVCaptureWhiteBalanceMode)getDeviceBalanceMode;

//SEC  快门值
- (CGFloat)getDeviceSEC;

//是否慢动作
- (BOOL)isSlowMode;

//延时摄影
- (CGFloat)getVideoFramePerDuration;


//显示/隐藏网格
- (void)switchGrid:(BOOL)toShow;


//获取拍照延时时长
- (int)getCaptureDuration;


- (BOOL)capturingStillImage;


- (int)captureTime;

//希区柯克式变焦怎么实现？镜头锁定物体主体，推动变焦杆放大的同时匀速向后退，即可完成希区柯克式变焦，就是这么简单。了解希区柯克式变焦以后就会明白，所谓“希区柯克式变焦”其实就是Dolly Zoom，中文称“推轨变焦”或“移动变焦”，或者“滑动变焦”，操作起来并不难，但是效果确实炫酷。


//　　光源色温（K）
//　　蜡烛 2000
//　　钨丝灯2500-3200
//　　碳棒灯4000-5500
//　　荧光灯4500-6500
//　　日光（平均） 5400
//　　有云天气下的日光6500-7000
//　　阴天日光12000-18000


//WB 色调  (-150  150)   -150  -100 -50 0 50  100  150


- (void)setTintWB:(CGFloat)tint;


- (CGFloat)getTintWB;

//AVCaptureDevice *device = [self.controller activeDevice];
//AVCaptureWhiteBalanceTemperatureAndTintValues values = [device temperatureAndTintValuesForDeviceWhiteBalanceGains:device.deviceWhiteBalanceGains];
//
//NSLog(@"temperature=%f---tint == %f",values.temperature,values.tint);//-150,-150;
//NSLog(@"maxWhiteBalanceGain ==%f",[self.controller activeDevice].maxWhiteBalanceGain);


@end

NS_ASSUME_NONNULL_END
