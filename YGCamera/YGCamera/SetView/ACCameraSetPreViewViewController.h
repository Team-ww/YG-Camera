//
//  ACCameraSetPreViewViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/27.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDetailModel.h"
#import "SelectedModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ACCameraSetPreViewViewControllerDelegate;

@interface ACCameraSetPreViewViewController : UIViewController

@property (nonatomic,assign)id<ACCameraSetPreViewViewControllerDelegate> delegate;
@property(nonatomic,strong)SetDetailModel *setDetailModel;
@property(nonatomic,assign)NSInteger index;//判断是拍照还是录像，1:照片，2:视频
@property(nonatomic,assign)NSInteger topScrollIndex;
@property(nonatomic,assign)NSInteger bottomScrollIndex;

//index 一级选项 ： 从0开始
// selctedModel：选择Model，都是从0开始，selected
- (void)scrollViewWithIndex:(NSInteger)index selectedModel:(SelectedModel *)selectedModel;
- (NSInteger)getMaxIndexWithTopIndex:(NSInteger)topIndex;



#pragma mark -判断二级菜单存在不存在
- (BOOL)isSecondMenuIsshow;

@end

@protocol ACCameraSetPreViewViewControllerDelegate <NSObject>

- (void)setVCDismisWithController:(ACCameraSetPreViewViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
