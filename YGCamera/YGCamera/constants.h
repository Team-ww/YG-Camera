//
//  constants.h
//  SelFly
//
//  Created by wenhh on 2017/8/4.
//  Copyright © 2017年 AEE. All rights reserved.
//

#ifndef constants_h
#define constants_h

#define WInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

//获取屏幕高度
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height
//获取屏幕宽度
#define KMainScreenWidth [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define KScreenHeight [UIScreen mainScreen].bounds.size.height/480
//获取屏幕宽度
#define KScreenWidth [UIScreen mainScreen].bounds.size.width/320
//获取屏幕高度4.7寸
#define KScreenHeight_6 [UIScreen mainScreen].bounds.size.height/667
//获取屏幕宽度4.7寸
#define KScreenWidth_6 [UIScreen mainScreen].bounds.size.width/375
//获取一个视图的宽度
#define KViewWidth(a) (a).frame.size.width
//高度
#define KViewHeigth(a) (a).frame.size.height
//x坐标
#define KViewX(a) (a).frame.origin.x
//y坐标
#define KViewY(a) (a).frame.origin.y

#pragma mark - 相机相册与本地相册
enum LibraryPathType{
    LibraryPathType_Iphone = 0,
    LibraryPathType_Selfly = 1,
};

// 拍照的状态
typedef NS_ENUM(NSInteger, TakePhotoStatus) {
    TakePhoto_noBegine,
    TakePhoto_taking,
    TakePhoto_timeOut,
    TakePhoto_finished
};

// 选择照片的type 类型
typedef NS_ENUM(NSInteger, PhotoType) {
    Photo_Normal,
    Photo_Burst,
    Photo_Interval,
    Photo_noPhotoType
};

typedef NS_ENUM(NSInteger, ImageEditState) {
    ImageEditState_NO,
    ImageEditState_IsEdited,
    ImageEditState_IsSkin,
    ImageEditState_isFilters,
    ImageEditState_Connect
};

typedef enum : int {
    
    FlyCalibrateStatu_waitting = 0,//指南针等待校准指令
    FlyCalibrateStatu_startAction = 1,//指南针开始执行校准指令
    FlyCalibrateStatu_calibrating = 2,//指南针校准中
    FlyCalibrateStatu_Complete = 3,//指南针校准完成

} FlyCalibrateStatu;

typedef enum : int {
    FlyAccelerometerStatu_waitting = 0,//等待加速度计校准指令
    FlyAccelerometerStatu_finishStep1 = 1,//
    FlyAccelerometerStatu_finishStep2 = 2,//
    FlyAccelerometerStatu_finishStep3 = 3,//
    FlyAccelerometerStatu_finishStep4 = 4,//
    FlyAccelerometerStatu_finishStep5 = 5,//
    FlyAccelerometerStatu_Complete = 6,//加速度计校准完成
    FlyAccelerometerStatu_calibrating = 7,//加速度计校准中
} FlyAccelerometerStatu;

#endif /* constants_h */
