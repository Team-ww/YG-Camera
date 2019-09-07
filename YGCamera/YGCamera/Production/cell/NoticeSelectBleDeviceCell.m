//
//  NoticeSelectBleDeviceCell.m
//  YGCamera
//
//  Created by chen hua on 2019/5/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "NoticeSelectBleDeviceCell.h"
#import "UIImageView+Animation.h"


@implementation NoticeSelectBleDeviceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.rotate_imageview.isAngle = YES;
    [self.rotate_imageview startAnimation];
}




-(void)dealloc
{
    [self.rotate_imageview endAnimation];
}




@end
