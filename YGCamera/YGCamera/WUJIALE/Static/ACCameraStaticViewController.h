//
//  ACCameraStaticViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/23.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraStaticModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ACCameraStaticViewControllerDelegate;

@interface ACCameraStaticViewController : UIViewController

@property (nonatomic,strong)CameraStaticModel *staticModel;

@property(nonatomic,weak)id<ACCameraStaticViewControllerDelegate> delegate;

@end

@protocol ACCameraStaticViewControllerDelegate <NSObject>

- (void)clickStartButtonWithController:(UIViewController *)vc;

@end


NS_ASSUME_NONNULL_END
