//
//  ACVideoEditorViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

typedef void(^deleteAssetBlock)(void);
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACVideoEditorViewController : UIViewController

@property (nonatomic,strong)PHAsset *videoAsset;

- (void)selectedVideoWithBlock:(deleteAssetBlock)block;

@end

NS_ASSUME_NONNULL_END
