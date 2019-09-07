//
//  PreviewBottomCell.m
//  YGCamera
//
//  Created by chen hua on 2019/7/27.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PreviewBottomCell.h"

@implementation PreviewBottomCell


-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.parameterDetailLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
//    self.parameterDetailLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
}


- (void)setCellTextColor{
    
    if (_showPArametersView) {
        self.parameterDetailLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
        self.parameterDetailLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    }else{
        self.parameterDetailLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 11];
        self.parameterDetailLab.textColor = [UIColor whiteColor];
    }
}


- (void)setMiddleTextColor{
    self.parameterDetailLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
    self.parameterDetailLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
}



@end
