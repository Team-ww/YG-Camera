//
//  ACCameraMessageTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraMessageTableViewCell.h"

@implementation ACCameraMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setCellWithModel:(CameraMessageModel *)model indexPath:(NSIndexPath *)index {
    
    if (index.row == 0) {
        self.titleLabel.text = @"设备名称";
        self.valueLabel.text = model.cameraName;
    }else if (index.row == 1){
        self.titleLabel.text = @"版本信息";
        self.valueLabel.text = model.version;
    }else if (index.row == 2){
        self.titleLabel.text = @"直播";
        self.valueLabel.text = model.liveMessage;
    }

}


@end
