//
//  ACVideoEditorViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACVideoEditorViewController.h"
#import <AVKit/AVKit.h>
#import "constants.h"
#import "Utils.h"
#import "ACVideoEditorDetailsViewController.h"
#import "AVAssetPlayer.h"
#import "ACVideoSliderViewController.h"
#import "CHPreviewView.h"
#import "CHContextManager.h"
#import "CHPhotoFilters.h"
#import "ACVideoFilterViewController.h"
#import "MusicAudioPlayer.h"
#import "ACMixMusicViewController.h"
#import "ACEditorViewController.h"
#import "PhotoTool.h"
#import "ACVideoMessageViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ROVAUIMessageTools.h"
#import "VideoManager.h"
#import "MBProgressHUD.h"

@interface ACVideoEditorViewController ()<AVAssetPlayerDelegate> {
    
    NSArray *musicURLArr;
    MusicAudioPlayer *audioPlayer;
    AVAssetPlayer *player;
    NSMutableArray *firstImageViewArr;
    deleteAssetBlock _block;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet MiddlePlayerView *middlePlayerView;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;
@property (nonatomic,strong)CHPreviewView *cameraPreView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *editorButton;

@property(nonatomic,assign)CGFloat startTime;
@property(nonatomic,assign)CGFloat endTime;

@end

@implementation ACVideoEditorViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.playerButton.selected = NO;
    [player play];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [player stop];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置title
    self.title = @"视频编辑";

    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 44, 44);
    [back setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(clickButtonBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = left;
    
    //设置源视频起始时间
    self.startTime = 0.0;
    //如果视频总时长大于10s，默认为10s，否则按视频最长时间
    self.endTime = self.videoAsset.duration;
    
    //设置播放按钮状态
    self.playerButton.selected = YES;
    self.playerButton.hidden = YES;
    //保存视频第一帧，用来滤镜显示
    firstImageViewArr = [[NSMutableArray alloc] init];
    
    player = [[AVAssetPlayer alloc] init];
    player.delegate = self;
    [player setAVAssetWithPHAsset:self.videoAsset view:self.middlePlayerView];

    CGFloat playerWidth = MIN(KMainScreenWidth, KMainScreenHeight);
    CGFloat playerHeight = playerWidth * 9/16;
    
    EAGLContext *context = [CHContextManager sharedInstance].eaglContext;
    self.cameraPreView = [[CHPreviewView alloc] initWithFrame:CGRectMake(0, 0, playerWidth, playerHeight) context:context];
    self.cameraPreView.userInteractionEnabled = YES;
    self.cameraPreView.filter = [CHPhotoFilters defaultFilter];
    self.cameraPreView.coreImageContext = [CHContextManager sharedInstance].cicontext;
    [self.middlePlayerView addSubview:self.cameraPreView];
    
    ACVideoEditorDetailsViewController *details = self.childViewControllers[1];
    //滤镜VC
    ACVideoFilterViewController *filterVC = details.childViewControllers[0];
    //视频编辑VC
    ACEditorViewController *editorVC = details.childViewControllers[1];
    //添加音乐VC
    ACMixMusicViewController *mixVC = details.childViewControllers[2];
    
    NSString *musicURL = [[NSBundle mainBundle] pathForResource:@"Music" ofType:@"m4a"];
    musicURLArr = @[musicURL,musicURL,musicURL,musicURL,musicURL];
    audioPlayer = [[MusicAudioPlayer alloc] init];
    
    //取消编辑
    [details clickButtonCancelWithBlock:^{
        if (self->audioPlayer.audioPlay.playing) {
            [self->audioPlayer.audioPlay stop];
        }
        [self.mainScrollView setContentOffset:CGPointZero animated:YES];
        [self.editorButton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ((UIButton *)obj).selected = NO;
        }];
       //关闭剪切界面定时器
        [editorVC stopTimer];
    }];
    //保存编辑视频
    [details clickButtonSaveEditorVideoWithBlock:^{
        //音乐停止
        if (self->audioPlayer.audioPlay.playing) {
            [self->audioPlayer.audioPlay stop];
        }
        //按钮复位
        [self.editorButton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ((UIButton *)obj).selected = NO;
        }];
        //停止计时器-视频编辑界面
        [editorVC stopTimer];
        //保存视频
        //判断是否进行滤镜
//        filterVC.indexNumber != 0
//        mixVC.indexNumber != -1
        
        NSURL *audoURL = nil;
        if (mixVC.indexNumber != -1) {
            audoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"Music.m4a" ofType:nil]];
        }
        
        NSString *filterName = [[self filterNames] objectAtIndex:0];
        if (filterVC.indexNumber != 0) {
            filterName = [[self filterNames] objectAtIndex:filterVC.indexNumber];
        }
        
        //提示视频合成信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"正在生成新视频文件";
        hud.label.textColor = [UIColor whiteColor];
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.userInteractionEnabled = NO;
        
        [VideoManager getURLAssetWithAsset:self.videoAsset completion:^(AVURLAsset *urlAsset) {
            
            [VideoManager addBackgroundMiusicWithVideoUrlStr:urlAsset.URL 
                                                    audioUrl:audoURL
                                                   needVoice:(audoURL == nil ? YES : NO)
                                    andCaptureVideoWithRange:NSMakeRange(self.startTime, self.endTime-self.startTime)
                                                  filterName:filterName
                                                  completion:^(NSURL *outputURL) {
                                                      
                                                      [PhotoTool saveAssetFileFormWritedPath:outputURL.path];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [hud hideAnimated:YES];
                                                      });
                                                      
                                                  }];
            
        }];
        
    }];
    //滤镜界面
    [filterVC setVideoWithFilter:^(NSInteger index) {
        CIFilter *filter = [CHPhotoFilters filterForDisplayName:[self filterNames][index]];
        self.cameraPreView.filter = filter;
    }];
    
    
