//
//  GalleryEditSkinView.m
//  SelFly
//
//  Created by wenhh on 2017/11/16.
//  Copyright © 2017年 AEE. All rights reserved.
//

#import "GalleryEditSkinView.h"

@interface GalleryEditSkinView ()
{
    CGFloat _exfolactValue,_whiteningValue,_lastExfolactValue,_lastWhiteningValue;
// _last为记录上一次
}
@property (weak, nonatomic) IBOutlet UISlider *skinSlider;
@property (weak, nonatomic) IBOutlet UILabel *skinTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *sliderValueLab;
@property (weak, nonatomic) IBOutlet UIButton *exfolactionBtn;
@property (weak, nonatomic) IBOutlet UIButton *whiteningBtn;
@property (strong, nonatomic) UIButton *oldBtn;


@end

@implementation GalleryEditSkinView

- (void)awakeFromNib {
    [super awakeFromNib];
     [self.skinSlider addTarget:self action:@selector(skinSliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshSkinView {
    
    if (!self.oldBtn) {
        _exfolactValue = 10000;
        _whiteningValue = 10000;
        _lastWhiteningValue = 10000;
        _lastExfolactValue = 10000;
        self.exfolactionBtn.selected = YES;
        self.oldBtn = self.exfolactionBtn;
    }else {
        if (self.oldBtn != self.exfolactionBtn)self.oldBtn.selected = NO;
        self.exfolactionBtn.selected = YES;
        self.oldBtn = self.exfolactionBtn;
    }
    [self.skinSlider setMaximumValue:50.f];
    [self.skinSlider setMinimumValue:-50.0f];
    self.skinTypeLab.text = self.exfolactionBtn.titleLabel.text;
    if (_lastExfolactValue==10000) {
        self.sliderValueLab.text = @"50.0";
        self.skinSlider.value = 50.0;
    }else {
        self.sliderValueLab.text = [NSString stringWithFormat:@"%.1f",(_lastExfolactValue)];
        self.skinSlider.value = _exfolactValue;
    }
}

- (IBAction)SkinNOBtnAction:(UIButton *)sender {
    _exfolactValue = _lastExfolactValue;
    _whiteningValue = _lastWhiteningValue;
//    self.skinBlock(self.skinImg, NO);
    self.skinReturnBlock(_lastWhiteningValue,_lastExfolactValue, 0);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0,self.superview.frame.size.height, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (IBAction)skinYesBtnAction:(UIButton *)sender {
    _lastExfolactValue = _exfolactValue;
    _lastWhiteningValue = _whiteningValue;
    self.skinReturnBlock(_whiteningValue, _exfolactValue, 2);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0,self.superview.frame.size.height, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)exfoliatingBtnAction:(UIButton *)sender {
    if (self.oldBtn != sender) {
        self.oldBtn.selected = NO;
        sender.selected = YES;
        self.oldBtn = sender;
        [self.skinSlider setMaximumValue:50.f];
        [self.skinSlider setMinimumValue:-50.0f];
        self.skinTypeLab.text = sender.titleLabel.text;
        if (_exfolactValue == 10000) {
            self.sliderValueLab.text = @"50.0";
            self.skinSlider.value = 50.0;
        }else {
            self.skinSlider.value = _exfolactValue;
            self.sliderValueLab.text = [NSString stringWithFormat:@"%.1f",_exfolactValue];
        }
        
    }

}

- (IBAction)whiteningBtnAction:(UIButton *)sender {
    if (self.oldBtn != sender) {
        self.oldBtn.selected = NO;
        sender.selected = YES;
        self.oldBtn = sender;
    self.skinTypeLab.text = sender.titleLabel.text;

    [self.skinSlider setMaximumValue:0.5f];
    [self.skinSlider setMinimumValue:-0.5f];
        if (_whiteningValue == 10000) {
            self.skinSlider.value = 0.0;
            self.sliderValueLab.text = @"0.0";
        }else {
            self.skinSlider.value = _whiteningValue;
            self.sliderValueLab.text = [NSString stringWithFormat:@"%.1f",_whiteningValue];
        }
    }
}

- (IBAction)skinSliderChangeAction:(UISlider *)sender {
    self.sliderValueLab.text = [NSString stringWithFormat:@"%.1f",self.skinSlider.value];
    if (self.oldBtn == self.whiteningBtn) {
        _whiteningValue = sender.value;
       
    }else {
        _exfolactValue = sender.value;
    }
}

- (void)skinSliderTouchUpInSide:(UISlider *)sender{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
          self.skinReturnBlock(_whiteningValue, _exfolactValue, 1);
    });
 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
