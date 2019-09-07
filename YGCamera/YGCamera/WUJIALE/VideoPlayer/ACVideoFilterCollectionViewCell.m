//
//  ACVideoFilterCollectionViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/30.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACVideoFilterCollectionViewCell.h"

@implementation ACVideoFilterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellDataWithTitle:(NSString *)title image:(UIImage *)image {
    
    self.imageView.image = image;
    self.titleLabel.text = title;
}


@end
