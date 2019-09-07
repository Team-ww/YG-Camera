//
//  ACCameraMoveViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/23.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraMoveModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol ACCameraMoveViewControllerDelegate;
@interface ACCameraMoveViewController : UIViewController

@property(nonatomic,assign)id<ACCameraMoveViewControllerDelegate> delegate;

@property(nonatomic,strong)CameraMoveModel *moveModel;


@end

@protocol ACCameraMoveViewControllerDelegate <NSObject>

- (void)clickCancelledBtnWithViewController:(ACCameraMoveViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
