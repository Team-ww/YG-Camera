//
//  ROVAUIMessageTools.m
//  AEE
//
//  Created by AEE_ios on 2017/4/1.
//  Copyright © 2017年 AEE_iOS. All rights reserved.
//

#import "ROVAUIMessageTools.h"


@implementation ROVAUIMessageTools


+ (void)showAlertVCWithTitle:(NSString *)title message:(NSString *)message alertActionTitle:(NSString *)actionTitle showInVc:(UIViewController*)vc {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:alertAction];
    [vc presentViewController:alertVC animated:YES completion:nil];
    
}

+ (void)showAlertView:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle comfirmActionTitle:(NSString *)comfirmActionTitle cancelTitle:(NSString *)cancelTitle confirmBlock:(void (^)(UIAlertAction * _Nonnull action))confirmBlock cancelBlock:(void (^)(UIAlertAction * _Nonnull action))cancelBlock{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (cancelTitle != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:cancelBlock];
        [alertVC addAction:cancelAction];
      //  [cancelAction setValue:[UIColor colorWithRed:0 green:172/255.0 blue:200/255.0 alpha:1.0] forKey:@"_titleTextColor"];
    }
    UIAlertAction *ConfirmAction = [UIAlertAction actionWithTitle:comfirmActionTitle style:UIAlertActionStyleDefault handler:confirmBlock];
    [alertVC addAction:ConfirmAction];
    //[ConfirmAction setValue:[UIColor colorWithRed:0 green:172/255.0 blue:200/255.0 alpha:1.0] forKey:@"_titleTextColor"];
    [[self getPresentedViewController] presentViewController:alertVC animated:YES completion:nil];
}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while  (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
