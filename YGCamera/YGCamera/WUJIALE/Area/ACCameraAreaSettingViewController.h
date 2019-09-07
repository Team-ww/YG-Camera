//
//  ACCameraAreaSettingViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/23.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraAreaModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ACCameraAreaSettingViewControllerDelegate;

@interface ACCameraAreaSettingViewController : UIViewController


@property(nonatomic,strong)CameraAreaModel *areaModel;
@property(nonatomic,assign)id<ACCameraAreaSettingViewControllerDelegate> delegate;


@end

@protocol ACCameraAreaSettingViewControllerDelegate <NSObject>

- (void)clickBeginBtnWithViewController:(ACCameraAreaSettingViewController *)vc;

@end


NS_ASSUME_NONNULL_END
