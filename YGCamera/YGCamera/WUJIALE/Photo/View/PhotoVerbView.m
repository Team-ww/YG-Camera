//
//  PhotoVerbView.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PhotoVerbView.h"
#import "constants.h"

@interface PhotoVerbView ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation PhotoVerbView





#pragma mark -编辑

- (IBAction)photoEditor:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self.actionButtonArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        if (idx == 0) {
            [btn setImage:[UIImage imageNamed:@"photo_selected_sel"] forState:UIControlStateNormal];
        }else if (idx == 1){
            [btn setImage:[UIImage imageNamed:@"photo_verb_nor"] forState:UIControlStateNormal];
        }else if (idx == 2){
            [btn setImage:[UIImage imageNamed:@"photo_roat_nor"] forState:UIControlStateNormal];
        }
        
    }];
    
}

#pragma mark -缩放比例

- (IBAction)photoScale:(UIButton *)sender {
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
    
    [self.actionButtonArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        
        if (idx == 0) {
            [btn setImage:[UIImage imageNamed:@"photo_selected_nor"] forState:UIControlStateNormal];
        }else if (idx == 1){
            [btn setImage:[UIImage imageNamed:@"photo_verb_sel"] forState:UIControlStateNormal];
        }else if (idx == 2){
            [btn setImage:[UIImage imageNamed:@"photo_roat_nor"] forState:UIControlStateNormal];
        }
        
    }];
    
}

#pragma mark -旋转

- (IBAction)photoSwitch:(UIButton *)sender {
    
    [self.mainScrollView setContentOffset:CGPointMake(0,120) animated:YES];
    
    [self.actionButtonArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        if (idx == 0) {
            [btn setImage:[UIImage imageNamed:@"photo_selected_nor"] forState:UIControlStateNormal];
        }else if (idx == 1){
            [btn setImage:[UIImage imageNamed:@"photo_verb_nor"] forState:UIControlStateNormal];
        }else if (idx == 2){
            [btn setImage:[UIImage imageNamed:@"photo_roat_sel"] forState:UIControlStateNormal];
        }
    }];
}

@end
