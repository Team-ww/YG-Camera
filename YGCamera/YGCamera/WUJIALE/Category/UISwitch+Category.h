//
//  UISwitch+Category.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISwitch (Category)

@property(nonatomic,copy)void(^block)(UISwitch *);

- (void)addTargetWithBlock:(void(^)(UISwitch *sender))target;

@end

NS_ASSUME_NONNULL_END
