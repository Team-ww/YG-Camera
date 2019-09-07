//
//  PreviewVC.m
//  YGCamera
//
//  Created by chen hua on 2019/4/8.
//  Copyright © 2019 Chenhua. All rights reserved.
//
#import "PreviewVC.h"
#import "Utils.h"
#include <iostream>
#import <GBTrack/GBTrack.h>
#import "TopLeftView.h"
#import "PhotosDetailVC.h"
#import "PhotoTool.h"
#import "WZBCountDownButton.h"
#import "HJTAnimationView.h"
#import "UIView+LSCore.h"
#import "BottomCollectionViewCell.h"
//#import "UIImage+OpenCV.h"
#import "PhotoLibraryManager.h"
#import "GPUMyBeautyFilter.h"
#import "VideoPhotoView.h"
#import "RecordTimeView.h"
#import "PHAsset+YGAsset.h"
#import "LibThumbView.h"
#import "ACCameraSetPreViewViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "constants.h"
#import "GCDMyTimer.h"
#import "ACCameraMoveViewController.h"
#import "ACCameraAirViewController.h"
#import "ACCameraRockerViewController.h"
#import "ACCameraSetPreViewViewController.h"
#import "ACCameraStaticViewController.h"
#import "ACCameraAreaSettingViewController.h"
#import "ACCameraSettingViewController.h"
#import "ACCameraSTViewController.h"
#import "ACPhotoViewController.h"
#import "ACVideoEditorViewController.h"
//#import "PhotoNav.h"
#import "ROVAUIMessageTools.h"
#import "DeviceMationManager.h"
#import "BTGCDTimer.h"
#import "CVWrapper.h"
#import "WWRootViewController.h"
#import "AppDelegate.h"

@interface PreviewVC ()<BLEControlManagerDelegate,XZRTrackControlDategate,GPUImageVideoCameraDelegate,ACCameraSetPreViewViewControllerDelegate,ACCameraMoveViewControllerDelegate,ACCameraStaticViewControllerDelegate,ACCameraAreaSettingViewControllerDelegate,ACCameraAirViewControllerDelegate,ACCameraRockerViewControllerDelegate,ACCameraSTViewControllerrDelegate,DeviceMationManagerDelegate>{
    
    BOOL isPhotoType;
    BOOL isGrid_On;
    AVCapture_capturePhotoMode capturePhoto_mode;
    AVCapture_videoMode  captureVideo_mode;
    BOOL is_duijiao_zoom;
    CGFloat  duijiao_zoom_value;
    CGFloat  bianjiao_zoom_value;
    dispatch_queue_t trackQueue;
    XZRTrack *track;
    BOOL isTracking;
    NSMutableArray *parameter_Arr;
    GPUImageMovieWriter *movieWriter;
    BOOL isReocrd;
    NSInteger deviceCurrectNumber;//设备当前方向
    BOOL isPresentPhotoView;
    DeviceDirection deviceCurrectDirection;//当前设备的方向
    BOOL isPanoramaCapture;
}

@property(strong,nonatomic)  GPUImageFilter *filter;
@property (weak, nonatomic)  IBOutlet TopLeftView *topBarView;
@property (weak, nonatomic)  IBOutlet UIButton *captureButton_compoent;
@property (weak, nonatomic)  IBOutlet UIButton *cameraSwitch_button;
@property (weak, nonatomic)  IBOutlet UIButton *ygSettingAButton;
@property (weak, nonatomic)  IBOutlet UIButton *ygSettingBButton;

@property (weak, nonatomic)  IBOutlet UIButton *followButton;
@property (strong, nonatomic) NSTimer *updateDevicetimer;

@property (strong, nonatomic) BLEPlatformStatus *platformStatus;
@property (weak, nonatomic) IBOutlet UIView *platformView;
@property (weak, nonatomic) IBOutlet UIButton *platformButton;
@property (weak, nonatomic) IBOutlet UIView *left_flashView;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *beautyButton;

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic)   IBOutlet UIView *leftBackView;
@property (weak, nonatomic)   IBOutlet UIView *rightBackView;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) NSMutableArray *panoramaImage_Arr;
@property(copy,nonatomic)     NSArray *filterArr;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderValueView_Constraint;
@property (weak, nonatomic) IBOutlet VideoPhotoView *photo_video_view;
@property (weak, nonatomic) IBOutlet RecordTimeView *recordTimeView;
@property (weak, nonatomic) IBOutlet LibThumbView *libThumbView;

//@property (weak, nonatomic) IBOutlet UIView *leftTransformView;
@property (nonatomic,strong)ACCameraSetPreViewViewController *setPreViewVC;
@property(nonatomic,strong)GCDMyTimer *countDownTimer;
@property(nonatomic,strong)ACCameraMoveViewController *moveVC;
@property(nonatomic,strong)ACCameraStaticViewController *staticVC;
@property(nonatomic,strong)ACCameraAreaSettingViewController *settingVC;
@property(nonatomic,strong)ACCameraSettingViewController *cameraSetVC;

@property (weak,   nonatomic) IBOutlet UIView *leftTransformView;
@property (strong, nonatomic) IBOutlet UIView *scaleSliderView;
@property (nonatomic, strong) DeviceMationManager *mationManager;
@property(nonatomic,  strong) BTGCDTimer      *heartTimer;
@property(nonatomic,  readwrite)dispatch_queue_t heartbeatQueue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tempViewHeight;

@end

@implementation PreviewVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置当前屏幕方向
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 1;
    
    deviceCurrectDirection = DeviceDirectionPortrait;
   // self.myslider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.myslider setThumbImage:[UIImage imageNamed:@"sliderImage"]forState:UIControlStateNormal];
    isPhotoType = YES;
    [self updateVideoAndPhotoView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CameraFunction_Notify:)
                                                 name:@"CameraFunction_Notify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self startUpdateDeviceTimer];
}

- (void)applicationEnterForeground:(NSNotification *)nitification {
    //设备当前方向初始化
    deviceCurrectNumber = [self getDeviceOrientationNumberWithCurrentOrientation:[UIDevice currentDevice].orientation];
    //旋转view方向
    [self setViewTranformWithRota:(deviceCurrectNumber - 2) deviceNum:deviceCurrectNumber];
}


#pragma mark 旋转方向判断
- (void)setViewTranformWithRota:(NSInteger)value deviceNum:(NSInteger)deviceNum{
    
    //NSLog(@"=====>value = %ld start = %ld end = %ld",value,deviceCurrectNumber,deviceNum);
    if (_setPreViewVC){
        [self transformWithVC:_setPreViewVC rota:value deviceNum:deviceNum];
    }
    if (_cameraSetVC) {
        [self transformWithVC:_cameraSetVC rota:value deviceNum:deviceNum];
    }
    if (_moveVC) {
        [self transformWithVC:_moveVC rota:value deviceNum:deviceNum];
    }
    if (_staticVC) {
        [self transformWithVC:_staticVC rota:value deviceNum:deviceNum];
    }
    if (_settingVC) {
        [self transformWithVC:_settingVC rota:value deviceNum:deviceNum];
    }else{
        [self transformWithVC:nil rota:value deviceNum:deviceNum];
    }
}

//实时监听手机屏幕方向
- (void)directionChange:(DeviceDirection)direction {
    
    
    //    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    NSLog(@"====> currect device dir is %ld",direction);
    deviceCurrectDirection = direction;
    NSInteger getDeviceNumber = [self getDeviceOrientationNumberWithCurrentOrientation:direction];
    NSInteger value = getDeviceNumber - deviceCurrectNumber;
    [self setViewTranformWithRota:value deviceNum:getDeviceNumber];
}

#pragma mark 自定义判断手机旋转角度
- (NSInteger)getDeviceOrientationNumberWithCurrentOrientation:(NSInteger)orientation {
    
    NSInteger number = 0;
    switch (orientation) {
        case 1:
            number = 1;
            break;
        case 4:
            number = 4;
            break;
        case 3:
            number = 3;
            break;
        case 2:
            number = 2;
            break;
        default:
            number = 1;
            break;
    }
    
    return number;
}

