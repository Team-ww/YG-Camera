//
//  ACCameraMessageArrowTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraMessageArrowTableViewCell.h"

@implementation ACCameraMessageArrowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setCellWithIndex:(NSIndexPath *)index {
    
    if (index.row == 3) {
        self.titleLabel.text = @"使用说明书";
    }else if (index.row == 4){
        self.titleLabel.text = @"教学视频";
    }else if (index.row == 5){
        self.titleLabel.text = @"云台升级";
    }
    
}



@end
