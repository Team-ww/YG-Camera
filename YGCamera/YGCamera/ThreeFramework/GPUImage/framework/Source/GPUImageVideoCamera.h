#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "GPUImageContext.h"
#import "GPUImageOutput.h"

extern const GLfloat kColorConversion601[];
extern const GLfloat kColorConversion601FullRange[];
extern const GLfloat kColorConversion709[];
extern NSString *const kGPUImageYUVVideoRangeConversionForRGFragmentShaderString;
extern NSString *const kGPUImageYUVFullRangeConversionForLAFragmentShaderString;
extern NSString *const kGPUImageYUVVideoRangeConversionForLAFragmentShaderString;


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
    
//    AVCapture_videoMode_normal      = 0,
//    AVCapture_videoMode_slowModel      = 3,//慢动作
//    AVCapture_videoMode_trackTime   = 4,//动态延时
//    AVCapture_videoMode_xqkk   = 5, //静态延时
//    AVCapture_videoMode_vague = 6,  //希区柯克
    AVCapture_videoMode_normal      = 0,
    AVCapture_videoMode_slowModel      = 1,//慢动作
    AVCapture_videoMode_trackTime   = 2,//动态延时
    AVCapture_videoMode_xqkk   = 3, //静态延时
    AVCapture_videoMode_vague = 4,  //希区柯克
};


typedef NS_ENUM(NSInteger, AVCapture_ScreenMode) {
    
    AVCapture_ScreenMode_custom      = 0,
    AVCapture_ScreenMode_sport      = 1,
    AVCapture_ScreenMode_slow   = 2,
    
};

typedef NS_ENUM(NSInteger, AVCapture_FilterMode) {
    
    AVCapture_FilterMode_NormalFilter      = 0,  //正常
    AVCapture_FilterMode_SketchFilter      = 1,  //素描
    AVCapture_FilterMode_VignetterFilter   = 2,  //晕影
    
    AVCapture_FilterMode_SepiaFilter                  = 3,  //怀旧
    AVCapture_FilterMode_ColorInvertFilter      = 4,//负片
    AVCapture_FilterMode_GrayscaleFilte   = 5,        //黑白
    
    AVCapture_FilterMode_CGAColorspaceFilter      = 6,//布鲁克林
    AVCapture_FilterMode_MotionBlurFilter      = 7,//移轴
    AVCapture_FilterMode_SoftLightBlendFilter   = 8,   //柔美
    AVCapture_FilterMode_SoftEleganceFilter      = 9, //旧时光
    AVCapture_FilterMode_BeautyFilter      = 10,     //美颜
};

//@[@"原图",@"素描",@"晕影",@"怀旧",@"负片",@"黑白",@"布鲁克林",@"移轴",@"柔美",@"旧时光"];


//Delegate Protocal for Face Detection.
@protocol GPUImageVideoCameraDelegate <NSObject>

@optional
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end


/**
 A GPUImageOutput that provides frames from either camera
*/
@interface GPUImageVideoCamera : GPUImageOutput <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
{
    NSUInteger numberOfFramesCaptured;
    CGFloat totalFrameTimeDuringCapture;
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_inputCamera;
    AVCaptureDevice *_microphone;
    AVCaptureDeviceInput *videoInput;
	AVCaptureVideoDataOutput *videoOutput;

    BOOL capturePaused;
    GPUImageRotationMode outputRotation, internalRotation;
    dispatch_semaphore_t frameRenderingSemaphore;
        
    BOOL captureAsYUV;
    GLuint luminanceTexture, chrominanceTexture;

    __unsafe_unretained id<GPUImageVideoCameraDelegate> _delegate;
}

/// The AVCaptureSession used to capture from the camera
@property(readonly, retain, nonatomic) AVCaptureSession *captureSession;

/// This enables the capture session preset to be changed on the fly
@property (readwrite, nonatomic, copy) NSString *captureSessionPreset;

/// This sets the frame rate of the camera (iOS 5 and above only)
/**
 Setting this to 0 or below will set the frame rate back to the default setting for a particular preset.
 */
@property (readwrite) int32_t frameRate;

/// Easy way to tell which cameras are present on device
@property (readonly, getter = isFrontFacingCameraPresent) BOOL frontFacingCameraPresent;
@property (readonly, getter = isBackFacingCameraPresent) BOOL backFacingCameraPresent;

/// This enables the benchmarking mode, which logs out instantaneous and average frame times to the console
@property(readwrite, nonatomic) BOOL runBenchmark;

/// Use this property to manage camera settings. Focus point, exposure point, etc.
@property(readonly) AVCaptureDevice *inputCamera;

/// This determines the rotation applied to the output image, based on the source material
@property(readwrite, nonatomic) UIInterfaceOrientation outputImageOrientation;