- (void)setCameraConfig{
    
    if (self.controller) {
        [self.controller startCameraCapture];
        self.controller.delegate = self;
        return;
    }
    self.controller = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.controller.frameRate = 30;
    //竖屏方向UIInterfaceOrientationMaskLandscapeRight
    self.controller.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
    self.controller.delegate = self;
    GPUImageFilter *normalFilter = [[GPUImageFilter alloc] init];
    
    if ([Utils isiphoneX]) {
        self.tempViewHeight.constant = 44;
    }else{
        self.tempViewHeight.constant = 0;
    }
    
    self.myGPUImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, MAX(ScreenW, ScreenH), MIN(ScreenW, ScreenH))];
    self.myGPUImageView.fillMode =  kGPUImageFillModeStretch;
    [self.controller addTarget:normalFilter];
    [normalFilter addTarget:self.myGPUImageView];
    _filter = normalFilter;
    [self.functionView addSubview:self.myGPUImageView];
    [self.functionView sendSubviewToBack:self.myGPUImageView];
    [self.controller startCameraCapture];
    isPhotoType = YES;
    [self.captureButton_compoent setImage:[UIImage imageNamed:isPhotoType?@"homePhoto_normal":@"homeVideo_noramal"] forState:UIControlStateNormal];
    self.leftBackView.alpha = 1;
    self.rightBackView.alpha = 1;
    NSArray *flash_imageArr = @[@"statusFlash1LampClose",@"statusFlash1LampOpen",@"statusFlash1LampAuto"];
    [self.flashButton setImage:[UIImage imageNamed:flash_imageArr[[self.controller getDeviceFlashState]]] forState:UIControlStateNormal];
    self.platformStatus = [[BLEPlatformStatus alloc]init];
    is_duijiao_zoom = NO;
    bianjiao_zoom_value = 1;
    duijiao_zoom_value = 1;
    [[BLEControlManager sharedInstance] setDelegate:self];
    [self.captureButton_compoent setImage:[UIImage imageNamed:isPhotoType?@"homePhoto_normal":@"homeVideo_noramal"] forState:UIControlStateNormal];
    
    [self connectResult:[[BLEControlManager sharedInstance] checkConnectStatus]];
    [self.functionView bringSubviewToFront:self.photo_video_view];
    [self configSlider];
    
    self.bottomParametersView.frame = CGRectMake((MAX(ScreenW, ScreenH) -60*6)/2, MIN(ScreenW, ScreenH) - 45, 60 *6, 35);
    [self.view addSubview:self.bottomParametersView];
//    self.sliderView.hidden = YES;
    [self.captureRightView showHDRView:self.controller.isHDROpen timingImageHidden:YES timIndex:0];
    
    self.scaleSliderView.bounds = CGRectMake(0, 0, 120, 31);
    self.scaleSliderView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight)/2, MIN(KMainScreenWidth, KMainScreenHeight) - 35);
    [self.view addSubview:self.scaleSliderView];
    
    self.sliderView.frame = CGRectMake(0, 30, 30, 26);
    [self.scaleSliderView addSubview:self.sliderView];
    self.sliderView.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    if ([Utils isiphoneX]) {
        
        self.topBarView.center = CGPointMake(40 + 48 + 10 + 15, MIN(KMainScreenWidth, KMainScreenHeight) - 95);
        self.topBarView.bounds = CGRectMake(0, 0, 150, 30);
        [self.view addSubview:self.topBarView];
        
        self.captureRightView.center = CGPointMake(40 + 48 + 10 + 15, 50);
        self.captureRightView.bounds = CGRectMake(0, 0, 60, 30);
        [self.view addSubview:self.captureRightView];
        
    }else{
        
        self.topBarView.center = CGPointMake(48 + 10 + 15, MIN(KMainScreenWidth, KMainScreenHeight) - 95);
        self.topBarView.bounds = CGRectMake(0, 0, 150, 30);
        [self.view addSubview:self.topBarView];
        self.captureRightView.center = CGPointMake(48 + 10 + 15, 50);
        self.captureRightView.bounds = CGRectMake(0, 0, 60, 30);
        [self.view addSubview:self.captureRightView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mationManager = [[DeviceMationManager alloc] init];
    self.mationManager.delegate = self;
    [self.mationManager startMonitor];
    isPresentPhotoView = NO;
    [self setCameraConfig];
    if (!track) {
        //初始化track模块，ImageSize为摄像头获得的实际图像大小，ParentView为用于显示图像的view
        track = [[XZRTrack alloc] initImageSize:self.imageSize WithParentView:self.myGPUImageView];
        track.delegate = self;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.mationManager stop];
}

-(CGSize)imageSize{
    
     CMVideoDimensions videoDiMensions = CMVideoFormatDescriptionGetDimensions([[[self.controller activeDevice] activeFormat] formatDescription]);
     return CGSizeMake(videoDiMensions.width, videoDiMensions.height);
}

- (IBAction)backClick:(UIButton *)sender {

    [self updateConfigWhenBackOrPush];
    [BLEControlManager sharedInstance].delegate = nil;
    track.delegate = nil;
    [self stopUpdateDeviceInfo];
    [self  dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)beauty_click:(UIButton *)sender {
    
    if ([_filter isKindOfClass:[GPUMyBeautyFilter class]]) {
        
        _filterMode = AVCapture_FilterMode_NormalFilter;
        GPUImageFilter *normalFilter = [[GPUImageFilter alloc] init];
        [self.controller removeAllTargets];
        [self.controller addTarget:normalFilter];
        [normalFilter addTarget:self.myGPUImageView];
        _filter = normalFilter;
        [self.beautyButton setImage:[UIImage imageNamed:@"nvBeautyIcon_no"] forState:UIControlStateNormal];
        self.myGPUImageView.layer.transform = CATransform3DMakeRotation(0, 1.0, 0.0, 0.0);
        
    }else{
        
        _filterMode = AVCapture_FilterMode_BeautyFilter;
        GPUMyBeautyFilter *beautyFielter = [[GPUMyBeautyFilter alloc] init];
        [self.controller removeAllTargets];
        [self.controller addTarget:beautyFielter];
        [beautyFielter addTarget:self.myGPUImageView];
        _filter = (GPUImageFilter *)beautyFielter;
        [sender setImage:[UIImage imageNamed:@"nvBeautyIcon_yes"] forState:UIControlStateNormal];
        if ([self.controller cameraPosition] == AVCaptureDevicePositionFront) {
            self.myGPUImageView.layer.transform = CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0);
        }else{
            self.myGPUImageView.layer.transform = CATransform3DMakeRotation(0, 1.0, 0.0, 0.0);
        }
    }
}

- (void)updateConfigWhenBackOrPush{
    
    if (isTracking) {
        [self follow_me_click:self.followButton];
    }
    
    if (isReocrd) {
        [self.recordTimeView stopRecord];
        [self stopRecord];
    }
    [self.controller stopCameraCapture];
    self.controller.delegate = nil;
    [self stopUpdateDeviceInfo];
}



- (void)capture_panoramaImage{
    if (_isStillCapture) {
        return;
    }
    _isStillCapture = YES;
    __weak PreviewVC *weakSelf = self;
    [self.controller capturePhotoAsPNGProcessedUpToFilter:self.filter  withCompletionHandler:^(NSData *processedPNG, NSError *error) {
        
        if (!weakSelf.panoramaImage_Arr) {
            weakSelf.panoramaImage_Arr = [NSMutableArray array];;
        }
        UIImage *image =  [UIImage imageWithData:processedPNG];
        image = [weakSelf reduceImage:image percent:0.35];
        
        //        CGSize size = image.size;
        //        image = [weakSelf imageWithImageSimple:image scaledToSize:CGSizeMake(size.width *0.6,size.height *0.6)];
        [weakSelf.panoramaImage_Arr addObject:image];
        NSData *data = [BLESendData sendPlatformIndex:weakSelf.panoramaImage_Arr.count platformMode:weakSelf.platformStatus.panoramaType];
        [[BLEControlManager sharedInstance] sendDataToBLE:data];
        weakSelf.isStillCapture = NO;
    }];
}

- (void)panoramaImageFromImageArr{
    
    if (isPanoramaCapture == YES ) return;
    if (!(self->_panoramaImage_Arr != nil &&_panoramaImage_Arr.count!= 0)) {
        return;
    }
    isPanoramaCapture = YES;
    //显示正在合成全景
    //NSLog(@"123");
    [self showProgressHUDWithMessage:@"正在合成全景图片"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image =   [CVWrapper processWithArray:self->_panoramaImage_Arr];
        if (image ) {
            //显示全景合成成功
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showProgressHUDNotice:@"全景合成成功" showTime:1.5];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showProgressHUDNotice:@"全景合成失败" showTime:1.5];
            });
        }
        
        NSLog(@"image==>>>>>>%@",image);
        if (image) {
            //写入图库
            [PhotoLibraryManager savePhotoWithImage:image andAssetCollectionName:@"YGCamera" withCompletion:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
                NSLog(@"写入图库:::%@",error);
                [self.libThumbView updateThumImage];
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //保存到相册
            [self->_panoramaImage_Arr removeAllObjects];
            self->_panoramaImage_Arr = nil;
            self.captureButton_compoent.enabled = YES;
            self->isPanoramaCapture = NO;
        });
        
    });

    
}

