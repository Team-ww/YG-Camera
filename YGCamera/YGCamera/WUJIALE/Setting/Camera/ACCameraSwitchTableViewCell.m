//
//  ACCameraSwitchTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraSwitchTableViewCell.h"

@implementation ACCameraSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.modelSwitch.onTintColor = [UIColor colorWithRed:180/255.0 green:201/255.0 blue:91/255.0 alpha:1.0];
    self.modelSwitch.tintColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    
}

- (void)setSwitchStatus:(NSArray *)dataSource index:(NSIndexPath *)index {
    
    if (index.row == 3) {
        
        self.switchLab.text = @"相机手动模式";
        self.modelSwitch.on = [dataSource[0] integerValue];
    }else {
        self.switchLab.text = @"相机防抖";
        self.modelSwitch.on = [dataSource[1] integerValue];
    }
}
@end
