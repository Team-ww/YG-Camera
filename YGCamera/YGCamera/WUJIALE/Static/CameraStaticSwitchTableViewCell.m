//
//  CameraStaticSwitchTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CameraStaticSwitchTableViewCell.h"

@implementation CameraStaticSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.staticSwitch.tintColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    self.staticSwitch.onTintColor = [UIColor colorWithRed:180/255.0 green:201/255.0 blue:91/255.0 alpha:1.0];
}

- (void)setSwitchWithData:(NSInteger)index {
    self.staticSwitch.on = index;
}

@end
