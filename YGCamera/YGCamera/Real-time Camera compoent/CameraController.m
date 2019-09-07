//
//  CameraController.m
//  Potensic
//
//  Created by chen hua on 2019/3/20.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "CameraController.h"
#import <UIKit/UIKit.h>
#import "PhotoLibraryManager.h"
#import "Utils.h"
#import "CHMovieWriter.h"
#import "PhotoTool.h"


@interface CameraController ()<CameraControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,CHMovieWriterDelegate>{
    
    AVCaptureDeviceFormat *_defaultFormat;
    CMTime  _defaultMinFrameDuration;
    CMTime  _defaultMaxFrameDuration;
    NSInteger countDownTime;
}


@property(strong,nonatomic) AVCaptureSession *captureSession;
@property(strong,nonatomic) AVCaptureDeviceInput *activeVideoInput;
@property(strong,nonatomic) AVCaptureStillImageOutput *imageOutput;
@property(strong,nonatomic) AVCapturePhotoOutput *photoOutput;
//@property(strong,nonatomic) AVCaptureMovieFileOutput *movieOutput;
@property(strong,nonatomic) NSURL *outputURL;
@property(strong,nonatomic) AVCaptureDevice *captureDevice;
@property(nonatomic,readwrite) dispatch_queue_t countDownTimerQueue;
@property(nonatomic,strong)GCDMyTimer *countDownTimer;
@property(strong,nonatomic) AVCaptureVideoDataOutput *videoDataOutput;
@property(strong,nonatomic) AVCaptureAudioDataOutput *audioDataOutput;
@property(strong,nonatomic) dispatch_queue_t videoDispatchQueue;
@property(strong,nonatomic) CHMovieWriter *movieWriter;


@end

@implementation CameraController

- (BOOL)setupSession:(NSError **)error
{
    self.captureSession = [[AVCaptureSession alloc]init];
    self.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;

    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput  = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    self.captureDevice = videoDevice;
    if ([self.captureSession canAddInput:videoInput]) {
        
        
        [self.captureSession addInput:videoInput];
        self.activeVideoInput = videoInput;
        if (!self.activeVideoInput) {
            return NO;
        }
    }
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
    if (!audioInput) {
        return NO;
    }
    if ([self.captureSession canAddInput:audioInput]) {
        [self.captureSession addInput:audioInput];
    }
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    
   //connection.videoOrientation = [weakself currentVideoOrientation];

//    保存默认的AVCaptureDeviceFormat
//    之所以保存是因为修改摄像头捕捉频率之后，防抖就无法再次开启，试了下只能够用这个默认的format才可以，所以把它存起来，关闭慢动作拍摄后在设置会默认的format开启防抖
    _defaultFormat = self.captureDevice.activeFormat;
    _defaultMinFrameDuration = self.captureDevice.activeVideoMinFrameDuration;
    _defaultMaxFrameDuration = self.captureDevice.activeVideoMaxFrameDuration;
    countDownTime = 0;
   [self setupSessionOutputs:error];
    
    return YES;
}


- (AVCaptureDevice *)activeDevice{
    
    return self.activeVideoInput.device;
   // return self.captureDevice;
}

- (BOOL)setupSessionOutputs:(NSError **)error{
    
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSDictionary *outputSettings =
    @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    self.videoDataOutput.videoSettings = outputSettings;
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    [self.videoDataOutput setSampleBufferDelegate:self
                                            queue:[self globalQueue]];
    // _videoDispatchQueue = dispatch_queue_create("com.tapharmonic.CaptureDispatchQueue", NULL);

    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
    }else{
        return NO;
    }
    self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.audioDataOutput setSampleBufferDelegate:self queue:[self globalQueue]];
    if ([self.captureSession canAddOutput:self.audioDataOutput]) {
        [self.captureSession addOutput:self.audioDataOutput];
    }else{
        return NO;
    }
    
    AVCaptureConnection *connection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.isVideoOrientationSupported) {
        
        //NSLog(@">>>>>>%d",connection.videoOrientation);
        connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
      //  [self currentVideoOrientation];
    }

    NSString *filType = AVFileTypeQuickTimeMovie;
    NSDictionary *videoSettings = [self.videoDataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:filType];
    NSDictionary *audioSettings = [self.audioDataOutput recommendedAudioSettingsForAssetWriterWithOutputFileType:filType];
    self.movieWriter = [[CHMovieWriter alloc] initWithVideoSettings:videoSettings audioSettings:audioSettings dispatchQueue:[self globalQueue]];
    self.movieWriter.delegate = self;
    return YES;
}

