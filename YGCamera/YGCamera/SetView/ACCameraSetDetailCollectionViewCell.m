//
//  ACCameraSetDetailCollectionViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/28.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraSetDetailCollectionViewCell.h"

@implementation ACCameraSetDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setCellWithModel:(SetDetailModel *)model defaultArr:(NSArray *)defaultArr select:(NSArray *)selectedArr titleArr:(NSArray *)titleArr index:(NSIndexPath *)index {
    
    
    if (index.row == model.index) {
        
        self.imageView.image = [UIImage imageNamed:selectedArr[index.row]];
        self.titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:202/255.0 blue:91/255.0 alpha:1.0];

    }else{
        
        self.imageView.image = [UIImage imageNamed:defaultArr[index.row]];
        self.titleLabel.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
    }
    
    
    self.titleLabel.text = titleArr[index.row];
    
}



@end
