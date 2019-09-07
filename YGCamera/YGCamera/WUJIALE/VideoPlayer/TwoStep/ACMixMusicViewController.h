//
//  ACMixMusicViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^checkMusicBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface ACMixMusicViewController : UIViewController

@property(nonatomic,assign)NSInteger indexNumber;

- (void)setMusicWithBlock:(checkMusicBlock)block;

@end

NS_ASSUME_NONNULL_END
