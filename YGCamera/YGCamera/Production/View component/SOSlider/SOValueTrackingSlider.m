//
//  SOValueTrackingSlider.m
//  SOSlider
//
//  Created by wangli on 2017/3/30.
//  Copyright © 2017年 wangli. All rights reserved.
//

#import "SOValueTrackingSlider.h"

@interface SOValueTrackingSlider()<SOTrackingSliderDelegate>

//@property (nonatomic, strong) SOValuePopView *valuePopView;
//@property (nonatomic, strong) SOTrackingSlider *uiSlider;
@end

@implementation SOValueTrackingSlider

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpWithFrame:frame];
    }
    return self;
}


- (void)setUpWithFrame:(CGRect)frame{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    _numberFormatter = formatter;
//    self.valuePopView = [[SOValuePopView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    self.valuePopView.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
//
//    [self addSubview:self.valuePopView];
    UIImage *image = [UIImage imageNamed:@"＜路径＞.png"];
    _uiSlider = [[SOTrackingSlider alloc] initWithFrame:CGRectMake(50, 0, frame.size.width - 50, 50)];
    
    self.valuePopView = [[SOValuePopView alloc] initWithFrame:CGRectMake(26, 50, image.size.width, image.size.height)];
    self.valuePopView.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
    
    [self addSubview:self.valuePopView];
    
    _uiSlider.delegate = self;
    _uiSlider.minimumValue = 0;
    _uiSlider.maximumValue = 1;
    _uiSlider.value = 0;
    [_uiSlider setThumbImage:[UIImage imageNamed:@"＜编组＞.png"]forState:UIControlStateNormal];
    [self addSubview:_uiSlider];
}

- (void)currentValueOfSlider:(SOTrackingSlider *)slider{
    
    [self.valuePopView setText:[_numberFormatter stringFromNumber:@(slider.value)]];
    self.valuePopView.center = CGPointMake(self.valuePopView.center.x, CGRectGetMaxY(slider.frame) - slider.value * CGRectGetHeight(slider.frame) -40);
}

- (void)beginSwipSlider:(SOTrackingSlider *)slider{
    if ([self.delegate respondsToSelector:@selector(beginSwip)]) {
        [self.delegate beginSwip];
    }
}
- (void)endSwipSlider:(SOTrackingSlider *)slider{
    if ([self.delegate respondsToSelector:@selector(endSwip)]) {
        [self.delegate endSwip];
    }
}
- (void)setIsVertical:(BOOL)isVertical{
    _isVertical = isVertical;
    if (_isVertical == YES) {
        self.uiSlider.transform = CGAffineTransformMakeRotation(-M_PI/2);
        self.valuePopView.center = CGPointMake(self.uiSlider.center.x, self.uiSlider.center.y - self.uiSlider.frame.size.height/2 - self.valuePopView.frame.size.height/2);
    }else{
        
    }
}
- (void)setNumberFormatter:(NSNumberFormatter *)numberFormatter
{
    _numberFormatter = numberFormatter;
}
- (void)setMinValue:(CGFloat)minValue{
    _minValue = minValue;
    _uiSlider.minimumValue = minValue;
}
- (void)setMaxValue:(CGFloat)maxValue{
    _maxValue = maxValue;
    _uiSlider.maximumValue = maxValue;
}
- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor{
    _minimumTrackTintColor = minimumTrackTintColor;
    _uiSlider.minimumTrackTintColor = minimumTrackTintColor;
}
- (void)setMaxmumTrackTintColor:(UIColor *)maxmumTrackTintColor{
    _maxmumTrackTintColor = maxmumTrackTintColor;
    _uiSlider.maximumTrackTintColor = maxmumTrackTintColor;
}
- (void)setFont:(UIFont *)font{
    _font = font;
    [_valuePopView setFont:font];
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [_valuePopView setTextColor:textColor];
}
// 解决在UIScrollView中滑动冲突的问题
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return CGRectContainsPoint(self.uiSlider.frame, point);
}
@end
