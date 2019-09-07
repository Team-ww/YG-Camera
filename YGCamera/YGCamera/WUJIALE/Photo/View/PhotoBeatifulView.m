//
//  PhotoBeatifulView.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PhotoBeatifulView.h"

@interface PhotoBeatifulView (){
    skinViewReturnBlock _block;
    
    //_last为记录上一次
    CGFloat _exfolactValue,_whiteningValue,_lastExfolactValue,_lastWhiteningValue;
}

@end

@implementation PhotoBeatifulView

- (void)refreshSkinView {
    
    _exfolactValue = 10000;
    _whiteningValue = 10000;
    _lastWhiteningValue = 10000;
    _lastExfolactValue = 10000;
    
    [self.slider setMaximumValue:50.f];
    [self.slider setMinimumValue:-50.f];
    
    [self clickSkinButton:self.skinButton];
    
    if (_lastExfolactValue == 10000) {
        self.slider.value = 50.0f;
    }else{
        self.slider.value = _exfolactValue;
    }
}

- (void)cancelSkinView {
    _exfolactValue = _lastExfolactValue;
    _whiteningValue = _lastWhiteningValue;
    
    if (_block) {
        _block(_lastWhiteningValue,_lastExfolactValue,0);
    }
}

- (void)confirmSkinView {
    
    _lastExfolactValue = _exfolactValue;
    _lastWhiteningValue = _whiteningValue;
    
    if (_block) {
        _block(_whiteningValue,_exfolactValue,2);
    }
}



- (IBAction)clickSkinButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.whiteButton.selected = !sender.selected;
    
    [self.slider setMaximumValue:50.f];
    [self.slider setMinimumValue:-50.f];
    
    if (_exfolactValue == 10000) {
        self.slider.value = 50.0;
    }else{
        self.slider.value = _exfolactValue;
    }
}


- (IBAction)clickWhiteButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.skinButton.selected = !sender.selected;
    
    [self.slider setMaximumValue:0.5f];
    [self.slider setMinimumValue:-0.5f];
    
    if (_whiteningValue == 10000) {
        self.slider.value = 0.0;
    }else{
        self.slider.value = _whiteningValue;
    }
}


- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    
    if (self.skinButton.selected) {
        _exfolactValue = sender.value;
    }else{
        _whiteningValue = sender.value;
    }
    
}

- (IBAction)sliderDidTouchUpInside:(UISlider *)sender {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_block) {
            self->_block(self->_whiteningValue,self->_exfolactValue,1);
        }
    });
    
}




- (void)getPhotoSkinWithBlock:(skinViewReturnBlock)block {
    _block = block;
}

@end
