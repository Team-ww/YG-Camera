//
//  ACCameraSTViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraSetModel.h"

@class ACCameraSTViewController;

@protocol ACCameraSTViewControllerrDelegate <NSObject>

- (void)rockerClickButtonSaveDateWithViewController:(ACCameraSTViewController *_Nullable)viewController;

@end

typedef void(^selectedIndexBlock)(NSInteger row,NSInteger index,NSString *value);

NS_ASSUME_NONNULL_BEGIN

@interface ACCameraSTViewController : UIViewController

@property (nonatomic,strong)CameraSetModel *cameraModel;

@property(nonatomic,assign)id<ACCameraSTViewControllerrDelegate> delegate;

@property (nonatomic,strong)UITableView *mainTableView;

- (void)selectedCellGetValueWith:(selectedIndexBlock)block;




@end

NS_ASSUME_NONNULL_END
