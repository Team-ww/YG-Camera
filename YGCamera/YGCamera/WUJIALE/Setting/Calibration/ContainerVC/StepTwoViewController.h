//
//  StepTwoViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

typedef void(^clickNextBlock)(void);
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepTwoViewController : UIViewController

- (void)clickButtonToNextWithBlock:(clickNextBlock)block;

@end

NS_ASSUME_NONNULL_END
