//
//  UIButton+Category.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Category)

@property(nonatomic,copy)void(^block)(UIButton *);

- (void)addTargetBlock:(void(^)(UIButton *sender))target;


@end

NS_ASSUME_NONNULL_END
