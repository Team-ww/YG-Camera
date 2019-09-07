//
//  CameraMoveTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CameraMoveTableViewCell.h"

@interface CameraMoveTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *rollView;


@end

@implementation CameraMoveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rollView.layer.cornerRadius = 4.5;
    self.rollView.clipsToBounds = YES;
    self.rollView.layer.borderWidth = 1;
    self.rollView.layer.borderColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0].CGColor;
    
    
    [self.sliderAA setValue:15 animated:YES];
    self.sliderAA.value = 15;
    self.sliderAA.valueText = [NSString stringWithFormat:@"%ld",(NSInteger)self.sliderAA.value];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCellWithModel:(CameraMoveModel *)model indexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        self.sliderAA.value = model.mf_number;
        self.sliderAA.valueText = [NSString stringWithFormat:@"%ld",model.mf_number];
    }else{
        self.sliderAA.value = model.wt_number;
        self.sliderAA.valueText = [NSString stringWithFormat:@"%ld",model.wt_number];
    }
    
}






@end