//压缩图片质量
-(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//摄像头切换
- (IBAction)camera_switch_click:(UIButton *)sender {
    
    [self.controller switchCameras];
    if ([self.controller cameraPosition] == AVCaptureDevicePositionFront) {
        
        self.controller.frameRate = 30;
        self.controller.horizontallyMirrorFrontFacingCamera = YES;
        self.controller.horizontallyMirrorRearFacingCamera = NO;
        self.myslider.hidden = YES;
        self.sliderView.hidden = YES;
        if ([_filter isKindOfClass:[GPUMyBeautyFilter class]]) {
            self.myGPUImageView.layer.transform = CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0);
        }else{
            self.myGPUImageView.layer.transform = CATransform3DMakeRotation(0, 1.0, 0.0, 0.0);
        }
        
    }else{
        
        self.myslider.hidden = NO;
        //self.sliderView.hidden = NO;
        self.myGPUImageView.layer.transform = CATransform3DMakeRotation(0, 1.0, 0.0, 0.0);
    }

}

- (IBAction)show_settingClick:(UIButton *)sender {
    
    if (self.setPreViewVC) return;
    self.setPreViewVC = [[UIStoryboard storyboardWithName:@"ACCameraSetPreViewViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"SetPreView_ID"];
    self.setPreViewVC.index = (isPhotoType?1:2);
    self.setPreViewVC.view.frame = CGRectMake(0, 0, MIN(KMainScreenWidth, KMainScreenHeight) * 0.85, 141);
    self.setPreViewVC.view.layer.cornerRadius = 10;
    self.setPreViewVC.view.layer.masksToBounds = YES;
    self.setPreViewVC.delegate = self;
    self.setPreViewVC.topScrollIndex = 0;
    self.setPreViewVC.bottomScrollIndex = 0;
//  self.setPreViewVC.setDetailModel
    [self presentPopupViewController:self.setPreViewVC animationType:MJPopupViewAnimationFade];
//  self.setPreViewVC = nil;
    self.setPreViewVC = (ACCameraSetPreViewViewController *)self.mj_popupViewController;
    //设备当前方向初始化
    deviceCurrectNumber = [self getDeviceOrientationNumberWithCurrentOrientation:[UIDevice currentDevice].orientation];
    //旋转view方向
    [self setViewTranformWithRota:(deviceCurrectNumber - 2) deviceNum:deviceCurrectNumber];
}

- (IBAction)YGAPP_Setting:(UIButton *)sender {
    
    //摄像机设置
    [self presentPopupViewController:self.cameraSetVC animationType:MJPopupViewAnimationFade];
    //设备当前方向初始化
    deviceCurrectNumber = [self getDeviceOrientationNumberWithCurrentOrientation:[UIDevice currentDevice].orientation];
    //旋转view方向
    [self setViewTranformWithRota:(deviceCurrectNumber - 2) deviceNum:deviceCurrectNumber];
}

- (void)startUpdateDeviceTimer{
    
    [self.updateDevicetimer invalidate];
    self.updateDevicetimer = [NSTimer timerWithTimeInterval:5
                                         target:self
                                       selector:@selector(startUpdateDeviceInfo)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.updateDevicetimer forMode:NSRunLoopCommonModes];
    [self.updateDevicetimer fire];
}

- (void)startUpdateDeviceInfo{
    
    [self.topBarView UpdateDeviceInfo];
}

- (void)stopUpdateDeviceInfo {
    
    [self.updateDevicetimer invalidate];
    self.updateDevicetimer = nil;
}

#pragma mark- BLEControlManagerDelegate

- (void)updatePlatformStateWithCMD:(uint8_t)cmd playloadData:(NSData *)data{
    
    
    
    //图库出来，云台按键在手机端不做任何响应
    if (isPresentPhotoView == YES) {
        return;
    }
    //全景合成的时候 其他按键不响应
    if (isPanoramaCapture == YES &&  cmd == 0xA0) return;
    
    
    if (cmd == 0xA3) {
        
        [self.platformStatus getBatteryInfoWithData:data];
        self.topBarView.equipBatteryLab.text = [NSString stringWithFormat:@"%d%%",self.platformStatus.batteryValue];
        
    }else if (cmd == 0xA0){
        
        [self.platformStatus updateKeyAndActionTypeCommandWithData:data completionBlock:^(BLE_KeyType_Command keyTye, BLE_KeyActionType_Command action) {
            
            if (BLE_KeyActionType_Command_SHORT_KEY_ACTION == action && BLE_KeyType_Command_PHOTO_KEY == keyTye) {
                
                [self blePhotoClick];
                
            }else if (BLE_KeyActionType_Command_SHORT_KEY_ACTION == action && BLE_KeyType_Command_RECORD_KEY == keyTye){
                
                [self bleVideoClick];

            }else if (BLE_KeyActionType_Command_SHORT_KEY_ACTION == action && BLE_KeyType_Command_FLASH_KEY == keyTye){
                
                //闪光灯
                [self updateFlash];
                
            }else if (BLE_KeyActionType_Command_SHORT_KEY_ACTION == action && BLE_KeyType_Command_EXPOSURE_KEY == keyTye){
                // cameraBackgroundDidChangeEV
                
            }else if (BLE_KeyActionType_Command_SHORT_KEY_ACTION == action && BLE_KeyType_Command_FOCUS_KEY == keyTye){
                //对焦
                
            }else if (BLE_KeyActionType_Command_SHORT_KEY_ACTION == action && BLE_KeyType_Command_PLAYBACK_KEY == keyTye){
                //相册
                [self libraryButtonClick:nil];
                
            }else if (BLE_KeyActionType_Command_SHORT_KEY_ACTION == action && BLE_KeyType_Command_LENS_KEY == keyTye){
                //切换摄像头按钮
                [self camera_switch_click:nil];
                
            }else if (BLE_KeyActionType_Command_SHORT_KEY_ACTION == action && BLE_KeyType_Command_RESOUL_KEY == keyTye){
                //开启分辨率
               // [self addresolution_videoView];
                
            }else if (BLE_KeyActionType_Command_SHORT_KEY_ACTION == action && BLE_KeyType_Command_MENU_KEY == keyTye){
                
                if (self.setPreViewVC) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationPopViewDismiss" object:nil];
                }
                else{
                    [self show_settingClick:nil];
                }
            }
            
        }];
        
    }else if (cmd == 0xAC){
        //updateZoomOrFocusWithData
        [self.platformStatus updateZoomOrFocusWithData:data completionBlock:^(uint8_t value) {
            self->is_duijiao_zoom = value;
        }];
        
    }else if (cmd == 0xA1){
        
        [self forcusclick:data];//变焦 或者点击
        
    }else if (cmd == 0xB4){
      
        //全景模式下序列号下发
        NSInteger indexAngle =  [self.platformStatus getIndexParameterData:data];
        NSLog(@"indexAngle======%ld   %@",(long)indexAngle,[NSThread currentThread]);
        if (indexAngle <255) {
            
            if (self->_panoramaImage_Arr.count != indexAngle) {
                [self capture_panoramaImage];
            }else{
                NSData *data = [BLESendData sendPlatformIndex:indexAngle platformMode:self.platformStatus.panoramaType];
                    [[BLEControlManager sharedInstance] sendDataToBLE:data];
            }
//            NSData *data = [BLESendData sendPlatformIndex:indexAngle platformMode:self.platformStatus.panoramaType];
//            [[BLEControlManager sharedInstance] sendDataToBLE:data];
        }else{
            //全景拍摄完成进行合成
            [self panoramaImageFromImageArr];
        }

    }else if (cmd == 0xB6){
        //获取云台遥感数据
        [self.platformStatus getPlatform_ParametersWithData:data];
    }
    
    else if (cmd == 0xB7){
        //设置云台参数回复
        [self.platformStatus getSetParameterData:data];
    }
    
    else{
        NSLog(@"cmd == %d",cmd);
    }
}

- (void)blePhotoClick{
    
    if (self.setPreViewVC &&![self.setPreViewVC isSecondMenuIsshow]) {
        //菜单栏存在且点击
        //进入二级菜单 滑动
        SelectedModel *model = [[SelectedModel alloc] init];
        model.topIndex = self.setPreViewVC.topScrollIndex;
        if (isPhotoType) {
            
            NSInteger currentIndex = self.setPreViewVC.topScrollIndex;
            if (currentIndex == 0) {
                self.setPreViewVC.bottomScrollIndex = self.getCurrentPhotoMode;
            }else if (currentIndex ==1 ){
                self.setPreViewVC.bottomScrollIndex = self.filterMode;
            }else if (currentIndex == 2){
                self.setPreViewVC.bottomScrollIndex = self.timIndex;
            }else if (currentIndex == 3){
                self.setPreViewVC.bottomScrollIndex = self.controller.isHDROpen?0:1;
            }else if (currentIndex == 4){
                self.setPreViewVC.bottomScrollIndex = self.whiteBalance_mode;
            }
        }else{
            NSInteger currentIndex = self.setPreViewVC.topScrollIndex;
            if (currentIndex == 0) {
                self.setPreViewVC.bottomScrollIndex = self.getCurrentVideoMode;
            }else if (currentIndex ==1 ){
                self.setPreViewVC.bottomScrollIndex = self.filterMode;
            }else if (currentIndex == 2){
                self.setPreViewVC.bottomScrollIndex = self.timIndex;
            }else if (currentIndex == 3){
                self.setPreViewVC.bottomScrollIndex = self.controller.isHDROpen?0:1;
            }else if (currentIndex == 4){
                self.setPreViewVC.bottomScrollIndex = self.whiteBalance_mode;
            }else if (currentIndex == 5){
                self.setPreViewVC.bottomScrollIndex = self.screenMode;
            }
        }
        
        model.bottomIndex = self.setPreViewVC.bottomScrollIndex;
        [self.setPreViewVC scrollViewWithIndex:self.setPreViewVC.topScrollIndex selectedModel:model];
        
    }else if (self.setPreViewVC &&[self.setPreViewVC isSecondMenuIsshow]){
        //这个时候不做任何其他处理
        
    }else{
        
        //拍照模式
        [self switchToPhotoMode:nil];
        [self capture_button_Click:nil];
    }
}

- (void)bleVideoClick{
    
    [self switchToVideoMode:nil];
    if (self->captureVideo_mode == AVCapture_videoMode_slowModel) {
        //如果是慢动作的话，处理上
        [self.controller cameraBackgroundDidChangeSlowMotion:YES];
    }else if (self->captureVideo_mode == AVCapture_videoMode_trackTime){
        
    }else if (self->captureVideo_mode == AVCapture_videoMode_xqkk){
        
    }else
        if (!self->isReocrd) {
            [self startRecord];
            [self.recordTimeView startRecord];
        } else {
            [self.recordTimeView stopRecord];
            [self stopRecord];
        }
}

- (void)updateFlash{
    
    AVCaptureFlashMode mode = [self.controller getDeviceFlashState];
    if (mode == AVCaptureFlashModeOff) {
        [self.controller setFlashState:AVCaptureFlashModeOn];;
    }else if (mode == AVCaptureFlashModeOn){
        [self.controller setFlashState:AVCaptureFlashModeAuto];
    }else{
        [self.controller setFlashState:AVCaptureFlashModeOff];
    }
    NSArray *flash_imageArr = @[@"statusFlashLamp1Close",@"statusFlash1LampOpen",@"statusFlashLampAuto"];
    [self.flashButton setImage:[UIImage imageNamed:flash_imageArr[[self.controller getDeviceFlashState]]] forState:UIControlStateNormal];
}

- (void)connectResult:(BOOL )isuccess{
    
    if (isuccess) {
        
       [self.topBarView.bluetoothImageview setImage:[UIImage imageNamed:@"statusBluetoothIconPre"]];
    }else{
       [self.topBarView.bluetoothImageview setImage:[UIImage imageNamed:@"statusBluetoothIcon"]];
    }
}

- (IBAction)backViewClick:(UITapGestureRecognizer *)sender {
    //dismiss
    [self.backView removeFromSuperview];
}

- (void)forcusclick:(NSData *)data{
    
    
    [self.platformStatus updateKeyMessageWithData:data completionBlock:^(uint16_t codeType1, int16_t rotationType1) {
        //  //负值代表逆时针旋转，正值代表顺时针旋转。
        if (codeType1 == 1) {
     
            if (self->is_duijiao_zoom) {
                [self changeValue_duijiao:rotationType1 > 0?YES:NO];
                [self.controller cameraBackgroundDidChangeFocus:self->duijiao_zoom_value];
            }else{
                [self changeValue_bianjiao:rotationType1 > 0?YES:NO];
                [self.controller cameraBackgroundDidChangeZoom:self->bianjiao_zoom_value];
            }
            
        }else if (codeType1 == 2){
            
            if (self.setPreViewVC && [self.setPreViewVC isSecondMenuIsshow]) {
                
                [self levelMenu2Set:rotationType1<0?YES:NO];
                //进入二级菜单 滑动
                SelectedModel *model = [[SelectedModel alloc] init];
                model.topIndex = self.setPreViewVC.topScrollIndex;
                model.bottomIndex = self.setPreViewVC.bottomScrollIndex;
                [self.setPreViewVC scrollViewWithIndex:self.setPreViewVC.topScrollIndex selectedModel:model];
            }else{
                
                //NSLog(@"rotationType1 =%d",rotationType1);
                [self levelMenu1Set:rotationType1<0?YES:NO];
                [self.setPreViewVC scrollViewWithIndex:self.setPreViewVC.topScrollIndex selectedModel:nil];
            }
        }
    }];
}

- (void)levelMenu2Set:(BOOL)isFront{
    
    NSInteger  maxValue = [self.setPreViewVC getMaxIndexWithTopIndex:self.setPreViewVC.topScrollIndex];
    if (isFront) {
        self.setPreViewVC.bottomScrollIndex++;
        if (self.setPreViewVC.bottomScrollIndex > maxValue-1) {
           self.setPreViewVC.bottomScrollIndex = 0;
        }
    }else{
        self.setPreViewVC.bottomScrollIndex--;
        if (self.setPreViewVC.bottomScrollIndex < 0) {
            self.setPreViewVC.bottomScrollIndex = maxValue-1;
        }
    }
}

- (void)levelMenu1Set:(BOOL)isFront{
    
    NSInteger maxValue = isPhotoType?4:5;
    if (isFront) {
        self.setPreViewVC.topScrollIndex++;

        if (self.setPreViewVC.topScrollIndex > maxValue) {
            self.setPreViewVC.topScrollIndex = 0;
        }
    }else{
        self.setPreViewVC.topScrollIndex--;
        if (self.setPreViewVC.topScrollIndex < 0) {
            self.setPreViewVC.topScrollIndex = maxValue;
        }
    }
}

- (void)changeValue_duijiao:(BOOL)isbigger{
    if (isbigger) {
        duijiao_zoom_value += 0.1;
        if (duijiao_zoom_value >= 1) {
            duijiao_zoom_value = 1;
        }
    }else{
        duijiao_zoom_value -= 0.1;
        if (duijiao_zoom_value <=0 ) {
            duijiao_zoom_value = 0;
        }
    }
}

- (void)changeValue_bianjiao:(BOOL)isbigger{
    
    CGFloat margin = 0.5;
    if (self.speedMode == AVCapture_ZoomSpeed_1) {
        margin = 0.3;
    }else if (self.speedMode == AVCapture_ZoomSpeed_2){
        margin = 0.5;
    }else if (self.speedMode ==AVCapture_ZoomSpeed_3 ){
        margin = 0.7;
    }
    if (isbigger) {
        
        bianjiao_zoom_value += margin;
        if (bianjiao_zoom_value >= [self.controller activeDevice].activeFormat.videoMaxZoomFactor) {
            bianjiao_zoom_value = [self.controller activeDevice].activeFormat.videoMaxZoomFactor;
        }
    }else{
        bianjiao_zoom_value -= margin;
        if (bianjiao_zoom_value <= 1 ) {
            bianjiao_zoom_value = 1;
        }
    }
    [self.myslider setValue:bianjiao_zoom_value];
    //NSLog(@"bianjiao_zoom_value ===%f",bianjiao_zoom_value);
}

//拍照倒计时
- (void)addCountDownAnimation{
    
    NSMutableArray *imageNames = [NSMutableArray array];
    NSArray *timeArr = @[@(0),@(3),@(5),@(10)];
    for (NSInteger i = [timeArr[self.timIndex] intValue]; i > 0; i--) {
        [imageNames addObject:[NSString stringWithFormat:@"number%zd", i]];
    }
    // Do any additional setup after loading the view, typically from a nib.
    [WZBCountDownButton playWithImages:imageNames begin:^(WZBCountDownButton *button) {
        NSLog(@"倒计时开始");
    } success:^(WZBCountDownButton *button) {
        NSLog(@"倒计时结束");
    }];
}

- (IBAction)show_platform_click:(UIButton *)sender {
    [self showPlatforms_AnimationView];
}

- (void)showPlatforms_AnimationView{
    
    NSArray *titleArr = @[@"全跟随",@"左右跟随",@"三轴固定"];
    NSArray *picarray = @[@"follow_all_platform",@"leftRightFollow_platform",@"Three axis fixation_platform"];
    HJTAnimationView *animationView = [[HJTAnimationView alloc]initWithTitleArray:titleArr picarray:picarray pointY:_platformView.center.y isLeft:YES margin:CGRectGetMaxX(_leftBackView.frame) selectIndex:0];
    [animationView.largeView addRoundedCorners: UIRectCornerBottomRight | UIRectCornerTopRight   withRadii:CGSizeMake(30, 30)];
    [animationView selectedWithIndex:^(NSInteger index) {
//        if (![[BLEControlManager sharedInstance] checkConnectStatus]) {
//            return ;
//        }
        self->_platformButton.hidden = NO;
        [self->_platformButton setImage:[UIImage imageNamed:picarray[index-1]] forState:UIControlStateNormal];
        if (index == 1) {
            [[BLEControlManager sharedInstance] sendDataToBLE:[BLESendData sendPhone_Platform_Mode:BLE_Control_Platform_FullFollowIngMode]];
        }else if (index == 2){
            [[BLEControlManager sharedInstance] sendDataToBLE:[BLESendData sendPhone_Platform_Mode:BLE_Control_Platform_FollowIngMode]];
        }else if (index == 3){
            [[BLEControlManager sharedInstance] sendDataToBLE:[BLESendData sendPhone_Platform_Mode:BLE_Control_Platform_LockMode]];
        }
    }];
    [animationView show];
    //设备当前方向初始化
    deviceCurrectNumber = [self getDeviceOrientationNumberWithCurrentOrientation:[UIDevice currentDevice].orientation];
    //旋转view方向
    [self setViewTranformWithRota:(deviceCurrectNumber - 2) deviceNum:deviceCurrectNumber];
}

- (IBAction)left_flashClick:(UIButton *)sender {
    
    [self showFlash_AnimationView];
}

- (void)showFlash_AnimationView{
    
    NSArray *titleArr = @[@"关闭",@"打开",@"自动"];
    NSArray *picarray = @[@"statusFlashLampClose",@"statusFlashLampOpen",@"statusFlashLampAuto"];
    HJTAnimationView *animationView = [[HJTAnimationView alloc]initWithTitleArray:titleArr picarray:picarray pointY:_left_flashView.center.y isLeft:YES margin:CGRectGetMaxX(_leftBackView.frame) selectIndex:[self.controller getDeviceFlashState]];
    [animationView.largeView addRoundedCorners:UIRectCornerBottomRight | UIRectCornerTopRight   withRadii:CGSizeMake(30, 30)];
    [animationView selectedWithIndex:^(NSInteger index) {
        [self setFlashStateAndImage:index - 1];
    }];
    [animationView show];
    
    //设备当前方向初始化
    deviceCurrectNumber = [self getDeviceOrientationNumberWithCurrentOrientation:[UIDevice currentDevice].orientation];
    //旋转view方向
    [self setViewTranformWithRota:(deviceCurrectNumber - 2) deviceNum:deviceCurrectNumber];
}

- (void)setFlashStateAndImage:(NSInteger)selectIndex{
    NSArray *flash_imageArr = @[@"statusFlash1LampClose",@"statusFlash1LampOpen",@"statusFlash1LampAuto"];
    [self.flashButton setImage:[UIImage imageNamed:flash_imageArr[selectIndex]] forState:UIControlStateNormal];
    [self.controller setFlashState:(AVCaptureFlashMode)selectIndex];
}

#pragma mark  -  拍照录像执行功能区//////////////////////////////////////////////////////
- (void)startRecord{
    
    self.photo_video_view.hidden = YES;
    NSURL *movieURL = [Utils outputURL];
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:[self imageSize]];
    movieWriter.frameRate = self.controller.frameRate;
    movieWriter.encodingLiveVideo = YES;
    movieWriter.shouldPassthroughAudio = YES;
    [_filter addTarget:movieWriter];
    self.controller.audioEncodingTarget = movieWriter;
    [movieWriter startRecording];
    isReocrd = YES;
}

