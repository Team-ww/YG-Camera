//
//  ACVideoEditorDetailsViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

typedef void(^cancelVideoEditorBlock)(void);
typedef void(^saveVideoEditorBlock)(void);
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACVideoEditorDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

- (void)clickButtonCancelWithBlock:(cancelVideoEditorBlock)block;

- (void)clickButtonSaveEditorVideoWithBlock:(saveVideoEditorBlock)block;

@end

NS_ASSUME_NONNULL_END
