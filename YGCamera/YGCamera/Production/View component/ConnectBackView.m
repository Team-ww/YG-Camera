//
//  ConnectBackView.m
//  YGCamera
//
//  Created by chen hua on 2019/4/13.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ConnectBackView.h"
#import "BluetoothConnectView.h"

@implementation ConnectBackView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:0.76];
//        self.frame = [UIScreen mainScreen].bounds;
//        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestClik)];
//        [self addGestureRecognizer:gest];
        
    }
    return self;
}

- (void)gestClik{
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[BluetoothConnectView class]]) {
            
        //[(BluetoothConnectView *)view removeNoBluetoothconnect];
            [view removeFromSuperview];
        }
    }
    
    [self removeFromSuperview];
}


@end
