//
//  PreviewVC.h
//  YGCamera
//
//  Created by chen hua on 2019/4/8.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

#import "SliderValueView.h"
#import "CaptureRightView.h"
#import "BLEControlManager.h"
#import "BLEPlatformStatus.h"
#import "BLEControlManager.h"
#import "BLESendData.h"
#import "BottomParametersView.h"
#import "UIBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AVCapture_GridMode) {
    
    AVCapture_GridMode_NO       = 0,  //无
    AVCapture_GridMode_Nine      = 1, //九宫格
    AVCapture_GridMode_Diagonal   = 2, //对角线 九宫格
};

typedef NS_ENUM(NSInteger, AVCapture_ZoomSpeedMode) {
    
    AVCapture_ZoomSpeed_1       = 0,  //慢
    AVCapture_ZoomSpeed_2      = 1, //中等
    AVCapture_ZoomSpeed_3   = 2, //快
};

@interface PreviewVC : UIBaseVC

@property (nonatomic,strong)  GPUImageStillCamera   *controller;
@property(strong,nonatomic)   GPUImageView *myGPUImageView;
@property (weak, nonatomic) IBOutlet UISlider *myslider;
@property (weak, nonatomic) IBOutlet SliderValueView *sliderView;
@property (weak, nonatomic) IBOutlet CaptureRightView *captureRightView;
@property (assign,nonatomic)NSInteger timIndex;
@property (assign,nonatomic)AVCapture_WhiteBalance_Mode whiteBalance_mode;
@property (assign,nonatomic)AVCapture_ScreenMode   screenMode;
@property (assign,nonatomic)AVCapture_FilterMode   filterMode;
@property (weak,  nonatomic)IBOutlet UIView *functionView;
@property (assign, nonatomic)AVCapture_GridMode gridMode;
@property (strong, nonatomic)IBOutlet BottomParametersView *bottomParametersView;
@property (assign, nonatomic)AVCapture_ZoomSpeedMode speedMode;

@property (nonatomic,assign)BOOL isStillCapture;


//
//NSInteger index_Filter;
- (AVCapture_capturePhotoMode)getCurrentPhotoMode;

- (void)setPhotoMode:(AVCapture_capturePhotoMode)photoMode;

- (AVCapture_videoMode)getCurrentVideoMode;

- (void)setVideoMode:(AVCapture_videoMode)videoMode;

- (void)setFilterWithIndex:(NSInteger)filterIndex;


@end

NS_ASSUME_NONNULL_END