//    ACMixMusicViewController *mixVC = details.childViewControllers[2];
    [mixVC setMusicWithBlock:^(NSInteger index) {
        if (self->audioPlayer.audioPlay.playing) {
            [self->audioPlayer.audioPlay stop];
        }
        [self->audioPlayer playWithMusic:(NSString *)(self->musicURLArr[index])];
    }];
    
    //编辑视频界面
    [editorVC editorVideoStartWirhBlock:^(CGFloat start) {
        self->_startTime = start;
        [self->player scrubbedToTime:start];
        NSLog(@"=====> video start time = %f",start);
    }];
    [editorVC editorVideoEndWithBlock:^(CGFloat end) {
        self->_endTime = end;
    }];
    
    [editorVC editorVideoPlayWithBlock:^(CGFloat play) {
        
        [self->player scrubbedToTime:play];
         NSLog(@"=====> video start play = %f",play);
    }];
    
    [editorVC startDragViewWithBlock:^(CGFloat start) {
        [self->player scrubbingDidStart];
    }];
    
    [editorVC EndDragViewWithBlock:^(CGFloat start) {
        [self->player scrubbingDidEnd];
    }];
    
    //slider界面
    ACVideoSliderViewController *sliderVC = self.childViewControllers[0];
    sliderVC.startLabel.text = @"00:00";
    sliderVC.endLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)self.videoAsset.duration/60,(int)self.videoAsset.duration%60];
    sliderVC.playerSlider.maximumValue = self.videoAsset.duration;
    sliderVC.playerSlider.value = 0;
    [sliderVC.playerSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    //slider滑动事件
    [sliderVC.playerSlider addTarget:self action:@selector(sliderBegin:) forControlEvents:UIControlEventTouchDown];
    [sliderVC.playerSlider addTarget:self action:@selector(sliderInSide:) forControlEvents:UIControlEventTouchUpInside];
    [sliderVC.playerSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //player添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlayerButton:)];
    [self.middlePlayerView addGestureRecognizer:tapGesture];
}

#pragma mark - 点击返回
- (void)clickButtonBack:(UIButton *)sender {
    if ([[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 手势事件
- (void)showPlayerButton:(UITapGestureRecognizer *)tap {
    
    self.playerButton.hidden = !self.playerButton.hidden;
}


#pragma mark - 开始滑动
- (void)sliderBegin:(UISlider *)slider {
    [player scrubbingDidStart];
}

#pragma mark - 结束滑动
- (void)sliderInSide:(UISlider *)slider {
    [player scrubbingDidEnd];
}

#pragma mark 滑动播放条
- (void)sliderValueChanged:(UISlider *)slider {
    
    [player scrubbedToTime:(int)slider.value];
    
    ACVideoSliderViewController *sliderVC = self.childViewControllers[0];
    sliderVC.startLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)slider.value/60,(int)slider.value%60];
}


#pragma mark 播放/停止

- (IBAction)clickButtonPlay:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [player pause];
    }else{
        [player play];
    }
    sender.hidden = YES;
}

#pragma mark 删除

- (IBAction)clickButtonDelegate:(id)sender {
    
    BOOL isCandelete = [self.videoAsset canPerformEditOperation:PHAssetEditOperationDelete];
    
    if (isCandelete) {
        
        [PhotoTool deleteLocalLibrarySource:@[self.videoAsset] resultHandle:^(BOOL isSuccess, NSError * _Nullable error) {
            if (isSuccess == NO) {
                return ;
            }
            if (self->_block) {
                self->_block();
            }
            if ([[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else
            //返回上一页进行刷新
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }else{
        
        [ROVAUIMessageTools showAlertVCWithTitle:@"File deletion failed" message:@"No permission to delete,Please delete it in the system gallery" alertActionTitle:@"OK" showInVc:self];
    }
}

#pragma mark 分享
- (IBAction)clickButtonShare:(id)sender {
    
    [PhotoTool shareImagesOrVideos:@[self.videoAsset] presentVC:self resultHandle:^(BOOL isSuccess, NSError * _Nullable error) {
        NSLog(@"===> share is success = %d",isSuccess);
    }];
    
}

#pragma mark 视频信息
- (IBAction)clickButtonMessage:(id)sender {
    
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    ACVideoMessageViewController *messageVC = [[UIStoryboard storyboardWithName:@"ACVideoMessageViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoMessageVC_ID"];
    messageVC.view.frame = CGRectMake(0, 0, width * 0.8, width * 0.6);
    messageVC.view.layer.cornerRadius = 10;
    messageVC.view.clipsToBounds = YES;
    [PhotoTool requestDetailInfoWithAsset:self.videoAsset resultHandle:^(float mediaSize, float fps) {
        
        messageVC.fileNameLabel.text = [self.videoAsset valueForKey:@"filename"];
        messageVC.timeLabel.text = [Utils getForamtDateStr:self.videoAsset.creationDate];
        messageVC.widthLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.videoAsset.pixelWidth];
        messageVC.heightLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.videoAsset.pixelHeight];
        messageVC.formLabel.text = @"mp4";
        messageVC.fileSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",mediaSize];
        [self presentPopupViewController:messageVC animationType:MJPopupViewAnimationFade];
    }];
    
    
    
}

#pragma mark 滤镜
- (IBAction)clickButtonFilter:(id)sender {
    //需要先判断mainScrollView是否已经偏移过，如果已经偏移过，就无须再进行偏移，否则需要先进行偏移
    //判断scrollView偏移距离
    [self scrollViewContentOffset];
    if (audioPlayer.audioPlay.playing) {
        [audioPlayer.audioPlay stop];
    }
    ACVideoEditorDetailsViewController *details = self.childViewControllers[1];
    [details.mainScrollView setContentOffset:CGPointZero animated:YES];
    ACVideoFilterViewController *filterVC = details.childViewControllers[0];
    
    
    if (firstImageViewArr.count == 0) {
        AVURLAsset *asset = (AVURLAsset *)player.asset;
        AVAssetImageGenerator *imageGenerator =
        [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        imageGenerator.maximumSize = CGSizeMake(100.0f, 0.0f);
        imageGenerator.appliesPreferredTrackTransform = YES;
        //获取单帧图片
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:kCMTimeZero
                                                     actualTime:NULL
                                                          error:nil];
        
        [firstImageViewArr addObject:[UIImage imageWithCGImage:imageRef]];
        [[self imageFilter] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CIImage *ciImage = [CIImage imageWithCGImage:imageRef];
            
            CIFilter *filter = [CIFilter filterWithName:obj keysAndValues:kCIInputImageKey,ciImage, nil];
            
            [filter setDefaults];
            
            CIImage *outputImage = [filter outputImage];
            
            CIContext *context = [CIContext contextWithOptions:nil];
            
            CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
            
            UIImage *image = [UIImage imageWithCGImage:cgImage];
            
            [self->firstImageViewArr addObject:image];
            
            CGImageRelease(cgImage);
            
        }];
    }
    
    filterVC.filtersArr = firstImageViewArr;

    [self.editorButton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            ((UIButton *)obj).selected = NO;
        }else{
            ((UIButton *)obj).selected = YES;
        }
    }];
}
#pragma mark 视频编辑
- (IBAction)clickButtonEditor:(id)sender {
    //需要先判断mainScrollView是否已经偏移过，如果已经偏移过，就无须再进行偏移，否则需要先进行偏移
    [self scrollViewContentOffset];
    if (audioPlayer.audioPlay.playing) {
        [audioPlayer.audioPlay stop];
    }
    
    ACVideoEditorDetailsViewController *details = self.childViewControllers[1];
    ACEditorViewController *editorVC = details.childViewControllers[1];
    //开启定时器
    [editorVC startTimer];
    //播放从头开始
    [player scrubbedToTime:0];

    editorVC.videoPlayer = player;
    [editorVC reloadScrollViewWith:(AVURLAsset *)player.asset];
//    ACVideoEditorDetailsViewController *details = self.childViewControllers[1];
    [details.mainScrollView setContentOffset:CGPointMake(0, [self getScrollViewHeight] - 60) animated:YES];
    
    [self.editorButton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 1) {
            ((UIButton *)obj).selected = NO;
        }else{
            ((UIButton *)obj).selected = YES;
        }
    }];
    
}
#pragma mark 添加音乐
- (IBAction)clickButtonAddMusic:(id)sender {
    //需要先判断mainScrollView是否已经偏移过，如果已经偏移过，就无须再进行偏移，否则需要先进行偏移
    [self scrollViewContentOffset];
    
    ACVideoEditorDetailsViewController *details = self.childViewControllers[1];
    [details.mainScrollView setContentOffset:CGPointMake(0, ([self getScrollViewHeight] - 60) * 2) animated:YES];
    
    [self.editorButton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 2) {
            ((UIButton *)obj).selected = NO;
        }else{
            ((UIButton *)obj).selected = YES;
        }
    }];
}


