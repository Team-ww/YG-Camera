//
//  SelectedModel.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/28.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectedModel : NSObject

@property(nonatomic,assign)NSInteger topIndex;//一级 从0开始

@property(nonatomic,assign)NSInteger bottomIndex;//二级 从0开始

@end

NS_ASSUME_NONNULL_END