- (void)stopRecord{
    self.photo_video_view.hidden = NO;
    self.controller.audioEncodingTarget = nil;
    
    
    [movieWriter finishRecordingWithCompletionHandler:^{
//        [PhotoTool saveAssetFileFormWritedPath:[Utils outputURL].path];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSString *str = self->movieWriter.assetWriter.outputURL.path;
            [PhotoTool saveAssetFileFormWritedPath:str];
            [self.libThumbView updateThumImage];
        });
    }];
    [_filter removeTarget:movieWriter];
    isReocrd = NO;
}

//拍照
- (void)capturePhoto{
    
    if (_isStillCapture) {
        return;
    }
    _isStillCapture = YES;
    if (!_countDownTimer) {
        _countDownTimer = [[GCDMyTimer alloc] init];
    }
    [self addCountDownAnimation];
    __weak PreviewVC * weakself =  self;
    NSArray *timeArr = @[@(0),@(3),@(5),@(10)];
    [_countDownTimer start_GCDTimerWithQueue:dispatch_get_main_queue() frequency:[timeArr[self.timIndex] intValue] handleBlock:^{
        
        [weakself.countDownTimer stop_GCDTimer];
        [weakself.controller capturePhotoAsPNGProcessedUpToFilter:weakself.filter  withCompletionHandler:^(NSData *processedPNG, NSError *error) {
            [weakself.libThumbView updateCapturePhoto:processedPNG];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.captureButton_compoent.enabled = YES;
                self->_isStillCapture = NO;
            });
        }];
    }];

}


