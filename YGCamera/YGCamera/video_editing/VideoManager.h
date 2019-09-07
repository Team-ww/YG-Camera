//
//  VideoManager.h
//  YGCamera
//
//  Created by chen hua on 2019/5/2.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^outputBlock)(NSURL *outputURL);
typedef void(^urlAssetBlock)(AVURLAsset *urlAsset);

NS_ASSUME_NONNULL_BEGIN

@interface VideoManager : NSObject

/**
 获取 AVURLAsset
 
 @param asset PHAsset
 @param completion 回调urlAsset
 */
+ (void)getURLAssetWithAsset:(PHAsset *)asset completion:(urlAssetBlock)completion;


/**
 根据时间裁剪
 @param avAsset avAsset
 @param startTime 起始时间
 @param endTime 结束时间
 @param completion 回调视频url
 */
+ (void)cutVideoWithAVAsset:(AVAsset *)avAsset startTime:(CGFloat)startTime endTime:(CGFloat)endTime completion:(outputBlock)completion;

/**
音频、视频截取、滤镜
 
 @param videoUrl 视频url
 @param audioUrl 音频url
 @param needVoice 是否需要保留原音
 @param videoRange 视频的开始时间和时长 （设置和用法如下）
 CGFloat ff1 = [self getMediaDurationWithMediaUrl:vpath];
 NSMakeRange(0.0, ff1)
 @param completionHandle 回调
 */

+ (void)addBackgroundMiusicWithVideoUrlStr:(NSURL *)videoUrl audioUrl:(NSURL *)audioUrl needVoice:(BOOL)needVoice andCaptureVideoWithRange:(NSRange)videoRange  filterName:(NSString *)filterName completion:(outputBlock)completionHandle;



//视频滤镜



@end

NS_ASSUME_NONNULL_END
