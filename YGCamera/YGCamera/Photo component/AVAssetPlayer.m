//
//  AVAssetPlayer.m
//  Potensic
//
//  Created by chen hua on 2019/3/14.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "AVAssetPlayer.h"
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>
#import "CHPhotoFilters.h"

// Define this constant for the key-value observation context.
static const NSString *PlayerItemStatusContext;
#define REFRESH_INTERVAL   0.5f


@interface AVAssetPlayer (){
    
    CADisplayLink * _link;
    AVPlayerItemVideoOutput * _myPlayerOutput;
}

@property(nonatomic,strong)AVPlayerItem *playerItem;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVAssetImageGenerator *imageGenerator;
@property(nonatomic,strong)id timeObserver;
@property(nonatomic,strong)id itemEndObserver;
@property(nonatomic,assign)float lastPlaybackRate;

@end

@implementation AVAssetPlayer

-(NSArray *)filterNames
{
    return @[
             @"CIPhotoEffect_原生效果",
             @"CIPhotoEffectChrome",
             @"CIPhotoEffectNoir",
             @"CIPhotoEffectProcess",
             @"CIPhotoEffectTonal",
             @"CIPhotoEffectTransfer"
             ];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        //        _link.paused = YES;
        [self addUIApplicationNotification];
    }
    return self;
}

//系统状态
- (void)addUIApplicationNotification{
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(resignActive) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}


//进入后台
- (void)resignActive{
    if (_link.paused == NO) {
        [_link setPaused:YES];
        [self.player pause];
    }
}

//返回前台
- (void)enterForeground{
    
    
}

//视频数据转纹理数据
- (void)render{
    
    CMTime time = [self.playerItem currentTime];
    CVPixelBufferRef pixelBufferRef = [_myPlayerOutput copyPixelBufferForItemTime:time itemTimeForDisplay:nil];
    if (pixelBufferRef == nil) return;
    if (self.delegate && [self.delegate respondsToSelector:@selector(displayPixelBuffer:)]) {
        [self.delegate displayPixelBuffer:pixelBufferRef];  //传给OpenGL ES
    }
}

- (void)setAVAssetWithPHAsset:(PHAsset *)asset  view:(MiddlePlayerView *)view{
    
    PHVideoRequestOptions *videoRequestOptions = [[PHVideoRequestOptions alloc]init];
    videoRequestOptions.version = PHVideoRequestOptionsVersionOriginal;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequestOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.asset = asset;
            [self prepareToPlay:self.asset];
           // view.player = self.player;
            self->_filter_index = 0;
        });

    }];
}

- (void)prepareToPlay:(AVAsset *)asset{
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:&PlayerItemStatusContext];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange), kCVPixelBufferPixelFormatTypeKey, nil];
    //创建视频输出后，后面会从_myPlayerOutput里读取视频的每一帧图像信息
    _myPlayerOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:dic];
    [self.playerItem addOutput:_myPlayerOutput];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
}

- (void)play{
    [self.player play];
}

- (void)pause{
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
}


- (void)stop{
    
    [self.player setRate:0.0f];
    if ([self.delegate respondsToSelector:@selector(playbackComplete)]) {
        [self.delegate playbackComplete];
    }
}

- (void)scrubbingDidStart{
    
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
}

- (void)scrubbedToTime:(NSTimeInterval)time{
    
    [self.playerItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)scrubbingDidEnd{
    
    [self addPlayItemTimeObserver];
    if (self.lastPlaybackRate > 0.0f) {
        [self.player play];
    }
}

- (void)jumpedToTime:(NSTimeInterval)time{
    
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)generateThumbnailsWithCompletionHnadler:(void (^)(NSMutableArray * _Nonnull thumbArr))thumbBlock{
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    self.imageGenerator.maximumSize = CGSizeMake(200.0f, 0.0f);
    CMTime duration = self.asset.duration;

    NSMutableArray *arr = [NSMutableArray array];
    CMTimeValue increment = duration.value/20;
    CMTimeValue currentValue = 2.0 *duration.timescale;

    while (currentValue <= duration.value) {
        CMTime time = CMTimeMake(currentValue, duration.timescale);
        [arr addObject:[NSValue valueWithCMTime:time]];
        currentValue += increment;
    }

    __block NSUInteger imageCount = arr.count;
    __block NSMutableArray *images = [NSMutableArray array];
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:arr completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *aasetImage = [UIImage imageWithCGImage:image];

            id thumbnail = [AVAssetThumbnail thumbnailWithImage:aasetImage time:actualTime ];
            [images addObject:thumbnail];
        }else{
            NSLog(@"error ==== %@",[error localizedDescription]);
        }
        if (--imageCount == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                thumbBlock(images);
            });
        }
    }];

}


#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if (context == &PlayerItemStatusContext) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                //Set up time observers
                [self addPlayItemTimeObserver];
                [self addItemEndObserverForPlayerItem];
//                [self.player play];
            }else{
                
                NSLog(@"Error,Failed to load video");
            }
            
        });
        
    }
}

#pragma mark - Time Observers

- (void)addPlayItemTimeObserver{
    
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, NSEC_PER_SEC);  
    __weak AVAssetPlayer *weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:^(CMTime time) {

        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        if ([weakSelf.delegate respondsToSelector:@selector(updatePlayTime:duration:)]) {
            [weakSelf.delegate updatePlayTime:currentTime duration:duration];
        }
    }];
}


- (void)addItemEndObserverForPlayerItem{
    
    NSString *name = AVPlayerItemDidPlayToEndTimeNotification;
    __weak AVAssetPlayer *weakSelf = self;
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:name object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            if ([weakSelf.delegate respondsToSelector:@selector(playbackComplete)]) {
                [weakSelf.delegate playbackComplete];
            }
        }];
    }];
}


- (void)dealloc
{
    if (self.itemEndObserver) {        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self.itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        self.timeObserver = nil;
    }
    if (_link.paused == NO) {
        
        _link.paused = YES;
        [_link invalidate];
        _link = nil;
        
    }
}

@end

@implementation AVAssetThumbnail


+ (instancetype)thumbnailWithImage:(UIImage *)image time:(CMTime)time
{
    return [[self alloc] initWithImage:image time:time];
}

- (id)initWithImage:(UIImage *)image  time:(CMTime)time{
    
    self = [super init];
    if (self) {
        _image = image;
        _time = time;
    }
    return self;
}


@end


//AVVideoComposition *composition = [AVVideoComposition videoCompositionWithAsset:asset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
//
//    CIImage *source = request.sourceImage.imageByClampingToExtent;
//    if (source) {
//
//        if ((self->_filter_index = !0)) {
//
//            CIFilter *filter =  [CHPhotoFilters filterForDisplayName:[[self filterNames] objectAtIndex:self->_filter_index]];
//            [filter setValue:source forKey:kCIInputImageKey];
//            CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
//            [request finishWithImage:output context:nil];
//        }
//
//    }
//}];
//
//self.playerItem.videoComposition = composition;
