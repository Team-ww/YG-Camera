//
//  UIBaseVC.h
//  YGCamera
//
//  Created by iOS_App on 2019/9/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"


NS_ASSUME_NONNULL_BEGIN

@interface UIBaseVC : UIViewController

@property (nonatomic)MBProgressHUD *progressHUD;

- (MBProgressHUD *)progressHUD;

- (void)showProgressHUDNotice:(NSString *)message
                     showTime:(NSTimeInterval)time;

- (void)showProgressHUDWithMessage:(NSString *)message;

- (void)showProgressHUDCompleteMessage:(NSString *)message;

- (void)hideProgressHUD:(BOOL)animated ;


@end

NS_ASSUME_NONNULL_END
