//
//  PhotoFilterView.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^filterViewReturnBlock)(NSInteger row,NSInteger filterViewState);

NS_ASSUME_NONNULL_BEGIN

@interface PhotoFilterView : UIView

@property (nonatomic,strong)UIImage *contentImage;

- (void)initSubViews;

- (void)cancelFilterView;

- (void)confirmFilterView;

- (void)getFilterViewWithBlock:(filterViewReturnBlock)block;

@end

NS_ASSUME_NONNULL_END
