//
//  ACVideoFilterViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^filterBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface ACVideoFilterViewController : UIViewController

@property(nonatomic,assign)NSInteger indexNumber;

@property(nonatomic,strong)NSMutableArray *filtersArr;

- (void)setVideoWithFilter:(filterBlock)block;

@end

NS_ASSUME_NONNULL_END
