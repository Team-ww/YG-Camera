//
//  XWNaviOneTransition.m
//  trasitionpractice
//
//  Created by YouLoft_MacMini on 15/11/23.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import "XWNaviTransition.h"
#import "PhotosDetailVC.h"
#import "PhotosDetailCell.h"
#import "GalleryEditVC.h"

@interface XWNaviTransition ()

@property (nonatomic, assign) AnimationType type;

@end

@implementation XWNaviTransition

+ (instancetype)transitionWithType:(AnimationType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(AnimationType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext

{
    
    return 0.5;
    
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.type == AnimationTypePresent) {
        
        //获取两个VC 和 动画发生的容器
        PhotosDetailVC *fromVC = (PhotosDetailVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        GalleryEditVC *toVC   = (GalleryEditVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *containerView = [transitionContext containerView];
        //对Cell上的 imageView 截图，同时将这个 imageView 本身隐藏
        //NSLog(@"currentIndex ==== %ld",(long)fromVC.currentIndex);
        NSIndexPath *indexs = [NSIndexPath indexPathForRow:fromVC.currentIndex inSection:0];
        PhotosDetailCell *cell =(PhotosDetailCell *)[fromVC.imageCollectionView cellForItemAtIndexPath:indexs];

        UIView *snapShotView = [UIView new];
        snapShotView.layer.contents = (__bridge id)cell.assetImageview.image.CGImage;
        [snapShotView setContentMode:UIViewContentModeScaleAspectFit];
        snapShotView.frame = fromVC.finalCellRect = [containerView convertRect:cell.assetImageview.frame fromView:cell.assetImageview.superview.superview];
        cell.assetImageview.hidden = YES;
        //设置第二个控制器的位置、透明度
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha = 0;
        toVC.contentImgView.hidden = YES;
//        toVC.contentImgView.image = cell.contentImV.image;
        [toVC.contentImgView setContentMode:UIViewContentModeScaleAspectFit];
        //把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
        [containerView addSubview:toVC.view];
        [containerView addSubview:snapShotView];
        
        //动起来。第二个控制器的透明度0~1；让截图SnapShotView的位置更新到最新；
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
            [containerView layoutIfNeeded];
            toVC.view.alpha = 1.0;
            CGRect toRect = [containerView convertRect:snapShotView.frame toView:toVC.view];
            snapShotView.frame = toRect;
        } completion:^(BOOL finished) {
            //为了让回来的时候，cell上的图片显示，必须要让cell上的图片显示出来
            toVC.contentImgView.hidden = NO;
            cell.assetImageview.hidden = NO;
            [snapShotView removeFromSuperview];
            //告诉系统动画结束
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
        
        
    } else {
        //获取动画前后两个VC 和 发生的容器containerView
        PhotosDetailVC *toVC = (PhotosDetailVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        GalleryEditVC *fromVC = (GalleryEditVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        
        //在前一个VC上创建一个截图
        UIView  *snapShotView = [fromVC.contentImgView snapshotViewAfterScreenUpdates:NO];
        snapShotView.backgroundColor = [UIColor clearColor];
        snapShotView.frame = [containerView convertRect:fromVC.contentImgView.frame fromView:fromVC.contentImgView.superview];
        fromVC.contentImgView.hidden = YES;
        //初始化后一个VC的位置
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        
        //获取toVC中图片的位置
        NSIndexPath *currentPath = [NSIndexPath indexPathForRow:toVC.currentIndex inSection:0];
        PhotosDetailCell *cell = (PhotosDetailCell *)[toVC.imageCollectionView cellForItemAtIndexPath:currentPath];
        cell.assetImageview.hidden = YES;
        
        
        //顺序很重要，
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
        [containerView addSubview:snapShotView];
        
        //发生动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromVC.view.alpha = 0.0f;
            snapShotView.frame = toVC.finalCellRect;
        } completion:^(BOOL finished) {
            [snapShotView removeFromSuperview];
            fromVC.contentImgView.hidden = NO;
            cell.assetImageview.hidden = NO;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
