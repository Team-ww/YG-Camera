//
//  ACCameraCalibrationViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraCalibrationViewController.h"
#import "StepOneViewController.h"
#import "StepTwoViewController.h"
#import "StepThreeViewController.h"
#import "StepFourViewController.h"
#import "constants.h"


@interface ACCameraCalibrationViewController () {
    
    
}

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ckeckImages;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;


@end

@implementation ACCameraCalibrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.mainScrollView.scrollEnabled = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    
    
    StepOneViewController *oneVC = self.childViewControllers[0];
    StepTwoViewController *twoVC = self.childViewControllers[1];
    StepThreeViewController *threeVC = self.childViewControllers[2];
    
    [oneVC clickButtonToNextWithBlock:^{
        [self.mainScrollView setContentOffset:CGPointMake(MIN(KMainScreenWidth, KMainScreenHeight) * 0.8,0)animated:YES];
        UIImageView *imageView = (UIImageView *)self.ckeckImages[1];
        imageView.image = [UIImage imageNamed:@"check_r"];
    }];
    
    [twoVC clickButtonToNextWithBlock:^{
        [self.mainScrollView setContentOffset:CGPointMake(MIN(KMainScreenWidth, KMainScreenHeight)*2*0.8, 0) animated:YES];
        [threeVC.activityView startAnimating];
        UIImageView *imageView_2 = (UIImageView *)self.ckeckImages[2];
        imageView_2.image = [UIImage imageNamed:@"check_r"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImageView *imageView_3 = (UIImageView *)self.ckeckImages[2];
            imageView_3.image = [UIImage imageNamed:@"check_r"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIImageView *imageView_4 = (UIImageView *)self.ckeckImages[3];
                imageView_4.image = [UIImage imageNamed:@"check_r"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIImageView *imageView_5 = (UIImageView *)self.ckeckImages[4];
                    imageView_5.image = [UIImage imageNamed:@"check_r"];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [threeVC.activityView stopAnimating];
                        [self.mainScrollView setContentOffset:CGPointMake(MIN(KMainScreenWidth, KMainScreenHeight) * 0.8 * 3, 0) animated:YES];
                        UIImageView *imageView_6 = (UIImageView *)self.ckeckImages[5];
                        imageView_6.image = [UIImage imageNamed:@"check_r"];
                    });
                });
            });
            
        });
    }];
}





@end
