//
//  AVAssetPlayer.h
//  Potensic
//
//  Created by chen hua on 2019/3/14.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MiddlePlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AVAssetPlayerDelegate <NSObject>

- (void)updatePlayTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;

- (void)playbackComplete;

- (void)displayPixelBuffer:(CVPixelBufferRef _Nullable )pixelBuffer;

@end


@class PHAsset;


@interface AVAssetPlayer : NSObject

@property(nonatomic,weak)id<AVAssetPlayerDelegate>delegate;


@property(nonatomic,strong)AVAsset *asset;
@property(nonatomic,assign)NSInteger filter_index;

- (void)setAVAssetWithPHAsset:(PHAsset *)asset  view:(MiddlePlayerView *)view;


//按钮事件
- (void)play;

- (void)pause;

- (void)stop;

//滑动条事件
- (void)scrubbingDidStart;

- (void)scrubbedToTime:(NSTimeInterval)time;

- (void)scrubbingDidEnd;

//点击缩略图对应的位置开始播放

- (void)jumpedToTime:(NSTimeInterval)time;


- (void)generateThumbnailsWithCompletionHnadler:(void(^)(NSMutableArray *thumbArr))thumbBlock;


- (void)freePlayer;



@end


@interface AVAssetThumbnail : NSObject

+(instancetype)thumbnailWithImage:(UIImage *)image time:(CMTime)time;

@property (nonatomic,readonly)CMTime time;

@property (nonatomic,readonly,strong)UIImage *image;

@end


NS_ASSUME_NONNULL_END
