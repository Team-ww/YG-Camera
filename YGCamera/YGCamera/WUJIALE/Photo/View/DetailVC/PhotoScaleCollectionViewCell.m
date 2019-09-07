//
//  PhotoScaleCollectionViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/4.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PhotoScaleCollectionViewCell.h"

@interface  PhotoScaleCollectionViewCell()

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation PhotoScaleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = 2;
    CGFloat longHeight = 16;
    CGFloat shortHeight = 8;
    
    CGFloat imageWidth = width;
    CGFloat imageHeight = (self.totalNum % 5 == 0) ? longHeight : shortHeight;
    
    CGFloat start = (self.totalNum % 5 == 0) ? 2 : 6;
    
    self.imageView.frame = CGRectMake(0, start, imageWidth, imageHeight);
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.layer.cornerRadius = 1;
}


- (void)setImageViewBackground:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 5 == 0) {
        self.imageView.backgroundColor = [UIColor colorWithRed:174/255.0 green:203/255.0 blue:69/255.0 alpha:1.0];
    }else{
        self.imageView.backgroundColor = [UIColor whiteColor];
    }
    
}



- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}


@end