- (void)startSession
{
    if (![self.captureSession isRunning]) {
        dispatch_async([self globalQueue], ^{
            [self.captureSession startRunning];
        });
    }
}

- (void)stopSession
{
    if ([self.captureSession isRunning]) {
        dispatch_async([self globalQueue], ^{
            [self.captureSession stopRunning];
        });
    }
}

- (dispatch_queue_t)globalQueue{
    
    if (!_videoDispatchQueue) {
        _videoDispatchQueue = dispatch_queue_create("com.tapharmonic.CaptureDispatchQueue", NULL);
    }
    return _videoDispatchQueue;
}

- (void)captureStillImageWithResultHandler:(void(^_Nullable)(UIImage * _Nullable result, NSError * _Nullable error))resultHandler  capturePhoto_mode:(AVCapture_capturePhotoMode)capturePhoto_mode;
{
    if (!_countDownTimerQueue) {
        _countDownTimerQueue = dispatch_queue_create("CountDownTimerQUEUE2", DISPATCH_QUEUE_SERIAL);
        _countDownTimer = [[GCDMyTimer alloc] init];
    }
    __weak CameraController * weakself =  self;
   
    [_countDownTimer start_GCDTimerWithQueue:_countDownTimerQueue frequency:countDownTime handleBlock:^{
        
        [weakself.countDownTimer stop_GCDTimer];
        AVCaptureConnection *connection = [weakself.imageOutput connectionWithMediaType:AVMediaTypeVideo];
        if (connection.isVideoOrientationSupported) {
            connection.videoOrientation = [weakself currentVideoOrientation];
        }
        
        [weakself.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
            
            if (imageDataSampleBuffer == NULL) {
                NSLog(@"NULL sampleBuffer:%@",[error localizedDescription]);
                resultHandler(nil,nil);
                return ;
            }
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            if (self.movieWriter.activeFilter) {
                CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
                CIFilter *fiter = self.movieWriter.activeFilter;
                [fiter setValue:inputImage forKey:kCIInputImageKey];
                CIContext *context = [CIContext contextWithOptions:nil];
                CIImage *outImage = fiter.outputImage;
                CGImageRef imageRef = [context createCGImage:outImage fromRect:outImage.extent];
                image = [UIImage imageWithCGImage:imageRef];
            }
            if (capturePhoto_mode == AVCapture_capturePhotoMode_menu180 || capturePhoto_mode == AVCapture_capturePhotoMode_menu360) {
                //
                resultHandler(image,nil);
                return;
            }
            //写入图库
            [PhotoLibraryManager savePhotoWithImage:image andAssetCollectionName:@"YGCamera" withCompletion:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                resultHandler(image,error);
            }];
        }];
    }];
}

- (int)captureTime{

    return  countDownTime;
}

- (BOOL)capturingStillImage{
    
    if (_countDownTimer) {
        BOOL  countDownStatus = [_countDownTimer countDownStatus];
        if (countDownStatus == YES) {
            return  YES;
        }
    }
    return self.imageOutput.capturingStillImage;
}


- (void)startRecording
{
    if (!self.recording) {
        [self.movieWriter startWriting];
        self.recording = YES;
    }
}

- (void)stopRecording
{
    if (self.recording) {
        [self.movieWriter stopWriting];
        self.recording = NO;
    }
}


- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    [self.movieWriter processSampleBuffer:sampleBuffer];
    if (output == self.videoDataOutput) {
        
        if(self.delegate ){
            [self.delegate didCameraDataOutput:sampleBuffer];
        }
        CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CIImage *sourceImage = [CIImage imageWithCVImageBuffer:imageBuffer];
        [self.imageTarget setImage:sourceImage];
    }
}

