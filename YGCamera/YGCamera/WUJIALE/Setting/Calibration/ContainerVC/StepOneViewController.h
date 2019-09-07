//
//  StepOneViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

typedef void(^clickNextStep)(void);
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepOneViewController : UIViewController

- (void)clickButtonToNextWithBlock:(clickNextStep)block;

@end

NS_ASSUME_NONNULL_END
