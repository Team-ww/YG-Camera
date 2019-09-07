//
//  GalleryEditEditView.h
//  SelFly
//
//  Created by wenhh on 2017/11/14.
//  Copyright © 2017年 AEE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FilterModel){
    FilterModel_Brightness,
    FilterModel_Contranst,
    FilterModel_Saturation,
    FilterModel_Exposure,
    FilterModel_Sharpen,
    FilterModel_Hue,
};

typedef void(^sliderChangeValueBlock)(CGFloat ContranstValue,CGFloat BrightnessValue,CGFloat SaturationValue,CGFloat ExposureValue,CGFloat SharpenValue,CGFloat HueValue,NSInteger changeState);

@interface GalleryEditEditView : UIView

@property (copy,nonatomic) sliderChangeValueBlock sliderValueBlock;

- (void)refreshEditView;
@end
