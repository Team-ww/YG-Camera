//
//  ROVAUIMessageTools.h
//  AEE
//
//  Created by AEE_ios on 2017/4/1.
//  Copyright © 2017年 AEE_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ROVAUIMessageTools : NSObject


+ (void)showAlertVCWithTitle:(NSString *)title message:(NSString *)message alertActionTitle:(NSString *)actionTitle showInVc:(UIViewController*)vc;

+ (void)showAlertView:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle comfirmActionTitle:(NSString *)comfirmActionTitle cancelTitle:(NSString *)cancelTitle confirmBlock:(void (^)(UIAlertAction * _Nonnull action))confirmBlock cancelBlock:(void (^)(UIAlertAction * _Nonnull action))cancelBlock;

+(UIViewController *)getCurrentVC;

@end
