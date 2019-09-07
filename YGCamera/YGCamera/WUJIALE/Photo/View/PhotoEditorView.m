//
//  PhotoEditorView.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PhotoEditorView.h"
#import "GalleryEditEditView.h"


@interface PhotoEditorView (){
    buttonDidSelectedBlock _block;
    
    //当前亮度,对比度/
    CGFloat _ContranstValue,_BrightnessValue,_SaturationValue,_ExposureValue,_SharpenValue,_HueValue;
    //已保存的上一个的亮度,对比度等值
    CGFloat _lastContranstValue,_lastBrightnessValue,_lastSaturationValue,_lastExposureValue,_lastSharpenValue,_lastHueValue;

}

@property (nonatomic) FilterModel filterModer;
@property (nonatomic) FilterModel currentFilter;//上一个滤镜


@end

@implementation PhotoEditorView

- (void)refreshEditView {
    
    self.filterModer = FilterModel_Contranst;
    _ContranstValue = 10000;//对比度
    _BrightnessValue = 10000;//亮度
    _SaturationValue = 10000;//饱和度
    _ExposureValue= 10000;//曝光
    _SharpenValue = 10000;//锐化
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

- (void)cancelEditorButton {
    
    _ContranstValue = _lastContranstValue;
    _BrightnessValue = _lastBrightnessValue;
    _SaturationValue = _lastSaturationValue;
    _ExposureValue= _lastExposureValue;
    _SharpenValue = _lastSharpenValue;
    _HueValue = _lastHueValue;
    
    if (_block) {
        _block(_lastContranstValue,_lastExposureValue,_lastSaturationValue,_lastSharpenValue,_lastBrightnessValue,_lastHueValue,0,0);
    }
}

- (void)confirmEditorButton {
    
    _lastContranstValue = _ContranstValue;
    _lastBrightnessValue = _BrightnessValue;
    _lastSaturationValue = _SaturationValue;
    _lastExposureValue= _ExposureValue;
    _lastSharpenValue = _SharpenValue;
    _lastHueValue = _HueValue;
    
    if (_block) {
        _block(_ContranstValue,_ExposureValue,_SaturationValue,_SharpenValue,_BrightnessValue,_HueValue,2,0);
    }
}


- (void)setSliderWithValue:(CGFloat)value max:(CGFloat)maxValue min:(CGFloat)minValue {
    
    self.totalLabel.text = [NSString stringWithFormat:@"%.1f",value];
    [self.slider setMaximumValue:maxValue];
    [self.slider setMinimumValue:minValue];
    [self.slider setValue:value];
    
}


- (void)changeValue:(FilterModel)filters values:(CGFloat)sliderValue {
    
    switch (filters) {
        case FilterModel_Contranst:
            _ContranstValue = sliderValue;
            break;
            
        case FilterModel_Exposure:
            _ExposureValue = sliderValue;
            break;
            
        case FilterModel_Saturation:
            _SaturationValue = sliderValue;
            break;
        
        case FilterModel_Sharpen:
            _SharpenValue = sliderValue;
            break;

        case FilterModel_Brightness:
            _BrightnessValue =sliderValue;
            break;
            
        case FilterModel_Hue:
            _HueValue = sliderValue;
            break;
        default:
            break;
    }
    
}



- (IBAction)sliderDidChanged:(UISlider *)sender {
    self.totalLabel.text = [NSString stringWithFormat:@"%.1f",sender.value];
    [self changeValue:self.filterModer values:sender.value];
}

- (IBAction)sliderTouchupInside:(UISlider *)sender {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_block) {
            self->_block(self->_ContranstValue,self->_ExposureValue,self->_SaturationValue,self->_SharpenValue,self->_BrightnessValue,self->_HueValue,1,(sender.tag/1000 - 1));
        }
    });
}



- (IBAction)clickButtonEditor:(UIButton *)sender {
    
    long tag = sender.tag / 1000;
    
    NSArray *selectedArr = @[@"compare_sel",@"expose_sel",@"satur_sel",@"three_sel",@"light_selected",@"color_sel"];
    NSArray *normalArr = @[@"compare_n",@"expose_n",@"satur_n",@"three_n",@"light_nor",@"color_n"];
    self.topLeftImageView.image = [UIImage imageNamed:selectedArr[tag-1]];
    
    [self.bottomImageViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *img = (UIImageView *)obj;
        if (tag - 1 == idx) {
            img.image = [UIImage imageNamed:selectedArr[idx]];
        }else{
            img.image = [UIImage imageNamed:normalArr[idx]];
        }
    }];
    
    [self.bottomLabel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *label = (UILabel *)obj;
        if (idx == tag - 1) {
            label.textColor = [UIColor colorWithRed:174/255.0 green:204/255.0 blue:68/255.0 alpha:1.0];
        }else{
            label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
        
    }];
    
    
    if (tag == 1) {
        
        if (_ContranstValue == 10000) {
            [self setSliderWithValue:1.0 max:4.0f min:0.0f];
        }else{
            [self setSliderWithValue:_ContranstValue max:4.0f min:0.0f];
        }
        self.filterModer = FilterModel_Contranst;
        
    }else if (tag == 2){
        
        if (_ExposureValue == 10000) {
            [self setSliderWithValue:0 max:1.0 min:-1.0];
        }else{
            [self setSliderWithValue:_SharpenValue max:1.0 min:-1.0];
        }
        self.filterModer = FilterModel_Exposure;
        
    }else if (tag == 3){
        
        if (_SaturationValue == 10000) {
            [self setSliderWithValue:1.0 max:2.0 min:0.0];
        }else{
            [self setSliderWithValue:_SaturationValue max:2.0 min:0.0];
        }
        self.filterModer = FilterModel_Saturation;
        
    }else if (tag == 4){
        
        if (_SharpenValue == 10000) {
            [self setSliderWithValue:0 max:4.0 min:-4.0];
        }else{
            [self setSliderWithValue:_SharpenValue max:4.0 min:-4.0];
        }
        self.filterModer = FilterModel_Sharpen;
        
    }else if (tag == 5){
        
        if (_BrightnessValue == 10000) {
            [self setSliderWithValue:0 max:0.5f min:-0.5f];
        }else{
            [self setSliderWithValue:_BrightnessValue max:0.5f min:-0.5f];
        }
        self.filterModer = FilterModel_Brightness;
        
    }else if (tag == 6){
        
        if (_HueValue == 10000) {
            [self setSliderWithValue:0 max:10.0 min:-10.0];
        }else{
            [self setSliderWithValue:_HueValue max:10.0 min:-10.0];
        }
        self.filterModer = FilterModel_Hue;
    }
    
}

#pragma mark --block
- (void)clickButtonWithBlock:(buttonDidSelectedBlock)block {
    _block = block;
}



@end
