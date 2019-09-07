//
//  ConnectButton.m
//  S1 VR 360
//
//  Created by Chenhua on 2018/2/28.
//  Copyright © 2018年 Chenhua. All rights reserved.
//

#import "ConnectButton.h"

@implementation ConnectButton

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [self.layer addSublayer:gradient];
    gradient.frame = self.bounds;
     gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:81.0/255.0 green:81.0/255.0 blue:81.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:81.0/255.0 green:81.0/255.0 blue:81.0/255.0 alpha:1.0].CGColor, nil];
//    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:104.0/255.0 green:112.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:92.0/255.0 green:146.0/255.0 blue:231.0/255.0 alpha:1.0].CGColor, nil];
    if (self.tag == 4) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.bounds.size.height/2;
    }
//    if (self.tag == 4) {
//        gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:118.0/255.0 green:82.0/255.0 blue:240.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:238.0/255.0 green:47.0/255.0 blue:88.0/255.0 alpha:1.0].CGColor, nil];
//    }else if (self.tag == 3){
//        gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:165.0/255.0 green:57.0/255.0 blue:249.0/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:104.0/255.0 green:61.0/255.0 blue:254.0/255.0 alpha:1.0].CGColor, nil];
//    }
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1.0, 0.0);
    [self.layer insertSublayer:self.titleLabel.layer above:gradient];
}

@end
