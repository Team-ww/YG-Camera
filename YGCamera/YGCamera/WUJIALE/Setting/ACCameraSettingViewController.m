//
//  ACCameraSettingViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraSettingViewController.h"
#import "constants.h"

@interface ACCameraSettingViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topButtons;


//下面的scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;


@end

@implementation ACCameraSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置scrollView默认不可以滚动
    self.mainScrollView.scrollEnabled = NO;
    
}

#pragma mark 点击按钮切换视图

- (IBAction)clickButtonToCheckView:(UIButton *)sender {
    
    NSInteger tag = sender.tag / 1000;
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    CGPoint offset = CGPointMake((tag - 1) * width * 0.8, 0);
    [self.mainScrollView setContentOffset:offset animated:YES];
    
    
    [self.topButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *btn = (UIButton *)obj;
        if (btn.tag/1000 == tag) {
            [btn setBackgroundColor:[UIColor colorWithRed:165/255.0 green:197/255.0 blue:60/255.0 alpha:1.0]];
            [btn setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            
            [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
            [btn setTitleColor:[UIColor colorWithRed:114/255.0 green:113/255.0 blue:113/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
    }];
    
}






@end
