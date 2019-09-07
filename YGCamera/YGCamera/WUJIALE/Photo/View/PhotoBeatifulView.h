//
//  PhotoBeatifulView.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^skinViewReturnBlock)(CGFloat whiteningValue,CGFloat skinValue,NSInteger skinState);

NS_ASSUME_NONNULL_BEGIN

@interface PhotoBeatifulView : UIView
//磨皮
@property (weak, nonatomic) IBOutlet UIButton *skinButton;
//美白
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;

@property (weak, nonatomic) IBOutlet UISlider *slider;
//初始化
- (void)refreshSkinView;
//保存
- (void)confirmSkinView;
//取消
- (void)cancelSkinView;

- (void)getPhotoSkinWithBlock:(skinViewReturnBlock)block;


@end

NS_ASSUME_NONNULL_END
