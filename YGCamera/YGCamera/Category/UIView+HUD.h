//
//  UIView+HUD.h
//  SelFly
//
//  Created by wenhh on 2018/4/28.
//  Copyright © 2018年 AEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)

- (void)showHUDWithTmie:(NSTimeInterval)time;
- (void)showHUDWithHint:(NSString *)hint;
- (void)showHUDInView:(UIView *)view Hint:(NSString *)hint;
- (void)hideHUD;
- (void)showHUDWithStr:(NSString *)hint Delay:(NSTimeInterval)time;
- (void)showHUDWithText:(NSString *)Text;
- (void)showHUDWithText:(NSString *)Text Delay:(NSTimeInterval)time;

@end
