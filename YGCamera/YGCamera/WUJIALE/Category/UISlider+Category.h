//
//  UISlider+Category.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISlider (Category)

@property(nonatomic,copy)void(^block)(UISlider *);

- (void)addTargetWithBlock:(void(^)(UISlider *sender))target;

@end

NS_ASSUME_NONNULL_END
