//
//  ACPhotoViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^delectedImageBlock)(PHAsset *imageAsset);

NS_ASSUME_NONNULL_BEGIN

@interface ACPhotoViewController : UIViewController

@property(nonatomic,strong)PHAsset *imageAsset;

- (void)deleteImageViewWithBlock:(delectedImageBlock)block;

@end

NS_ASSUME_NONNULL_END
