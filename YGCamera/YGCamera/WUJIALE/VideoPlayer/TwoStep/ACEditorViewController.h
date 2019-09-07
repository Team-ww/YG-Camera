//
//  ACEditorViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVAssetPlayer.h"

typedef void(^editorStartBlock)(CGFloat start);
typedef void(^editorEndBlock)(CGFloat end);
typedef void(^editorPlayBlock)(CGFloat play);

typedef void(^startBeginBlock)(CGFloat start);
typedef void(^didEndBlock)(CGFloat start);

NS_ASSUME_NONNULL_BEGIN

@interface ACEditorViewController : UIViewController

//@property(nonatomic,strong)AVURLAsset *editorAsset;

@property(nonatomic,strong)AVAssetPlayer *videoPlayer;

- (void)reloadScrollViewWith:(AVURLAsset *)asset;
//开启定时器
- (void)startTimer;
//关闭定时器
- (void)stopTimer;

//播放开始时间
- (void)editorVideoStartWirhBlock:(editorStartBlock)startBlock;
//播放结束时间
- (void)editorVideoEndWithBlock:(editorEndBlock)endBlock;
//重复播放
- (void)editorVideoPlayWithBlock:(editorPlayBlock)playBlock;


- (void)startDragViewWithBlock:(startBeginBlock)beginBlock;
- (void)EndDragViewWithBlock:(didEndBlock)didEndBlock;

@end

NS_ASSUME_NONNULL_END
