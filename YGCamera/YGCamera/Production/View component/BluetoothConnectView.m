//
//  BluetoothConnectView.m
//  YGCamera
//
//  Created by chen hua on 2019/4/8.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "BluetoothConnectView.h"
#import "ConnectButton.h"
//#import "DSHPopupContainer.h"
//#import "UIImageView+Animation.h"
//#import "BLEControlManager.h"

typedef void(^BlueConnectClickBlock)(void);

@interface BluetoothConnectView ()

@property (nonatomic,copy)BlueConnectClickBlock block;


@end


@implementation BluetoothConnectView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
       
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
       
    }
    return self;
}

- (IBAction)cancelClick:(id)sender {
    
    self.superview.hidden = YES;
//   [self removeNoBluetoothconnect];
//    [self.superview removeFromSuperview];
//    [self removeFromSuperview];
}


- (IBAction)connectButton:(ConnectButton *)sender {
    self.superview.hidden = YES;
    //执行相机事件,进入相机
  //  [self.superview removeFromSuperview];
    //[self removeFromSuperview];
    if (_block) {
        _block();
    }
   // [self removeFromSuperview];
}

- (void)handleBlueConnectBlock:(void(^)())blueConnectBlock{
    
    _block = blueConnectBlock;
}


@end
