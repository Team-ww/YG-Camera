//
//  ACCameraAirViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirCameraModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol ACCameraAirViewControllerDelegate;
@interface ACCameraAirViewController : UIViewController

@property(nonatomic,strong)AirCameraModel *airModel;
@property(nonatomic,assign)id<ACCameraAirViewControllerDelegate> delegate;

@end

@protocol ACCameraAirViewControllerDelegate <NSObject>

- (void)clickButtonSaveDataWithController:(ACCameraAirViewController *)controller;

@end

NS_ASSUME_NONNULL_END