#pragma mark -CameraControllerDelegate

- (void)assetLibraryWriteFailedWithError:(nonnull NSError *)error {
    //
    
}

- (void)deviceConfigurationFailedWithError:(nonnull NSError *)error {
    
    //
    
}

- (void)mediaCaptureFailedWithError:(nonnull NSError *)error {
    //
    
}


- (AVCaptureVideoOrientation)currentVideoOrientation{
    
    AVCaptureVideoOrientation orientation;
    switch ([UIDevice currentDevice].orientation) {

        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;

            
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
            
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return orientation;
}

- (void)didWriteMovieAtURL:(nonnull NSURL *)outputURL {
    
    [PhotoTool saveAssetFileFormWritedPath:outputURL.path];
//    [PhotoLibraryManager saveVideoWithVideoUrl:outputURL andAssetCollectionName:@"Potensic" withCompletion:^(NSURL * _Nonnull vedioUrl, NSError * _Nonnull error) {
//        //
//    }];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//parameter setting Session

//闪光灯  打开 、关闭、自动
- (void)setFlashState:(AVCaptureFlashMode)flashMode{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.hasFlash && device.flashMode != flashMode) {
        
        [device lockForConfiguration:nil];
        [device setFlashMode:flashMode];
        [device unlockForConfiguration];
        
    }
}


//白平衡  自动 晴天 阴天 荧光灯 白炽灯 白平衡模式
//- (void)whiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode{
//
//    NSError *error = nil;
//    if ([self.captureDevice lockForConfiguration:&error]) {
//        if ([self.captureDevice isWhiteBalanceModeSupported:whiteBalanceMode] ) {
//            self.captureDevice.whiteBalanceMode = whiteBalanceMode;
//        }
//        [self.captureDevice unlockForConfiguration];
//
//    } else
//    {
//        NSLog(@"设置白平衡失败");
//    }
//}

- (void)whiteBalanceMode:(AVCapture_WhiteBalance_Mode)whiteBalanceMode{
    
    
    //先获取当前的结构体值
    AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = [self.captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:AVCaptureWhiteBalanceGainsCurrent];
    /////
    NSError *error = nil;
    if ([self.captureDevice lockForConfiguration:&error]) {
        
        float temperature = 3000;
        if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_Auto) {
            temperature = 3000;
        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_Clear){
            temperature = 4000;
        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_Overcast){
            temperature = 6000;
        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_FluorescentLamp){
            temperature = 8000;
        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_IncandescentLamp){
            temperature = 9000;
        }
        AVCaptureWhiteBalanceTemperatureAndTintValues balanceTemperatureAndTintValues ;
        balanceTemperatureAndTintValues.temperature = temperature;
        balanceTemperatureAndTintValues.tint = temperatureAndTintValues.tint;
        
        AVCaptureWhiteBalanceGains deviceGains = [self.captureDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:balanceTemperatureAndTintValues];
        
        [self.captureDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:deviceGains completionHandler:^(CMTime syncTime) {
            
            NSLog(@"setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains");
        }];
        [self.captureDevice unlockForConfiguration];

    } else
    {
        NSLog(@"设置白平衡失败");
    }
}

//手动设置白平衡色温
- (void)setWhiteBalanceTemperature:(int)temperature{
    
    //先获取当前的结构体值
    AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = [self.captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:AVCaptureWhiteBalanceGainsCurrent];
    NSError *error = nil;
    if ([self.captureDevice lockForConfiguration:&error]) {
        
        AVCaptureWhiteBalanceTemperatureAndTintValues balanceTemperatureAndTintValues ;
        balanceTemperatureAndTintValues.temperature = temperature;
        balanceTemperatureAndTintValues.tint = temperatureAndTintValues.tint;
        AVCaptureWhiteBalanceGains deviceGains = [self.captureDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:balanceTemperatureAndTintValues];
        [self.captureDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:deviceGains completionHandler:^(CMTime syncTime) {
            NSLog(@"setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains");
        }];
        [self.captureDevice unlockForConfiguration];
        
    } else
    {
        NSLog(@"设置白平衡失败");
    }
}


