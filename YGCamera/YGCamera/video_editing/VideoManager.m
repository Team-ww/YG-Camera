//
//  VideoManager.m
//  YGCamera
//
//  Created by chen hua on 2019/5/2.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "VideoManager.h"

@implementation VideoManager

+ (void)getURLAssetWithAsset:(PHAsset *)asset completion:(urlAssetBlock)completion
{
    // 保证其他格式（比如慢动作）视频为正常视频
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    [[PHCachingImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        if (completion) {
            completion(urlAsset);
        }
    }];
}

//音频资源时长大于=视频时长 ok
//音频时长小于视频时长   音频追加

+ (void)addBackgroundMiusicWithVideoUrlStr:(NSURL *)videoUrl audioUrl:(NSURL *)audioUrl needVoice:(BOOL)needVoice andCaptureVideoWithRange:(NSRange)videoRange  filterName:(NSString *)filterName completion:(outputBlock)completionHandle{
    
    //AVURLAsset此类主要用于获取媒体信息，包括视频、声音等
    AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:audioUrl options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    //创建AVMutableComposition对象来添加视频音频资源的AVMutableCompositionTrack
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //CMTimeRangeMake(start, duration),start起始时间，duration时长，都是CMTime类型
    //CMTimeMake(int64_t value, int32_t timescale)，返回CMTime，value视频的一个总帧数，timescale是指每秒视频播放的帧数，视频播放速率，（value / timescale）才是视频实际的秒数时长，timescale一般情况下不改变，截取视频长度通过改变value的值
    //CMTimeMakeWithSeconds(Float64 seconds, int32_t preferredTimeScale)，返回CMTime，seconds截取时长（单位秒），preferredTimeScale每秒帧数
    //开始位置startTime
    CMTime startTime = CMTimeMakeWithSeconds(videoRange.location, videoAsset.duration.timescale);
    //截取长度videoDuration
    CMTime videoDuration = CMTimeMakeWithSeconds(videoRange.length, videoAsset.duration.timescale);
    CMTimeRange videoTimeRange = CMTimeRangeMake(startTime, videoDuration);
    
    //视频采集compositionVideoTrack
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //TimeRange截取的范围长度
    //ofTrack来源
    //atTime插放在视频的时间位置
    [compositionVideoTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeVideo].count>0) ? [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject : nil atTime:kCMTimeZero error:nil];
    if (needVoice) {
        //视频声音采集(也可不执行这段代码不采集视频音轨，合并后的视频文件将没有视频原来的声音)
        AVMutableCompositionTrack *compositionVoiceTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [compositionVoiceTrack insertTimeRange:videoTimeRange ofTrack:([videoAsset tracksWithMediaType:AVMediaTypeAudio].count>0)?[videoAsset tracksWithMediaType:AVMediaTypeAudio].firstObject:nil atTime:kCMTimeZero error:nil];
    }
    
    if (audioUrl) {
        //声音长度截取范围==视频长度
        CMTimeRange audioTimeRange = CMTimeRangeMake(kCMTimeZero, videoDuration);
        //音频采集compositionCommentaryTrack
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        CGFloat time_audio = audioAsset.duration.value/audioAsset.duration.timescale;
        
        //NSLog(@"audioAsset.duration ===>>>%f",audioAsset.duration.timescale);
        CGFloat time_video = videoAsset.duration.value/videoAsset.duration.timescale;
        int multiple = 1;
        CGFloat remainder = 0;
        if (time_video > time_audio) {
            multiple = time_video /time_audio;
            remainder = time_video - multiple *time_audio;
            for (int i = 0; i < multiple; i++) {
                CMTime audio_start_time = CMTimeMake(audioAsset.duration.timescale *time_audio *i, audioAsset.duration.timescale);
                CMTime duration = audioAsset.duration;
                if (i ==multiple -1 &&   remainder == 0) {
                    break;
                }else if(i == multiple -1){
                    duration = CMTimeMakeWithSeconds(remainder *videoAsset.duration.timescale, videoAsset.duration.timescale);
                }
                CMTimeRange audio_range_time = CMTimeRangeMake(audio_start_time, audio_start_time);
                [compositionAudioTrack insertTimeRange:audio_range_time ofTrack:([audioAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) ? [audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject : nil atTime:audio_start_time error:nil];
            }
            
        }else{
            
            [compositionAudioTrack insertTimeRange:audioTimeRange ofTrack:([audioAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) ? [audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject : nil atTime:kCMTimeZero error:nil];
        }
    }

    //AVAssetExportSession用于合并文件，导出合并后文件，presetName文件的输出类型
    AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    NSURL *outPutPath = [self filePathWithFileName:@"cutVideo.mp4"];
    //输出视频格式 AVFileTypeMPEG4 AVFileTypeQuickTimeMovie...
    assetExportSession.outputFileType = AVFileTypeMPEG4;
    //NSArray *fileTypes = assetExportSession.
    assetExportSession.outputURL = outPutPath;
    //输出文件是否网络优化
    assetExportSession.shouldOptimizeForNetworkUse = YES;
    if (filterName != nil && ![filterName hasPrefix:@"CIPhotoEffect_原生效果"]) {
        
        CIFilter *filter = [CIFilter filterWithName:filterName];
        AVMutableVideoComposition *mainComposition = [AVMutableVideoComposition videoCompositionWithAsset:videoAsset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                CIImage *source = request.sourceImage.imageByClampingToExtent;
                if (source) {
                    [filter setValue:source forKey:kCIInputImageKey];
                    CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
                    [request finishWithImage:output context:nil];
                }else{
                    
                }
                
            });
        }];
        assetExportSession.videoComposition = mainComposition;
    }
    [assetExportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if ([assetExportSession status] == AVAssetExportSessionStatusCompleted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandle) {
                    completionHandle(assetExportSession.outputURL);
                }
            });
            //存在临时数据缓存区
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"导出失败");
            });
        }
    }];
}

+ (NSURL *)filePathWithFileName:(NSString *)fileName
{
    // 获取沙盒 temp 路径
    NSString *tempPath = NSTemporaryDirectory();
    tempPath = [tempPath stringByAppendingPathComponent:@"Video"];
    NSFileManager *manager = [NSFileManager defaultManager];
    // 判断文件夹是否存在 不存在创建
    BOOL exits = [manager fileExistsAtPath:tempPath isDirectory:nil];
    if (!exits) {
        // 创建文件夹
        [manager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 创建视频存放路径
    tempPath = [tempPath stringByAppendingPathComponent:fileName];
    // 判断文件是否存在
    if ([manager fileExistsAtPath:tempPath isDirectory:nil]) {
        // 存在 删除之前的视频
        [manager removeItemAtPath:tempPath error:nil];
    }
    return [NSURL fileURLWithPath:tempPath];
}

@end