- (IBAction)libraryButtonClick:(UIButton *)sender {
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray: [PhotoTool fetchResultWithType:CameraSource_HandleType_Collection]];
    NSMutableArray *_localImageArr = [arr[1] mutableCopy];
    NSArray *tempArr = _localImageArr[0];
    if (tempArr.count<= 0) {
        [ROVAUIMessageTools showAlertVCWithTitle:@"暂无图片或者视频" message:nil alertActionTitle:@"好的" showInVc:self];
        return;
    }else{
        [self updateConfigWhenBackOrPush];
        [self showLibraryImage:tempArr];
    }
}

- (void)showLibraryImage:(NSArray *)tempArr{
    

    
    
    PHAsset *asset =  tempArr [0];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        
        ACPhotoViewController *photoVC = [[UIStoryboard storyboardWithName:@"ACPhotoViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoVC_ID"];
        photoVC.imageAsset = asset;
        [photoVC deleteImageViewWithBlock:^(PHAsset *imageAsset) {
            
            [self.libThumbView updateThumImage];
            //图片更新
            //                [self.localImageArr removeObject:photoVC.imageAsset];
            //                [collectionView reloadData];
        }];
        
        isPresentPhotoView = YES;
        [self presentViewController:[[WWRootViewController alloc] initWithRootViewController:photoVC] animated:YES completion:nil];
      //  [self.navigationController pushViewController:photoVC animated:YES];
        
        
    }else{
        
        ACVideoEditorViewController *editorVC = [[UIStoryboard storyboardWithName:@"ACVideoEditorViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoEditor_ID"];
        editorVC.videoAsset = asset;
        //刷新
        [editorVC selectedVideoWithBlock:^{
            //图片更新
            
            [self.libThumbView updateThumImage];
        }];
        
        isPresentPhotoView = YES;
        [self presentViewController:[[WWRootViewController alloc] initWithRootViewController:editorVC] animated:YES completion:nil];
      //  [self.navigationController pushViewController:editorVC animated:YES];
        
    }
}

- (IBAction)switchToVideoMode:(UIButton *)sender {
    
    if (!isPhotoType) return;
    isPhotoType = NO;
    [self updateVideoAndPhotoView];
}

- (IBAction)switchToPhotoMode:(UIButton *)sender {
    
    if (isPhotoType) return;
    isPhotoType = YES;
    [self updateVideoAndPhotoView];
}

- (void)updateVideoAndPhotoView{
    
    self.recordTimeView.hidden = YES;
    [self.photo_video_view updateVideoAndPhotoView:isPhotoType];
    [self.captureButton_compoent setImage:[UIImage imageNamed:isPhotoType?@"homePhoto_normal":@"homeVideo_noramal"] forState:UIControlStateNormal];
}

//拍照录像
- (IBAction)capture_button_Click:(UIButton *)sender {
    
    if (isPhotoType) {
        sender.enabled = NO;
        //如果是全景拍照的话
        if (self->capturePhoto_mode == AVCapture_capturePhotoMode_menu180 || self->capturePhoto_mode == AVCapture_capturePhotoMode_menu360) {
            
            NSData *data = [BLESendData sendPlatformMode:(BLE_PanoramaType)self->capturePhoto_mode];
            [[BLEControlManager sharedInstance] sendDataToBLE:data];
            return ;
        }
        [self capturePhoto];
        
    }else{
        if (!isReocrd) {
            [self startRecord];
            [self.recordTimeView startRecord];
        } else {
            [self.recordTimeView stopRecord];
            [self stopRecord];
        }
    }
}

#pragma mark - 滑动变焦/对焦//////////////////////////////////////////////////////

- (IBAction)slider_click:(UISlider *)sender {
    
    self.sliderView.sliderValue.text = [NSString stringWithFormat:@"%d",(int)self.myslider.value];
    
    //设置slider位置
    self.sliderView.center = CGPointMake(sender.value/self.myslider.maximumValue * 120, 40);

   // self.sliderValueView_Constraint.constant =  - (sender.value - 0.5) *sender.frame.size.height/2;
    bianjiao_zoom_value =sender.value;
    [self.controller cameraBackgroundDidChangeZoom:bianjiao_zoom_value];
    [self.bottomParametersView.collectionView  reloadData];
}

- (void)configSlider{
    
    self.myslider.maximumValue = [self.controller maxVideoZoomFactor];
    self.myslider.minimumValue = 1;
    self.myslider.value = [self.controller getDeviceZoom];
    self.sliderView.sliderValue.text = [NSString stringWithFormat:@"%d",(int)self.myslider.value];
   // self.sliderValueView_Constraint.constant =  - ((self.myslider.value - 1)/(self.myslider.maximumValue - 1) - 0.5) *self.myslider.frame.size.height/2;
}

#pragma mark - 跟踪//////////////////////////////////////////////////////

-(void)lostTarget{
    
    
}

/**
 track模块处理完成之后的回调
 @param yaw yaw值，用于控制
 @param pitch pitch值，用于控制
 */
-(void)didTrackControlYaw:(int8_t)yaw AndPitch:(int8_t)pitch{
    
    NSLog(@"track模块::::::%d------%d",yaw,pitch);
    [self ctrlYaw:yaw AndPitch:pitch];
}

-(void)ctrlYaw:(int8_t)yaw AndPitch:(int8_t)pitch{
    //yaw : -128~127
    Byte bytes[]  = {0x01,0x00,0x00,0x00,0x01,0x00};
    bytes[1] = pitch;
    bytes[5] = yaw;
    NSData *data = [BLESendData packDataWithCmd:0xA5 AndData:[NSData dataWithBytes:bytes length:sizeof(bytes)]];
    [[BLEControlManager sharedInstance] sendDataToBLE:data];
}

- (void)startTrack{
    
    if (!track) {
        //NSLog(@"self.imageSize.width%f------self.imageSize.height ==%f",self.imageSize.width,self.imageSize.height);
        //初始化track模块，ImageSize为摄像头获得的实际图像大小，ParentView为用于显示图像的view
        track = [[XZRTrack alloc] initImageSize:self.imageSize WithParentView:self.myGPUImageView];
        // track = [[XZRTrack alloc] initImageSize:self.imageSize WithParentView:_functionView];
        track.delegate = self;
    }
    [self ctrlYaw:0 AndPitch:0];
    Byte bytes[]  = {0x01};
    NSData *data = [BLESendData packDataWithCmd:0xAD AndData:[NSData dataWithBytes:bytes length:sizeof(bytes)]];
    [[BLEControlManager sharedInstance] sendDataToBLE:data];
    [track startTrack];
}

- (void)stopTrack{
    
    Byte bytes[]  = {0x03};
    NSData *data = [BLESendData packDataWithCmd:0xAD AndData:[NSData dataWithBytes:bytes length:sizeof(bytes)]];
    [[BLEControlManager sharedInstance] sendDataToBLE:data];
    [track stopTrack];
}

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
    if (isTracking && track) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            //将图像传入track模块处理
            [self->track processImage:sampleBuffer];
        });
    }
}