- (float)getWhiteBalanceTemparature{
    
    AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = [self.captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:AVCaptureWhiteBalanceGainsCurrent];
    return temperatureAndTintValues.temperature;
}

//手机防抖 开关
- (void)cameraAntiShakeMode:(AVCaptureVideoStabilizationMode)sabilizationMode{

    AVCaptureConnection *captureConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([self.captureDevice.activeFormat isVideoStabilizationModeSupported:sabilizationMode] && captureConnection.preferredVideoStabilizationMode != sabilizationMode) {
        
        captureConnection.preferredVideoStabilizationMode = sabilizationMode;
    }
}


//ISO 设置  0.0 - 1.0
-(void)cameraBackgroundDidChangeISO:(CGFloat)iso{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
//        CGFloat minISO = captureDevice.activeFormat.minISO;
//        CGFloat maxISO = captureDevice.activeFormat.maxISO;
//
//
//        NSLog(@"%f------%f",minISO,maxISO);
//
//        CGFloat currentISO = (maxISO - minISO) * iso +minISO;
        [captureDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent  ISO:iso completionHandler:nil];
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"handle the error appropriately");
    }
}


//调节焦距 0.0-1.0
- (void)cameraBackgroundDidChangeFocus:(CGFloat)focus{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            [captureDevice setFocusModeLockedWithLensPosition:focus completionHandler:nil];
    }else{
        // Handle the error appropriately.
    }
}


//数码变焦  1-10倍
- (void)cameraBackgroundDidChangeZoom:(CGFloat)zoom{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        captureDevice.videoZoomFactor = zoom;
       // [captureDevice rampToVideoZoomFactor:1.0 withRate:zoom];//50
        [captureDevice unlockForConfiguration];
    }else{
        // Handle the error appropriately.
    }
}

//EV  设置   -8.0 - 8.0 曝光补偿
- (void)cameraBackgroundDidChangeEV:(CGFloat)EV{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        NSLog(@"EV >>>>>%f",EV);
        [captureDevice setExposureTargetBias:EV completionHandler:nil];
        [captureDevice unlockForConfiguration];
        
    }else{
        // Handle the error appropriately.
    }
}

//HDR 开启关闭
- (void)cameraBackgroundDidChangeHDR:(BOOL)HDR{
    
    AVCaptureDevice *captureDevice = self.captureDevice;
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        //NSLog(@"automaticallyAdjustsVideoHDREnabled >>>>>==%d",captureDevice.automaticallyAdjustsVideoHDREnabled);
        captureDevice.automaticallyAdjustsVideoHDREnabled = HDR;
        [captureDevice unlockForConfiguration];
        
    }else{
        
        //NSLog(@"22222222222");
        // Handle the error appropriately.
    }
}

//WB  设置
-(void)cameraBackgroundDidChangeWB:(CGFloat)WB{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    
    
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        float maxWhiteBalance = WB;
        float redGain =  MIN(2.0, maxWhiteBalance);
        float greenGain = MIN(2.0, maxWhiteBalance);
        float blueGain = MIN(2.0, maxWhiteBalance);
        AVCaptureWhiteBalanceGains whiteBalanceGains = {
            redGain,
            greenGain,
            blueGain
        };
        
        [captureDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:whiteBalanceGains completionHandler:nil];
    }else{
        // Handle the error appropriately.
    }
    
}

//SEC 设置 快门速度/间隔 1/2s   1/50000  1/3
- (void)cameraBackgroundDidChangeShutter_interval:(CGFloat)shutter_interval{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        CGFloat minExposureDuration = captureDevice.activeFormat.minExposureDuration.value;
        CGFloat maxExposureDuration = captureDevice.activeFormat.maxExposureDuration.value;
        NSLog(@"maxExposureDuration =%f minExposureDuration =%f  shutter_interval=%f",maxExposureDuration,minExposureDuration,shutter_interval);
//        CGFloat currentDuration = (maxExposureDuration - minExposureDuration) * shutter_interval +minExposureDuration;
        CMTime  exposureDuration = CMTimeMake(shutter_interval  , captureDevice.activeFormat.minExposureDuration.timescale);
        [captureDevice setExposureModeCustomWithDuration:exposureDuration  ISO:AVCaptureISOCurrent completionHandler:nil];
        [captureDevice unlockForConfiguration];
        
    }else{
        NSLog(@"handle the error appropriately");
    }
}

