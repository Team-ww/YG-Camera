//
//  WaterMarkTools.m
//  YGCamera
//
//  Created by chen hua on 2019/4/16.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "WaterMarkTools.h"
#import <AVFoundation/AVFoundation.h>

@implementation WaterMarkTools


+ (void)videoAddTitlWithTitle:(NSString *)title videoURL:(NSString *)urlStr  outURL:(NSURL *)outUrl  completionHandle:(void(^)())completionHandleBlock {
    
    //创建工作台
    AVMutableComposition *workbench = [AVMutableComposition composition];
    //创建主视频和音频轨道添加到工作台
    AVMutableCompositionTrack *mainVideoTrack = [workbench addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *mainAudioTrack = [workbench addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //引入外部多媒体 创建资源轨道
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:urlStr] options:nil];
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVAssetTrack *audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    //向音视频轨道插入资源
    [mainVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    [mainAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioTrack atTime:kCMTimeZero error:nil];
    
    //获取视频资源的尺寸
    CGSize videoSize = [videoTrack naturalSize];

    UIFont *font = [UIFont systemFontOfSize:70.0];
    CATextLayer *tLayer = [[CATextLayer alloc] init];
    [tLayer setFontSize:70];
    [tLayer setString:title];
    [tLayer setAlignmentMode:kCAAlignmentCenter];
    [tLayer setForegroundColor:[[UIColor greenColor] CGColor]];
    [tLayer setBackgroundColor:[UIColor clearColor].CGColor];
    CGSize textSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [tLayer setFrame:CGRectMake(10, 200, textSize.width+20, textSize.height+10)];
    tLayer.anchorPoint = CGPointMake(0.5, 1.0);
    
    //创建父layer
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame=CGRectMake(0, 0, videoSize.width, videoSize.height);;
    //准备layer为参数，这个决定视频的大小
    CALayer *videoLayer=[CALayer layer];
    videoLayer.frame=CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:tLayer];
    //反转坐标
    parentLayer.geometryFlipped = true;
    
    //创建视频工作台
    AVMutableVideoComposition *videoWorkbench=[AVMutableVideoComposition videoComposition];
    //设置每秒播放的帧数
    videoWorkbench.frameDuration=CMTimeMake(1, 30);
    videoWorkbench.renderSize = videoSize;
    //设置视频层为“videoLayer”，设置父视层为“parentLayer”
    videoWorkbench.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    //创建视频指令
    AVMutableVideoCompositionInstruction *videoinstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    //设置时间
    videoinstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [workbench duration]);
    //工作台中的媒体资源创建轨道
    AVAssetTrack *workbenchVideoTrack = [[workbench tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //创建工作台视频指令层
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:workbenchVideoTrack];
    //视频指令中加入主工作台的资源
    videoinstruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    //添加主工作台到“videoWorkbench”工作台中
    videoWorkbench.instructions = [NSArray arrayWithObject: videoinstruction];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:workbench presetName:AVAssetExportPresetMediumQuality];
    exportSession.videoComposition=videoWorkbench;
    
    exportSession.outputURL = outUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"AVAssetExportSessionStatusUnknown");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"AVAssetExportSessionStatusWaiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"AVAssetExportSessionStatusExporting");
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"AVAssetExportSessionStatusFailed");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"AVAssetExportSessionStatusCancelled");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"export succeed");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    completionHandleBlock();
                });
                break;
        }
    }];
}


//图片添加水印
+ (UIImage *)addWaterTextWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed{
    
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size,NO,1);
    //2.绘制图片
    [image drawInRect:CGRectMake(0,0, image.size.width, image.size.height)];
     //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage =UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
    
}

@end
