//
//  UIView+HUD.m
//  SelFly
//
//  Created by wenhh on 2018/4/28.
//  Copyright © 2018年 AEE. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *kHttpRequestHUDKey = &kHttpRequestHUDKey;

@implementation UIView (HUD)

- (void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, kHttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, kHttpRequestHUDKey);
}

/**
 *  展示提示信息，默认2s后自动消失
 *
 *  @param hint HUD提示信息
 */
- (void)showHUDWithHint:(NSString *)hint
{
    if ([self HUD]) {
        [[self HUD] hideAnimated:YES];
    }
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.userInteractionEnabled = NO;
    //配置文本
    HUD.mode = MBProgressHUDModeText;                   //设置操作模式为仅显示标签
    HUD.label.text = hint;                               //设置显示标签文本
    HUD.margin = 16.f;                                  //设置标签、指示器或自定义视图与HUD边缘之间的空间值
    HUD.label.font = [UIFont systemFontOfSize:16.f];     //设置标签文本字体
    //    HUD.opacity = 0.6f;                                //设置透明度
    
    [HUD hideAnimated:YES afterDelay:2];
}


/**
 展示time 秒的加载框
 
 @param time 持续的时间
 */
- (void)showHUDWithTmie:(NSTimeInterval)time {
    if ([self HUD]) {
        [[self HUD] hideAnimated:YES];
    }
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode =  MBProgressHUDModeIndeterminate;
    [HUD hideAnimated:YES afterDelay:time];
    
}

- (void)showHUDInView:(UIView *)view Hint:(NSString *)hint
{
    
    MBProgressHUD *HUD;
    if (![self HUD]) {
        HUD = [[MBProgressHUD alloc] initWithView:view];
    }else  HUD = [self HUD];
    
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.mode =  MBProgressHUDModeIndeterminate;
    HUD.label.text = hint;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

- (void)showHUDWithStr:(NSString *)hint Delay:(NSTimeInterval)time {
    if ([self HUD]) {
        [[self HUD] hideAnimated:YES];
    }
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode =  MBProgressHUDModeIndeterminate;
    HUD.label.text = hint;
    //    HUD.opacity = 0.6f;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
    [HUD hideAnimated:YES afterDelay:time];
}


// 只显示文字
- (void)showHUDWithText:(NSString *)Text{
    if ([self HUD]) {
        [[self HUD] hideAnimated:YES];
    }
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    HUD.label.text = Text;
    HUD.mode = MBProgressHUDModeText;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

// 只显示文字
- (void)showHUDWithText:(NSString *)Text Delay:(NSTimeInterval)time{
    if ([self HUD]) {
        [[self HUD] hideAnimated:YES];
    }
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    HUD.label.text = Text;
    HUD.mode = MBProgressHUDModeText;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
    [HUD hideAnimated:YES afterDelay:time];
}

- (void)hideHUD
{
    if ([self HUD]) {
        [[self HUD] hideAnimated:YES];
    }
}


@end