//慢动作拍摄 开启关闭
- (void)cameraBackgroundDidChangeSlowMotion:(BOOL)slowMotion{
    
    [self.captureSession stopRunning];
    CGFloat desiredFPS = (slowMotion==YES ?120.0: 30.0);
    AVCaptureDevice *videoDevice = self.captureDevice;
    AVCaptureDeviceFormat *selectedFormat = nil;
    int32_t maxWidth = 0;
    AVFrameRateRange *frameRateRange = nil;
    
    for (AVCaptureDeviceFormat *format in [videoDevice formats]) {
        
        for (AVFrameRateRange *range  in format.videoSupportedFrameRateRanges) {
            CMFormatDescriptionRef desc = format.formatDescription;
            CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
            int32_t width = dimensions.width;
            if (range.minFrameRate <= desiredFPS && desiredFPS <= range.minFrameRate) {
                selectedFormat = format;
                frameRateRange = range;
                maxWidth = width;
            }
        }
    }
    
    if (selectedFormat) {
        
        if ([videoDevice lockForConfiguration:nil]) {
            
            NSLog(@"selected format:%@",selectedFormat);
            if (slowMotion) {
                
                videoDevice.activeFormat = selectedFormat;
                videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
                videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
                
            }else{
                
                //慢动作拍摄关
                videoDevice.activeFormat = _defaultFormat;
                videoDevice.activeVideoMinFrameDuration = _defaultMinFrameDuration;
                videoDevice.activeVideoMaxFrameDuration = _defaultMaxFrameDuration;
            }
            [videoDevice unlockForConfiguration];
        }
    }
    [self.captureSession startRunning];
}


//延时摄影   减小帧间隔录像  类比运动相机一帧持续时间
- (void)cameraBackgroundDidChangeDelayedPhotography:(CGFloat)videoFramePerDuration{
    
    [self.captureSession stopRunning];
    CGFloat desiredFPS = 1.0/videoFramePerDuration;
    AVCaptureDevice *videoDevice = self.captureDevice;
    AVCaptureDeviceFormat *selectedFormat = nil;
    int32_t maxWidth = 0;
    AVFrameRateRange *frameRateRange = nil;
    for (AVCaptureDeviceFormat *format in [videoDevice formats]) {
        
        for (AVFrameRateRange *range  in format.videoSupportedFrameRateRanges) {
            CMFormatDescriptionRef desc = format.formatDescription;
            CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
            int32_t width = dimensions.width;
            if (range.minFrameRate <= desiredFPS && desiredFPS <= range.minFrameRate) {
                selectedFormat = format;
                frameRateRange = range;
                maxWidth = width;
            }
        }
    }
    
    if (selectedFormat) {
        
        if ([videoDevice lockForConfiguration:nil]) {
            
            //NSLog(@"selected format:%@",selectedFormat);
            videoDevice.activeFormat = selectedFormat;
            videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            [videoDevice unlockForConfiguration];
        }
    }
    [self.captureSession startRunning];
}

//拍照定时   3s 5s 10s   做法倒计时
-(void) cameraBackgroundDidChangeCountDownTimer:(int)time{
    countDownTime = time;
}