/// These properties determine whether or not the two camera orientations should be mirrored. By default, both are NO.
@property(readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera, horizontallyMirrorRearFacingCamera;

@property(nonatomic, assign) id<GPUImageVideoCameraDelegate> delegate;

/// @name Initialization and teardown

/** Begin a capture session
 
 See AVCaptureSession for acceptable values
 
 @param sessionPreset Session preset to use
 @param cameraPosition Camera to capture from
 */
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition;

/** Add audio capture to the session. Adding inputs and outputs freezes the capture session momentarily, so you
    can use this method to add the audio inputs and outputs early, if you're going to set the audioEncodingTarget 
    later. Returns YES is the audio inputs and outputs were added, or NO if they had already been added.
 */
- (BOOL)addAudioInputsAndOutputs;

/** Remove the audio capture inputs and outputs from this session. Returns YES if the audio inputs and outputs
    were removed, or NO is they hadn't already been added.
 */
- (BOOL)removeAudioInputsAndOutputs;

/** Tear down the capture session
 */
- (void)removeInputsAndOutputs;

/// @name Manage the camera video stream

/** Start camera capturing
 */
- (void)startCameraCapture;

/** Stop camera capturing
 */
- (void)stopCameraCapture;

/** Pause camera capturing
 */
- (void)pauseCameraCapture;

/** Resume camera capturing
 */
- (void)resumeCameraCapture;

/** Process a video sample
 @param sampleBuffer Buffer to process
 */
- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/** Process an audio sample
 @param sampleBuffer Buffer to process
 */
- (void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/** Get the position (front, rear) of the source camera
 */
- (AVCaptureDevicePosition)cameraPosition;

/** Get the AVCaptureConnection of the source camera
 */
- (AVCaptureConnection *)videoCaptureConnection;

/** This flips between the front and rear cameras
 */
- (void)switchCameras;

/// @name Benchmarking

/** When benchmarking is enabled, this will keep a running average of the time from uploading, processing, and final recording or display
 */
- (CGFloat)averageFrameDurationDuringCapture;

- (void)resetBenchmarkAverage;

+ (BOOL)isBackFacingCameraPresent;
+ (BOOL)isFrontFacingCameraPresent;


//闪光灯  打开 、关闭、自动
- (void)setFlashState:(AVCaptureFlashMode)flashMode;

//闪光灯状态
- (AVCaptureFlashMode)getDeviceFlashState;



//调解焦距 0.0-1.0
- (void)cameraBackgroundDidChangeFocus:(CGFloat)focus;

//当前焦距
- (CGFloat)getDeviceFocus;

//数码变焦  1-3倍
- (void)cameraBackgroundDidChangeZoom:(CGFloat)zoom;

//获取最大数码变焦焦距
- (CGFloat)maxVideoZoomFactor;

//数码变焦缩放级别
- (CGFloat)getDeviceZoom;

//设置分辨率  帧率
- (void)cameraBackgroundDidChangeVideoQuality:(AVCaptureSessionPreset)videoQuality desiredFPS:(CGFloat)desiredFPS;

//分辨率
- (AVCaptureSessionPreset)getVideoQuality;

//拍照定时   3s 5s 10s   做法倒计时
-(void)cameraBackgroundDidChangeCountDownTimer:(int)time;

//获取拍照延时时长
- (int)getCaptureDuration;

- (int)captureTime;

//EV  设置   -8.0 - 8.0 曝光补偿
- (void)cameraBackgroundDidChangeEV:(CGFloat)EV;

//EV值
- (CGFloat)getDeviceEV;

//ISO 设置  0.0 - 1.0 光感度  46 -736
-(void)cameraBackgroundDidChangeISO:(CGFloat)iso;

//ISO值
- (CGFloat)getDeviceISO;

//WB  数值设置增加或降低色温
-(void)cameraBackgroundDidChangeWB:(CGFloat)WB;

//WB
- (CGFloat)getDeviceWB;

//SEC 设置 快门速度/间隔 1/2s  苹果上用曝光时间表示
- (void)cameraBackgroundDidChangeShutter_interval:(CGFloat)shutter_interval;

//SEC  快门值
- (CGFloat)getDeviceSEC;

//延时摄影   减小帧间隔录像  类比运动相机一帧持续时间
- (void)cameraBackgroundDidChangeDelayedPhotography:(CGFloat)videoFramePerDuration;

//延时摄影
- (CGFloat)getVideoFramePerDuration;

//慢动作拍摄  加大帧到240开启 否则关闭
- (void)cameraBackgroundDidChangeSlowMotion:(BOOL)slowMotion;

//是否慢动作
- (BOOL)isSlowMode;


//HDR 状态
- (BOOL)isHDROpen;

//HDR 开启关闭
- (void)cameraBackgroundDidChangeHDR:(BOOL)HDR;

- (AVCaptureDevice *)activeDevice;



//WT变焦，MF对焦


//白平衡色温
- (float)getWhiteBalanceTemparature;

//手动设置白平衡色温
- (void)setWhiteBalanceTemperature:(int)temperature;


- (void)whiteBalanceMode:(AVCapture_WhiteBalance_Mode)whiteBalanceMode;


//手机防抖 开关
- (void)cameraAntiShakeMode:(AVCaptureVideoStabilizationMode)sabilizationMode;

//是否防抖
- (BOOL)isSabilizationMode;

@end