- (IBAction)follow_me_click:(UIButton *)sender {
    
    if (!isTracking) {
        isTracking = YES;
        [sender setImage:[UIImage imageNamed:@"nvPatternIconPre"] forState:UIControlStateNormal];
        [self startTrack];
    }else{
        isTracking = NO;
        [sender setImage:[UIImage imageNamed:@"nvPatternIcon"] forState:UIControlStateNormal];
        [self stopTrack];
    }
}


#pragma  -mark  只支持横屏显示
- (BOOL)shouldAutorotate{

    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (AVCapture_capturePhotoMode)getCurrentPhotoMode{
    return capturePhoto_mode;
}

- (void)setPhotoMode:(AVCapture_capturePhotoMode)photoMode{
    capturePhoto_mode = photoMode;
    NSLog(@"capturePhoto_mode= %ld",(long)capturePhoto_mode);
}

- (AVCapture_videoMode)getCurrentVideoMode{
    return captureVideo_mode;
}

- (void)setVideoMode:(AVCapture_videoMode)videoMode{
    captureVideo_mode = videoMode;
}

- (void)setFilterWithIndex:(NSInteger)filterIndex{
    
    GPUImageFilter *normalFilter = [self getFilterWithIndex:filterIndex];
    [self.controller removeAllTargets];
    [self.controller addTarget:normalFilter];
    [normalFilter addTarget:self.myGPUImageView];
    _filter = normalFilter;
    _filterMode = (AVCapture_FilterMode)filterIndex;
    if (filterIndex == 8) {
        self.controller.runBenchmark = YES;
    }
    [self.beautyButton setImage:[UIImage imageNamed:@"nvBeautyIcon_no"] forState:UIControlStateNormal];
}

- (GPUImageFilter*)getFilterWithIndex:(NSInteger)index{
    //GPUImageSoftLightBlendFilter
    NSArray *arr = @[@"GPUImageFilter"
                     ,@"GPUImageSketchFilter",    //素描
                     @"GPUImageVignetteFilter", //晕影
                     @"GPUImageSepiaFilter",  //怀旧）
                     @"GPUImageColorInvertFilter", //负片
                     @"GPUImageGrayscaleFilter",//黑白
                     @"GPUImageCGAColorspaceFilter",
                     @"GPUImageMotionBlurFilter",
                     @"GPUImageSharpenFilter",
                     @"GPUImageSoftEleganceFilter"];
    NSString *classStr = arr[index];
    Class GPUImageFilter = NSClassFromString(classStr);
    return [[GPUImageFilter alloc] init];
}

#pragma mark - ACCameraSetPreViewViewControllerDelegate////////////////////////////////
#pragma mark 点击移动延时回调按钮代理
//移动延时
- (void)clickCancelledBtnWithViewController:(ACCameraMoveViewController *)viewController {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    _moveVC.delegate = self;
    _moveVC = nil;
}
//静态延时
- (void)clickStartButtonWithController:(UIViewController *)vc {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

//希区柯克
- (void)clickBeginBtnWithViewController:(ACCameraAreaSettingViewController *)vc {
    
    if (!_countDownTimer) {
        _countDownTimer = [[GCDMyTimer alloc] init];
    }
    [self addCountDownAnimation];
    __weak PreviewVC * weakself =  self;
    [_countDownTimer start_GCDTimerWithQueue:dispatch_get_main_queue() frequency:3 handleBlock:^{
        
        [weakself.countDownTimer stop_GCDTimer];
        [weakself setAlfredHitchcockFunction:vc];
    }];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}


- (void)setAlfredHitchcockFunction:(ACCameraAreaSettingViewController *)vc{
    CameraAreaModel *areaModel = vc.areaModel;
    float mf_st =  [[areaModel.mfArr objectAtIndex:areaModel.mf_st_index] floatValue];
    float mf_end =  [[areaModel.mfArr objectAtIndex:areaModel.mf_ed_index] floatValue];
    //调解焦距
    [self.controller cameraBackgroundDidChangeFocus:mf_st];
    //数码变焦
    float wt_st =  [[areaModel.wtArr objectAtIndex:areaModel.wt_st_index] floatValue];
    float wt_end =  [[areaModel.wtArr objectAtIndex:areaModel.wt_ed_index] floatValue];
    //调解数码
    [self.controller cameraBackgroundDidChangeZoom:wt_st];
    [self AlfredHitchcockStartVideo];
    
    if (!_heartTimer) {
        _heartTimer = [[BTGCDTimer alloc] init];
        _heartbeatQueue = dispatch_queue_create("HEARTBEATTCPQUEUE2", DISPATCH_QUEUE_SERIAL);
    }
    float margin_mf = (mf_end - mf_st)/areaModel.record_time;
    float margin_wt = (wt_end - wt_st)/areaModel.record_time;
    
    __weak PreviewVC *weakSelf = self;
    [_heartTimer start_GCDTimerWithQueue:_heartbeatQueue frequency:1 handleBlock:^{
        [self.controller cameraBackgroundDidChangeFocus:mf_st + margin_mf *[weakSelf.recordTimeView getTimCount]];
        [self.controller cameraBackgroundDidChangeZoom:wt_st + margin_wt *[weakSelf.recordTimeView getTimCount]];
        
        
        NSLog(@"mf::::%f ----    wt:::%f  margin_mf =%f     margin_wt = %f",mf_st + margin_mf,wt_st+margin_wt,margin_mf,margin_wt);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //刷新显示
            [weakSelf slider_click:weakSelf.myslider];
            if ([weakSelf.recordTimeView getTimCount] >= areaModel.record_time) {
                [weakSelf AlfredHitchcockStopVideo];
            }
        });
    }];
}