//设置分辨率  帧率
- (void)cameraBackgroundDidChangeVideoQuality:(AVCaptureSessionPreset)videoQuality desiredFPS:(CGFloat)desiredFPS{
    
    [self.captureSession stopRunning];
    self.captureSession.sessionPreset = videoQuality;
    AVCaptureDevice *videoDevice = self.captureDevice;
    AVCaptureDeviceFormat *selectedFormat = nil;
    int32_t maxWidth = 0;
    AVFrameRateRange *frameRateRange = nil;
    for (AVCaptureDeviceFormat *format in [videoDevice formats]) {
        for (AVFrameRateRange *range  in format.videoSupportedFrameRateRanges) {
            CMFormatDescriptionRef desc = format.formatDescription;
            CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
            int32_t width = dimensions.width;
            if (range.minFrameRate <= desiredFPS && desiredFPS <= range.minFrameRate) {
                selectedFormat = format;
                frameRateRange = range;
                maxWidth = width;
            }
        }
    }
    
    if (selectedFormat) {
        
        if ([videoDevice lockForConfiguration:nil]) {
            NSLog(@"selected format:%@",selectedFormat);
            videoDevice.activeFormat = selectedFormat;
            videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            [videoDevice unlockForConfiguration];
        }
    }
    [self.captureSession startRunning];
}

//parameter getting Session

//当前焦距
- (CGFloat)getDeviceFocus{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    return captureDevice.lensPosition;
}

//是否防抖
- (BOOL)isSabilizationMode{
    
    AVCaptureConnection *captureConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    return captureConnection.preferredVideoStabilizationMode!=AVCaptureVideoStabilizationModeOff;
}

//HDR 状态
- (BOOL)isHDROpen{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    return captureDevice.automaticallyAdjustsVideoHDREnabled;
}

//数码变焦缩放级别
- (CGFloat)getDeviceZoom{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    return captureDevice.videoZoomFactor;
}

//分辨率
- (AVCaptureSessionPreset)getVideoQuality{
    
    return self.captureSession.sessionPreset;
    
}

//EV值
- (CGFloat)getDeviceEV{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
   
    return captureDevice.exposureTargetBias;
}

//WB
- (CGFloat)getDeviceWB{
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    
    
//    NSLog(@">>>>>>>>>%f",captureDevice.maxWhiteBalanceGain);
    return captureDevice.deviceWhiteBalanceGains.blueGain;
}

//ISO值
- (CGFloat)getDeviceISO{
    
    
    AVCaptureDevice *captureDevice = self.activeVideoInput.device;
    //NSLog(@">>>>>>>>>>>>>+++%f",captureDevice.ISO);
    CGFloat minISO = captureDevice.activeFormat.minISO;//22
    CGFloat maxISO = captureDevice.activeFormat.maxISO;//880
   // NSLog(@"%f------%f",minISO,maxISO);
    CGFloat currentISO = captureDevice.ISO +minISO;
    
    return currentISO;
}


//AVCaptureFlashModeOff  = 0,
//AVCaptureFlashModeOn   = 1,
//AVCaptureFlashModeAuto = 2
//闪光灯状态
- (AVCaptureFlashMode)getDeviceFlashState{
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    
    if (captureDevice.flashMode == AVCaptureFlashModeOn) {
        return 0;
    }else if (captureDevice.flashMode == AVCaptureFlashModeOff){
        return 1;
    }else if (captureDevice.flashMode == AVCaptureFlashModeAuto){
        return 2;
    }
    return captureDevice.flashMode;
}

//白平衡模式
- (AVCaptureWhiteBalanceMode)getDeviceBalanceMode{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    return captureDevice.whiteBalanceMode;
}


//SEC  快门值
- (CGFloat)getDeviceSEC{
    
    //activeFormat.minExposureDuration and activeFormat.maxExposureDuration
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    
//    CGFloat minExposureDuration = captureDevice.activeFormat.minExposureDuration.value/captureDevice.activeFormat.minExposureDuration.timescale;
//
//    CGFloat maxExposureDuration = captureDevice.activeFormat.maxExposureDuration.value/captureDevice.activeFormat.maxExposureDuration.timescale;
//
//    NSLog(@"captureDevice.activeFormat.maxExposureDuration.timescale =%d",captureDevice.activeFormat.maxExposureDuration.timescale);
//    CGFloat minExposureDuration = CMTimeGetSeconds(captureDevice.activeFormat.minExposureDuration) ;
//    CGFloat maxExposureDuration = CMTimeGetSeconds(captureDevice.activeFormat.maxExposureDuration);
    
    CGFloat currentDuration = CMTimeGetSeconds(captureDevice.exposureDuration) ;
    NSLog(@"currentDuration ==%.3f",CMTimeGetSeconds(captureDevice.exposureDuration));

//    NSLog(@"%lld--- %lld",captureDevice.activeFormat.maxExposureDuration.value,captureDevice.activeFormat.minExposureDuration.value);
 //   NSLog(@"maxExposureDuration =%f minExposureDuration =%f  currentDuration =%f",maxExposureDuration,minExposureDuration,captureDevice.exposureDuration.value * captureDevice.exposureDuration.timescale);
    return currentDuration;
}

