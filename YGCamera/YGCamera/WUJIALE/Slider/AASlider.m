//
//  AASlider.m
//  CellTableDemo
//
//  Created by 羚羊云 on 2018/9/18.
//  Copyright © 2018年 lingyangyun. All rights reserved.
//

#import "AASlider.h"

@interface AASlider()

@property(nonatomic,strong)UIView *thumbView;


@end

@implementation AASlider


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

        [self setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        self.minimumTrackTintColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0];
        self.maximumTrackTintColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    
    bounds = [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 4);
}



#pragma mark -Setter func

- (void)setValueText:(NSString *)valueText {
    
    if (![_valueText isEqualToString:valueText]) {
        _valueText = valueText;
        
        self.valueLabel.text = valueText;
        [self.valueLabel sizeToFit];
        self.valueLabel.center = CGPointMake(self.thumbView.bounds.size.width/2, -self.valueLabel.bounds.size.height/2 );
        
        if (!self.valueLabel.superview) {
            [self.thumbView addSubview:self.valueLabel];
        }
    }
}


#pragma mark -Getter func

- (UIView *)thumbView {
    
    NSLog(@"subviews ==> %zd",self.subviews.count);
    if (!_thumbView && self.subviews.count > 2) {
        _thumbView = self.subviews[2];
    }
    return _thumbView;
}

- (UILabel *)valueLabel {
    
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.textColor = [UIColor colorWithRed:91.0/255 green:91.0/255 blue:91.0/255 alpha:1.0];
        _valueLabel.font = [UIFont systemFontOfSize:9];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLabel;
}


#pragma mark - Action func

- (void)sliderValueChanged:(AASlider *)slider {
    
    if (slider) {
        slider.valueText = [NSString stringWithFormat:@"%.1f",slider.value];
    }
}


@end