//希区柯克开始
- (void)AlfredHitchcockStartVideo{
    
    self.cameraSwitch_button.enabled = NO;
    self.libThumbView.thumbButton.enabled = NO;
    self.captureButton_compoent.enabled = NO;
    self.ygSettingAButton.enabled = NO;
    self.ygSettingBButton.enabled = NO;
    if (!isReocrd) {
        [self startRecord];
        [self.recordTimeView startRecord];
    }
}

//希区柯克关闭

- (void)AlfredHitchcockStopVideo{
    
    [_heartTimer stop_GCDTimer];
    self.cameraSwitch_button.enabled = YES;
    self.libThumbView.thumbButton.enabled = YES;
    self.captureButton_compoent.enabled = YES;
    self.ygSettingAButton.enabled = YES;
    self.ygSettingBButton.enabled = YES;
    [self.recordTimeView stopRecord];
    [self stopRecord];
}


//云台
- (void)clickButtonSaveDataWithController:(ACCameraAirViewController *)controller {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

//摇杆
- (void)rockerClickButtonSaveDateWithViewController:(ACCameraRockerViewController *)viewController {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

//设置全项
- (void)setVCDismisWithController:(ACCameraSetPreViewViewController *)viewController {
   
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    self.setPreViewVC.delegate = nil;
    self.setPreViewVC = nil;
}


#pragma mark 懒加载
- (ACCameraMoveViewController *)moveVC {
    
    if (!_moveVC) {
        _moveVC = [[UIStoryboard storyboardWithName:@"ACCameraMoveViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"CameraMove_ID"];
        CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
        _moveVC.view.frame = CGRectMake(0, 0, width * 0.8, width * 0.8);
        _moveVC.delegate = self;
        _moveVC.view.layer.cornerRadius = 10;
        _moveVC.view.layer.masksToBounds = YES;
    }
    return _moveVC;
}

- (ACCameraStaticViewController *)staticVC {
    
    if (!_staticVC) {
        _staticVC = [[UIStoryboard storyboardWithName:@"ACCameraStaticViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"CameraStatic_ID"];
        CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
        _staticVC.view.frame = CGRectMake(0, 0, width * 0.8, width * 0.8);
        _staticVC.delegate = self;
        _staticVC.view.layer.cornerRadius = 10;
        _staticVC.view.layer.masksToBounds = YES;
    }
    return _staticVC;
}

- (ACCameraAreaSettingViewController *)settingVC {
    
    if (!_settingVC) {
        _settingVC = [[UIStoryboard storyboardWithName:@"ACCameraAreaSettingViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"CameraAreaSet_ID"];
        CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
        _settingVC.view.frame = CGRectMake(0, 0, width * 0.8, width * 0.8);
        _settingVC.delegate = self;
        _settingVC.view.layer.cornerRadius = 10;
        _settingVC.view.layer.masksToBounds = YES;
    }
    return _settingVC;
}


- (ACCameraSettingViewController *)cameraSetVC {
    
    if (!_cameraSetVC) {
        _cameraSetVC = [[UIStoryboard storyboardWithName:@"ACCameraSettingViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"CameraSetting_ID"];
        CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
        _cameraSetVC.view.frame = CGRectMake(0, 0, width * 0.8, width * 0.8);
        _cameraSetVC.view.layer.cornerRadius = 10;
        _cameraSetVC.view.layer.masksToBounds = YES;
        //        __weak PreviewVC *weakSelf = self;
        ACCameraSTViewController *STVC = _cameraSetVC.childViewControllers[0];
        STVC.delegate = self;
        ACCameraAirViewController *airVC = _cameraSetVC.childViewControllers[1];
        airVC.delegate = self;
        ACCameraRockerViewController *rockerVC = _cameraSetVC.childViewControllers[2];
        rockerVC.delegate = self;
    }
    return _cameraSetVC;
}

- (void)CameraFunction_Notify:(NSNotification *)notification{
    
    NSInteger  index = [notification.object integerValue];
    //@[@"默认",@"慢动作",@"移动延时",@"静态延时",@"希区柯克"];
    if (index == 2) {
        [self  setMoveFunctionView];
    }else if (index == 3){
        [self setStaticFunctionView];
    }else if (index == 4){
        [self setAlfredHitchcockFunctionView];
    }
}

////移动延时
- (void)setMoveFunctionView{
    
    [self presentPopupViewController:self.moveVC animationType:MJPopupViewAnimationFade];
    //设备当前方向初始化
    deviceCurrectNumber = [self getDeviceOrientationNumberWithCurrentOrientation:[UIDevice currentDevice].orientation];
    //旋转view方向
    [self setViewTranformWithRota:(deviceCurrectNumber - 2) deviceNum:deviceCurrectNumber];
}

////静态延时
- (void)setStaticFunctionView{
    
     [self presentPopupViewController:self.staticVC animationType:MJPopupViewAnimationFade];
    //设备当前方向初始化
     deviceCurrectNumber = [self getDeviceOrientationNumberWithCurrentOrientation:[UIDevice currentDevice].orientation];
    //旋转view方向
     [self setViewTranformWithRota:(deviceCurrectNumber - 2) deviceNum:deviceCurrectNumber];
}

////希区柯克
- (void)setAlfredHitchcockFunctionView{
    
    [self presentPopupViewController:self.settingVC animationType:MJPopupViewAnimationFade];
    deviceCurrectNumber = [self getDeviceOrientationNumberWithCurrentOrientation:[UIDevice currentDevice].orientation];
    //旋转view方向
    [self setViewTranformWithRota:(deviceCurrectNumber - 2) deviceNum:deviceCurrectNumber];
}

- (void)transformWithVC:(UIViewController *)currectVC rota:(NSInteger)value deviceNum:(NSInteger)deviceNum{
    
    
    self.bottomParametersView.bounds = CGRectMake(0, 0,60 *6, 35 + 51);
    
    
    if (deviceNum == 1) {
        //scrollView
        self.bottomParametersView.center = CGPointMake(CGRectGetMinX(self.photo_video_view.frame) - MIN(CGRectGetHeight(self.bottomParametersView.frame), CGRectGetWidth(self.bottomParametersView.frame))/2, MIN(KMainScreenWidth, KMainScreenHeight)/2);
        self.bottomParametersView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        //slider
        self.scaleSliderView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight)/2, MIN(KMainScreenWidth, KMainScreenHeight) - 35);
        
        //topView
        if ([Utils isiphoneX]) {
            self.topBarView.center = CGPointMake(40 + 48 + 10 + 15, MIN(KMainScreenWidth, KMainScreenHeight) - 95);
            self.captureRightView.center = CGPointMake(40 + 48 + 10 + 15, 50);
        }else{
            self.topBarView.center = CGPointMake(48 + 10 + 15, MIN(KMainScreenWidth, KMainScreenHeight) - 95);
            self.captureRightView.center = CGPointMake(48 + 10 + 15, 50);
        }
        
        self.scaleSliderView.transform = CGAffineTransformMakeRotation(-M_PI);
        self.topBarView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.captureRightView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        
        //leftView旋转
        [self.leftTransformView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }];
        //rightView
        [self.rightBackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }];
        
        [[[UIApplication sharedApplication].keyWindow subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[HJTAnimationView class]]) {
                *stop = YES;
                HJTAnimationView *animationView = (HJTAnimationView *)obj;
                [animationView.largeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.transform = CGAffineTransformMakeRotation(-M_PI_2);
                }];
            }
        }];
        
        
    }else if (deviceNum == 2){
        //scrollView
        self.bottomParametersView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight)/2,MIN(KMainScreenWidth, KMainScreenHeight) - 20 - MIN(CGRectGetWidth(self.bottomParametersView.frame), CGRectGetHeight(self.bottomParametersView.frame))/2);
        self.bottomParametersView.transform = CGAffineTransformMakeRotation(0);
        
        //slider
        if ([Utils isiphoneX]) {
            
            self.scaleSliderView.center = CGPointMake(40 + 48 + 25, MIN(KMainScreenWidth, KMainScreenHeight)/2);
            self.topBarView.center = CGPointMake(40 + 48 + 85, 25);
            self.captureRightView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight) - 48 - 34 - 50, 25);
        }else{
            self.scaleSliderView.center = CGPointMake(48 + 25, MIN(KMainScreenWidth, KMainScreenHeight)/2);
            self.topBarView.center = CGPointMake(48 + 85, 25);
            self.captureRightView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight) - 48 - 50, 25);
        }
        self.scaleSliderView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.topBarView.transform = CGAffineTransformMakeRotation(0);
        self.captureRightView.transform = CGAffineTransformMakeRotation(0);
        
        //leftView旋转
        [self.leftTransformView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeRotation(0);
        }];
        //rightView
        [self.rightBackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeRotation(0);
        }];
        
        [[[UIApplication sharedApplication].keyWindow subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[HJTAnimationView class]]) {
                *stop = YES;
                HJTAnimationView *animationView = (HJTAnimationView *)obj;
                [animationView.largeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.transform = CGAffineTransformMakeRotation(0);
                }];
            }
        }];
        
        
    }else if (deviceNum == 3){
        //scrollView
        self.bottomParametersView.center = CGPointMake(CGRectGetWidth(self.leftBackView.frame) + MIN(CGRectGetWidth(self.bottomParametersView.frame), CGRectGetHeight(self.bottomParametersView.frame))/2 + 10, MIN(KMainScreenWidth, KMainScreenHeight)/2);
        self.bottomParametersView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        if ([Utils isiphoneX]) {
            
            //slider
            self.scaleSliderView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight)/2, 35);
            self.topBarView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight) - 48 - 34 - 35, 85);
            self.captureRightView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight) - 48 - 34 - 35, MIN(KMainScreenWidth, KMainScreenHeight) - 40);
            
        }else{
            
            //slider
            self.scaleSliderView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight)/2, 35);
            self.topBarView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight) - 48 - 35, 85);
            self.captureRightView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight) - 48 - 35, MIN(KMainScreenWidth, KMainScreenHeight) - 40);
        }
        
        self.scaleSliderView.transform = CGAffineTransformMakeRotation(0);
        self.topBarView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.captureRightView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        //leftView旋转
        [self.leftTransformView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
        //rightView
        [self.rightBackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
        
        [[[UIApplication sharedApplication].keyWindow subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[HJTAnimationView class]]) {
                *stop = YES;
                HJTAnimationView *animationView = (HJTAnimationView *)obj;
                [animationView.largeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.transform = CGAffineTransformMakeRotation(M_PI_2);
                }];
            }
        }];
        
    }else if (deviceNum == 4){
        //scrollView
        self.bottomParametersView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight)/2, 20 + MIN(CGRectGetWidth(self.bottomParametersView.frame), CGRectGetHeight(self.bottomParametersView.frame))/2);
        self.bottomParametersView.transform = CGAffineTransformMakeRotation(-M_PI);
        
        //slider
        if ([Utils isiphoneX]) {
            
            self.scaleSliderView.center = CGPointMake(40 + 48 + 25, MIN(KMainScreenWidth, KMainScreenHeight)/2);
            self.topBarView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight) - 48 - 34 - 95, MIN(KMainScreenWidth, KMainScreenHeight) - 25);
            self.captureRightView.center = CGPointMake(40 + 48 + 50, MIN(KMainScreenWidth, KMainScreenHeight) - 25);
            
        }else{
            self.scaleSliderView.center = CGPointMake(48 + 25, MIN(KMainScreenWidth, KMainScreenHeight)/2);
            self.topBarView.center = CGPointMake(MAX(KMainScreenWidth, KMainScreenHeight) - 48 - 95, MIN(KMainScreenWidth, KMainScreenHeight) - 25);
            self.captureRightView.center = CGPointMake(48 + 50, MIN(KMainScreenWidth, KMainScreenHeight) - 25);
        }
        
        self.scaleSliderView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.topBarView.transform = CGAffineTransformMakeRotation(-M_PI);
        self.captureRightView.transform = CGAffineTransformMakeRotation(-M_PI);
        
        //leftView旋转
        [self.leftTransformView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        //rightView
        [self.rightBackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        
        [[[UIApplication sharedApplication].keyWindow subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[HJTAnimationView class]]) {
                *stop = YES;
                HJTAnimationView *animationView = (HJTAnimationView *)obj;
                [animationView.largeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }
        }];
    }
    if (value == 1 || value == -3) {//顺时针90或者逆时针-270
        
        if (deviceNum == deviceCurrectNumber) {
            [UIView animateWithDuration:0.25 animations:^{
                currectVC.view.transform = CGAffineTransformMakeRotation( M_PI_2);
            } completion:^(BOOL finished) {
            }];
            
            return;
        }
        
        
        [UIView animateWithDuration:0.25 animations:^{
            currectVC.view.transform = CGAffineTransformRotate( currectVC.view.transform,M_PI_2);
        } completion:^(BOOL finished) {
        }];
        deviceCurrectNumber = deviceNum;
        
    }else if (value == 2 || value == -2){//顺时针180或者逆时针-180
        
        
        if (deviceNum == deviceCurrectNumber) {
            [UIView animateWithDuration:0.25 animations:^{
                currectVC.view.transform = CGAffineTransformMakeRotation(M_PI);
            } completion:^(BOOL finished) {
            }];
            
            return;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            currectVC.view.transform = CGAffineTransformRotate(currectVC.view.transform,M_PI);
        } completion:^(BOOL finished) {
        }];
        deviceCurrectNumber = deviceNum;
        
    }else if (value == 3 || value == -1){//顺时针270或者逆时针-90
        
        if (deviceNum == deviceCurrectNumber) {
            [UIView animateWithDuration:0.25 animations:^{
                currectVC.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
            } completion:^(BOOL finished) {
            }];
            
            return;
        }
        
        
        [UIView animateWithDuration:0.25 animations:^{
            currectVC.view.transform = CGAffineTransformRotate(currectVC.view.transform, -M_PI_2);
        } completion:^(BOOL finished) {
        }];
        deviceCurrectNumber = deviceNum;
    }else{
        //NSLog(@"这种情况没有考虑到 value = %ld deviceCurrectNumber = %ld  deviceNum = %ld",value,deviceCurrectNumber,deviceNum);
    }
}



@end