//是否慢动作
- (BOOL)isSlowMode{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    return captureDevice.activeVideoMinFrameDuration.value == 240;
    
}

//延时摄影
- (CGFloat)getVideoFramePerDuration{
    
    AVCaptureDevice *captureDevice = [self.activeVideoInput device];
    return captureDevice.activeVideoMaxFrameDuration.value;
}

//获取拍照延时时长
- (int)getCaptureDuration{
    if (countDownTime == 0) {
        return 0;
    }else if (countDownTime == 3){
        return 1;
    }else if (countDownTime == 5){
        return 2;
    }else if (countDownTime == 10){
        return 3;
    }
    return 0;
    //return countDownTime;
}


- (BOOL)switchCameras {
    
    if (![self canSwitchCameras]) {                                         // 1
        return NO;
    }
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];                   // 2
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        
        [self.captureSession beginConfiguration];                           // 3
        [self.captureSession removeInput:self.activeVideoInput];            // 4
        if ([self.captureSession canAddInput:videoInput]) {                 // 5
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        } else {
            [self.captureSession addInput:self.activeVideoInput];
        }
        [self.captureSession commitConfiguration];                          // 6
        
    } else {
        [self.delegate deviceConfigurationFailedWithError:error];           // 7
        return NO;
    }
    
    return YES;
}

- (AVCaptureDevice *)activeCamera {                                         // 3
    return self.activeVideoInput.device;
}


- (AVCaptureDevice *)inactiveCamera {                                       // 4
    
    AVCaptureDevice *device = nil;
    if (self.cameraCount > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {  // 5
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

- (BOOL)canSwitchCameras {// 6
    return self.cameraCount > 1;
}

- (NSUInteger)cameraCount {                                                 // 7
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

#pragma mark - Device Configuration

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position { // 1
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {                              // 2
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}



//WB 色调  (-150  150)

- (void)setTintWB:(CGFloat)tint{
    
    NSError *error = nil;
    if ([self.captureDevice lockForConfiguration:&error]) {
        
        AVCaptureWhiteBalanceTemperatureAndTintValues values = [self.captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:self.captureDevice.deviceWhiteBalanceGains];
        
        float incandescentLightCompensation = values.temperature;
        AVCaptureWhiteBalanceTemperatureAndTintValues balanceTemperatureAndTintValues ;
        balanceTemperatureAndTintValues.temperature = incandescentLightCompensation;
        balanceTemperatureAndTintValues.tint = tint;
        
        AVCaptureWhiteBalanceGains deviceGains = [self.captureDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:balanceTemperatureAndTintValues];
        
        [self.captureDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:deviceGains completionHandler:^(CMTime syncTime) {
            
            NSLog(@"setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains");
        }];
        [self.captureDevice unlockForConfiguration];
        
    } else
    {
        NSLog(@"设置白平衡失败");
    }
}

- (CGFloat)getTintWB{
    
    AVCaptureWhiteBalanceTemperatureAndTintValues values = [self.captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:self.captureDevice.deviceWhiteBalanceGains];
    
    return values.tint;
}


//AVCaptureDevice *device = [self.controller activeDevice];
//AVCaptureWhiteBalanceTemperatureAndTintValues values = [device temperatureAndTintValuesForDeviceWhiteBalanceGains:device.deviceWhiteBalanceGains];
//
//NSLog(@"temperature=%f---tint == %f",values.temperature,values.tint);//-150,-150;
//NSLog(@"maxWhiteBalanceGain ==%f",[self.controller activeDevice].maxWhiteBalanceGain);




@end
