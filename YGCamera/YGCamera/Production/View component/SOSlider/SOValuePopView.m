//
//  SOValuePopView.m
//  SOSlider
//
//  Created by wangli on 2017/3/30.
//  Copyright © 2017年 wangli. All rights reserved.
//

#import "SOValuePopView.h"

@implementation SOValuePopView{
    UILabel *valueLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImage *image = [UIImage imageNamed:@"＜路径＞.png"];
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        imageview.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        imageview.center = self.center;
        [self addSubview:imageview];
        valueLabel = [[UILabel alloc] initWithFrame:imageview.frame];
        valueLabel.backgroundColor = [UIColor clearColor];
        //valueLabel.textColor = [UIColor redColor];
        valueLabel.font = [UIFont systemFontOfSize:9];
        valueLabel.text = @"0.8";
        valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:valueLabel];
    }
    return self;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    valueLabel.font = font;
}
- (void)setText:(NSString *)text{
    _text = text;
    valueLabel.text = text;
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    valueLabel.textColor = textColor;
}

@end
