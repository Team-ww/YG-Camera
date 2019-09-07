//
//  XWNaviOneTransition.h
//  trasitionpractice
//
//  Created by YouLoft_MacMini on 15/11/23.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  动画过渡代理管理的是present还是dismiss
 */
typedef enum {
    
    AnimationTypePresent,
    
    AnimationTypeDismiss
    
} AnimationType;


@interface XWNaviTransition : NSObject<UIViewControllerAnimatedTransitioning>

/**
 *  初始化动画过渡代理
 */
+ (instancetype)transitionWithType:(AnimationType)type ;
- (instancetype)initWithTransitionType:(AnimationType)type;

@end
