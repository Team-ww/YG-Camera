//
//  PhotoThreeStepViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/3.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PhotoThreeStepViewController.h"
#import "constants.h"
#import "PhotoScaleCollectionViewCell.h"

@interface PhotoThreeStepViewController ()


@end

@implementation PhotoThreeStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


#pragma mark 点击按钮事件

- (IBAction)clickButtonToSwitchPhoto:(UIButton *)sender {
    
    NSInteger tag = sender.tag / 1000;

    [self.selectedImageViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = (UIImageView *)obj;
        if (idx == tag - 1) {
            imageView.hidden = NO;
        }else{
            imageView.hidden = YES;
        }
    }];
    
    [self.selectedButtonArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        if (idx == tag - 1) {
            [btn setTitleColor:[UIColor colorWithRed:174/255.0 green:204/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }];
    
    
    
    
}











@end
