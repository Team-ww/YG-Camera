//
//  GalleryEditEditView.m
//  SelFly
//
//  Created by wenhh on 2017/11/14.
//  Copyright © 2017年 AEE. All rights reserved.
//

#import "GalleryEditEditView.h"
//#import "constants.h"

@interface GalleryEditEditView ()
{
    //当前亮度,对比度等值
    CGFloat _ContranstValue,_BrightnessValue,_SaturationValue,_ExposureValue,_SharpenValue,_HueValue;
    //已保存的上一个的亮度,对比度等值
    CGFloat _lastContranstValue,_lastBrightnessValue,_lastSaturationValue,_lastExposureValue,_lastSharpenValue,_lastHueValue;
}
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@property (weak, nonatomic) IBOutlet UILabel *editValueLab;
@property (weak, nonatomic) IBOutlet UISlider *editSlider;
@property (strong, nonatomic) UIButton *oldBtn;
@property (weak, nonatomic) IBOutlet UIButton *contranstBtn;
@property (nonatomic) FilterModel filterModer;
@property (nonatomic) FilterModel currentFilter;//上一个滤镜

@end

@implementation GalleryEditEditView

- (void)awakeFromNib {
    [super awakeFromNib];
     [self.editSlider addTarget:self action:@selector(editSliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshEditView {
    if (!self.oldBtn) {
        self.filterModer = FilterModel_Contranst;
        _ContranstValue = 10000;
        _BrightnessValue = 10000;
        _SaturationValue = 10000;
        _ExposureValue= 10000;
        _SharpenValue = 10000;
        _HueValue = 10000;
        _lastContranstValue = 10000;
        _lastBrightnessValue = 10000;
        _lastSaturationValue = 10000;
        _lastExposureValue= 10000;
        _lastSharpenValue = 10000;
        _lastHueValue = 10000;
        _ContranstValue = 1.0;
        _BrightnessValue = 0.0;
        _SaturationValue = 1.0;
        _ExposureValue=0.0;
        _SharpenValue = 0.0;
        _HueValue = 0.0;
    }
    [self ContranstFilterBtnAction:self.contranstBtn];
    self.selectImageView.image = [UIImage imageNamed:@"gallery_contrast_nor"];
}

- (void)setContrls:(UIImage *)img ValueLab:(CGFloat)value Max:(CGFloat)maxValue mini:(CGFloat)miniValue{
    self.selectImageView.image = img;
    self.editValueLab.text = [NSString stringWithFormat:@"%.1f",value];
    [self.editSlider setMaximumValue:maxValue];
    [self.editSlider setMinimumValue:miniValue];
    [self.editSlider setValue:value];
    
}

//亮度
- (IBAction)BrightnessFilterBtnAction:(UIButton *)sender {

    sender.selected = YES;
    if (self.oldBtn != sender)self.oldBtn.selected = NO;
    self.oldBtn = sender;
    if (_BrightnessValue == 10000) {
       [self setContrls:sender.imageView.image ValueLab:0 Max:0.5f mini:-0.5f];
    }else [self setContrls:sender.imageView.image ValueLab:_BrightnessValue Max:0.5f mini:-0.5f];
    self.filterModer = FilterModel_Brightness;

}
//对比度
- (IBAction)ContranstFilterBtnAction:(UIButton *)sender {
    sender.selected = YES;
    if (self.oldBtn != sender)self.oldBtn.selected = NO;
    self.oldBtn = sender;
    if (_ContranstValue == 10000) {
        [self setContrls:sender.imageView.image ValueLab:1.0 Max:4.0f mini:0.0f];
    }else [self setContrls:sender.imageView.image ValueLab:_ContranstValue Max:4.0f mini:0.0f];
    
    self.filterModer = FilterModel_Contranst;
}

//饱和度
- (IBAction)SaturationFilterBtnAction:(UIButton *)sender {
    sender.selected = YES;
    if (self.oldBtn != sender)self.oldBtn.selected = NO;
    self.oldBtn = sender;
    if (_SaturationValue == 10000) {
        [self setContrls:sender.imageView.image ValueLab:1.0 Max:2.0f mini:0.0f];
    }else   [self setContrls:sender.imageView.image ValueLab:_SaturationValue Max:2.0f mini:0.0f];
  
    self.filterModer = FilterModel_Saturation;
}

//曝光
- (IBAction)ExposureFilterBtnAction:(UIButton *)sender {
    sender.selected = YES;
    if (self.oldBtn != sender)self.oldBtn.selected = NO;
    self.oldBtn = sender;
    if (_ExposureValue == 10000) {
        [self setContrls:sender.imageView.image ValueLab:0 Max:1.0f mini:-1.0f];
    }else [self setContrls:sender.imageView.image ValueLab:_ExposureValue Max:1.0f mini:-1.0f];
    self.filterModer = FilterModel_Exposure;
}

////锐化
- (IBAction)SharpenFilterBtnAction:(UIButton *)sender {
    sender.selected = YES;
    if (self.oldBtn != sender)self.oldBtn.selected = NO;
    self.oldBtn = sender;
    if (_SharpenValue == 10000) {
        [self setContrls:sender.imageView.image ValueLab:0 Max:4.0f mini:-4.0f];
    }else [self setContrls:sender.imageView.image ValueLab:_SharpenValue Max:4.0f mini:-4.0f];
    self.filterModer = FilterModel_Sharpen;
}
//GPUImageHueFilter 色度
- (IBAction)HueFilterBtnAction:(UIButton *)sender {
    sender.selected = YES;
    if (self.oldBtn != sender)self.oldBtn.selected = NO;
    self.oldBtn = sender;
    if (_HueValue == 10000) {
        [self setContrls:sender.imageView.image ValueLab:0 Max:10.0f mini:-10.0f];
    }else  [self setContrls:sender.imageView.image ValueLab:_HueValue Max:10 mini:-10];
    self.filterModer = FilterModel_Hue;
}

- (IBAction)cancelEditBtnAction:(UIButton *)sender {
    
    _ContranstValue = _lastContranstValue;
    _BrightnessValue = _lastBrightnessValue;
    _SaturationValue = _lastSaturationValue;
    _ExposureValue= _lastExposureValue;
    _SharpenValue = _lastSharpenValue;
    _HueValue = _lastHueValue;
    self.sliderValueBlock(_lastContranstValue, _lastBrightnessValue, _lastSaturationValue, _lastExposureValue, _lastSharpenValue, _lastHueValue, 0);
    [UIView animateWithDuration:0.3f animations:^{
          self.frame = CGRectMake(0,self.superview.frame.size.height, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
   
}

- (IBAction)confirmEditBtnAction:(UIButton *)sender {
    _lastContranstValue = _ContranstValue;
    _lastBrightnessValue = _BrightnessValue;
    _lastSaturationValue = _SaturationValue;
    _lastExposureValue= _ExposureValue;
    _lastSharpenValue = _SharpenValue;
    _lastHueValue = _HueValue;
    self.sliderValueBlock(_ContranstValue, _BrightnessValue, _SaturationValue, _ExposureValue, _SharpenValue, _HueValue, 2);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0,self.superview.frame.size.height, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)changeSliderValueAction:(UISlider *)sender {
    self.editValueLab.text = [NSString stringWithFormat:@"%.1f",sender.value];
    [self changeValue:self.filterModer values:sender.value];
}

- (void)editSliderTouchUpInSide:(UISlider *)sender{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.sliderValueBlock(_ContranstValue, _BrightnessValue, _SaturationValue, _ExposureValue, _SharpenValue, _HueValue, 1);
    });
}

- (void)changeValue:(FilterModel)filters values:(CGFloat)sliderValue {

    switch (filters) {
        case FilterModel_Brightness:
            _BrightnessValue =sliderValue;
            break;
            
        case FilterModel_Contranst:
            _ContranstValue = sliderValue;
            break;
            
        case FilterModel_Saturation:
            _SaturationValue = sliderValue;
            break;
            
        case FilterModel_Exposure:
            _ExposureValue = sliderValue;
            break;
            
        case FilterModel_Sharpen:
            _SharpenValue = sliderValue;
            break;
            
        case FilterModel_Hue:
            _HueValue = sliderValue;
            break;
        default:
            break;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
