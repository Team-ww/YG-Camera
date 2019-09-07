//
//  AboutUSCell.m
//  YGCamera
//
//  Created by chen hua on 2019/4/10.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "AboutUSCell.h"

@implementation AboutUSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.shadowColor = [UIColor colorWithRed:70/255.0 green:147/255.0 blue:238/255.0 alpha:0.2].CGColor;
    self.layer.shadowOpacity = 0.2f;
    self.layer.shadowRadius = 8.f;
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0,10);
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
