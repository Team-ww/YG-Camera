//
//  UIImageView+Animation.h
//  YGCamera
//
//  Created by chen hua on 2019/4/8.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Animation)

@property(nonatomic,assign)BOOL isAngle;


- (void)startAnimation;

- (void)endAnimation;




@end

NS_ASSUME_NONNULL_END
