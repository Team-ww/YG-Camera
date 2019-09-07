//
//  ACCameraAirTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraAirTableViewCell.h"

@interface ACCameraAirTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ACCameraAirTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.ariSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.ariSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_line"] forState:UIControlStateNormal];
    [self.ariSlider setMaximumTrackImage:[UIImage imageNamed:@"slider_line"] forState:UIControlStateNormal];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


- (void)setCellDataWithModel:(AirCameraModel *)model indexPath:(nonnull NSIndexPath *)index {
    
    if (index.section == 0) {
        
        if (index.row == 0) {
            self.titleLabel.text = @"俯仰 PITCH";
            self.ariSlider.value = model.pitch_sd;
        }else if (index.row == 1){
            self.titleLabel.text = @"横滚 ROLL";
            self.ariSlider.value = model.roll_sd;
        }else if (index.row == 2){
            self.titleLabel.text = @"航向 YAW";
            self.ariSlider.value = model.yaw_sd;
        }
        
    }else if (index.section == 1){
        
        if (index.row == 0) {
            self.titleLabel.text = @"俯仰 PITCH";
            self.ariSlider.value = model.pitch_dh;
        }else if (index.row == 1){
            self.titleLabel.text = @"横滚 ROLL";
            self.ariSlider.value = model.roll_dh;
        }else if (index.row == 2){
            self.titleLabel.text = @"航向 YAW";
            self.ariSlider.value = model.yaw_dh;
        }
        
    }
}


@end
