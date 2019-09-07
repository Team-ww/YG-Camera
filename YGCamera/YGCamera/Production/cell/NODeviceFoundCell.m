//
//  NODeviceFoundCell.m
//  YGCamera
//
//  Created by chen hua on 2019/5/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "NODeviceFoundCell.h"
#import "UIImageView+Animation.h"

@implementation NODeviceFoundCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.loadImageView.isAngle = YES;
    [self.loadImageView startAnimation];
}


-(void)dealloc
{
    [self.loadImageView endAnimation];
}

@end