#pragma mark 获取scrollView的contentOffset
- (void)scrollViewContentOffset {
    
    if (self.mainScrollView.contentOffset.y == 0) {
        [self.mainScrollView setContentOffset:CGPointMake(0, [self getScrollViewHeight]) animated:YES];
    }
}

#pragma mark 获取自适应View的高度
- (CGFloat)getScrollViewHeight {
    
    CGFloat offsetH = 0;
    if ([Utils isiphoneX]) {
        offsetH = MAX(KMainScreenWidth, KMainScreenHeight) - 84 - 34 - 100 - 100 - MIN(KMainScreenWidth, KMainScreenHeight) * 9/16.0;
    }else{
        offsetH = MAX(KMainScreenWidth, KMainScreenHeight) - 64 - 100 - 100 - MIN(KMainScreenWidth, KMainScreenHeight) * 9/16.0;
    }
    
    return offsetH;
}


-(NSArray *)filterNames {
    
    return @[
             @"CIPhotoEffect_原生效果",
             @"CIPhotoEffectTonal",
             @"CIPhotoEffectFade",
             @"CIPhotoEffectNoir"//黑白
//             @"CIPhotoEffectNoir",
//             @"CIPhotoEffectMono"
             ];
}



#pragma mark -player delegate

- (void)updatePlayTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    
    ACVideoSliderViewController *sliderVC = self.childViewControllers[0];
    sliderVC.playerSlider.value = currentTime;
    sliderVC.startLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)currentTime/60,(int)currentTime%60];
}

- (void)playbackComplete {
    
    ACVideoSliderViewController *sliderVC = self.childViewControllers[0];
    sliderVC.playerSlider.value = 0;
    sliderVC.startLabel.text = @"00:00";
    self.playerButton.hidden = NO;
    self.playerButton.selected = YES;
}

- (void)displayPixelBuffer:(CVPixelBufferRef _Nullable )pixelBuffer {
    
    CIImage *sourceImage = [CIImage imageWithCVImageBuffer:pixelBuffer];
    [self.cameraPreView setImage:sourceImage];
    CVPixelBufferRelease(pixelBuffer);
}


- (NSArray *)imageFilter{
    
    return @[
             @"CIPhotoEffectTonal",
             @"CIPhotoEffectFade",
             @"CIPhotoEffectNoir"
             ];
}

#pragma mark -block
- (void)selectedVideoWithBlock:(deleteAssetBlock)block {
    
    _block = block;
}



@end
