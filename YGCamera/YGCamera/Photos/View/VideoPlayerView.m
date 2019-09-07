//
//  VideoPlayerView.m
//  YGCamera
//
//  Created by chen hua on 2019/4/12.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "VideoPlayerView.h"

@implementation VideoPlayerView


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.slider setThumbImage:[UIImage imageNamed:@"slidezSpot"] forState:UIControlStateNormal];
}


- (void)updateButtonview:(UIButton *)btn{
    
    [self.filterButton setImage:[UIImage imageNamed:@"albumDetailsFilterIcon"] forState:UIControlStateNormal];
    [self.shearButton setImage:[UIImage imageNamed:@"detailsScissorsIcon"] forState:UIControlStateNormal];
    [self.musicButton setImage:[UIImage imageNamed:@"detailsMusicIcon"] forState:UIControlStateNormal];
    
    if ([btn isEqual:self.filterButton]) {
        [self.filterButton setImage:[UIImage imageNamed:@"albumDetailsFilterSel"] forState:UIControlStateNormal];
    }else if ([btn isEqual:self.shearButton]) {
        [self.shearButton setImage:[UIImage imageNamed:@"detailsScissorsIconSel"] forState:UIControlStateNormal];
    }else if ([btn isEqual:self.musicButton]) {
        [self.musicButton setImage:[UIImage imageNamed:@"detailsMusicIconSel"] forState:UIControlStateNormal];
    }
    
}

@end
