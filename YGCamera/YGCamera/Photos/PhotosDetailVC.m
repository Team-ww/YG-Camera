//
//  PhotosDetailVC.m
//  YGCamera
//
//  Created by chen hua on 2019/4/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PhotosDetailVC.h"
#import "PhotosDetail_NoramlBottomView.h"
#import "PhotoTool.h"
#import "PhotosDetailCell.h"
#import "ROVAUIMessageTools.h"
#import "InfoView.h"
#import "VideoPlayerView.h"
#import "PhotoCollectionVC.h"
#import <AVKit/AVKit.h>
#import "AVAssetPlayer.h"
#import "Editing_Collectionview.h"
#import "EditiingCell.h"
#import "SAVideoRangeSlider.h"
#import "MusicAudioPlayer.h"
#import "CHPreviewView.h"
#import "CHContextManager.h"
#import "CHPhotoFilters.h"
#import "VideoManager.h"
#import "MBProgressHUD.h"
#import "GalleryEditVC.h"

@interface PhotosDetailVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,AVAssetPlayerDelegate,SAVideoRangeSliderDelegate>{
    
    AVAssetPlayer *player;
    BOOL playerIng;
    NSArray *filter_arr;
    NSArray *music_arr;
    NSInteger _index;
    MusicAudioPlayer *audioPlayer;
    
    NSInteger music_index;
    NSInteger filter_index;
}

@property (weak, nonatomic) IBOutlet UIButton *edittingButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet PhotosDetail_NoramlBottomView *normalBottomView;

//@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@property (copy, nonatomic) void(^reloadGalleryCallback)();
@property (strong, nonatomic) IBOutlet InfoView *infoView;
@property (strong, nonatomic) IBOutlet VideoPlayerView *videoPlayerView;
@property (weak, nonatomic)   IBOutlet UIView *editing_bottomView;

@property (strong, nonatomic) SAVideoRangeSlider *slider;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat endTime;
@property (strong, nonatomic) CHPreviewView *cameraPreview;

@property(nonatomic) MBProgressHUD *progressHUD;


@end

@implementation PhotosDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setCollectionViewProperty];
}

- (void)setCollectionViewProperty{
    
    self.imageCollectionView.contentSize   = CGSizeMake([UIScreen mainScreen].bounds.size.width*_localImageArr.count, 0);
    self.imageCollectionView.contentOffset = CGPointMake(([UIScreen mainScreen].bounds.size.width)*self.currentIndex, 0);
}

- (void)reloadGalleryData:(void (^)())callBack
{
    _reloadGalleryCallback = callBack;
}

- (void)refreshGalleryImageWithAsset:(PHAsset *)asset{
    
    [_localImageArr removeObject:asset];
    [self.imageCollectionView reloadData];
    self.imageCollectionView.contentOffset = CGPointMake(([UIScreen mainScreen].bounds.size.width)*self.currentIndex, 0);
}

- (IBAction)backClick:(id)sender {
    
    if (audioPlayer) {
        [audioPlayer.audioPlay stop];
    }
    [self popVC];
}

- (IBAction)topEditingClick:(UIButton *)sender {
    
    PHAsset *asset = self.localImageArr[_currentIndex];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        [self photoEdit:asset];
    }else{
        [self videoEdit:asset];
    }
}

- (void)videoEdit:( PHAsset *)asset{
    
    self.videoPlayerView.frame  = self.view.bounds;
    [self.view addSubview:self.videoPlayerView];
    if (!player) {
        player = [[AVAssetPlayer alloc]init];
        player.delegate = self;
    }
    [player stop];
    player.filter_index = 0;
    self.videoPlayerView.currentTimeLab.text = [NSString stringWithFormat:@"00:00"];
    self.videoPlayerView.totalTimeLab.text = [NSString stringWithFormat:@"%02d:%02d",(int)asset.duration/60,(int)asset.duration%60];
    self.videoPlayerView.slider.maximumValue = asset.duration;
    self.videoPlayerView.slider.value = 0;
    [self.videoPlayerView.playButton setImage:[UIImage imageNamed:@"photoIconPlay1"] forState:UIControlStateNormal];
    [player setAVAssetWithPHAsset:asset view:self.videoPlayerView.middlePlayerView];
    filter_arr = @[@"原图",@"鲜明",@"鲜暖色",@"鲜冷色",@"黑白"];
    music_arr = @[@"音乐1",@"音乐2",@"音乐3",@"音乐4",@"音乐5"];
    _index = 0;
    [self.videoPlayerView updateButtonview:self.videoPlayerView.filterButton];
    // 设置开始和结束时间的初始值
    self.startTime = 0.0;
    self.endTime = asset.duration;
    music_index = -1;
    filter_index = -1;
    
    if (!self.cameraPreview) {
//        CGRect frame = self.videoPlayerView.middlePlayerView.bounds;
        CGRect frame = [UIScreen mainScreen].bounds;
        EAGLContext *eaglContext = [CHContextManager sharedInstance].eaglContext;
        self.cameraPreview = [[CHPreviewView alloc] initWithFrame:frame context:eaglContext];
        self.cameraPreview.filter = [CHPhotoFilters defaultFilter];
        self.cameraPreview.coreImageContext = [CHContextManager sharedInstance].cicontext;
        [self.videoPlayerView.middlePlayerView addSubview:self.cameraPreview];
    }else{
        
        
        self.cameraPreview.filter = [CHPhotoFilters defaultFilter];
        self.videoPlayerView.collectionView.hidden = NO;
        self.slider.hidden = YES;
        [self.videoPlayerView.collectionView reloadData];
        
    }
    if (_slider) {
        [self.slider removeFromSuperview];
        self.slider = nil;
    }
}

- (void)photoEdit:( PHAsset *)asset{
    
    //编辑前先拷贝一份图片到缓存中,对缓存中的图片进行编辑而不是直接编辑图库的图片
    PHAssetResourceManager *manager = [PHAssetResourceManager defaultManager];
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    PHAssetResource *source = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    NSString *fileName = @"EditFILESelfly.PNG";
    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    NSURL  *fileURL = [NSURL fileURLWithPath:filePath];
    [manager writeDataForAssetResource:source toFile:fileURL options:nil completionHandler:^(NSError * _Nullable error) {
        if (!error) {
            GalleryEditVC *edtiVC = [[GalleryEditVC alloc] init];
            edtiVC.originIMG = [[UIImage alloc] initWithContentsOfFile:filePath];
            [self presentViewController:edtiVC animated:YES completion:nil];
        };
    }];
}

- (IBAction)infoclick:(id)sender {
    
    PHAsset *asset = self.localImageArr[_currentIndex];
    [PhotoTool requestDetailInfoWithAsset:asset resultHandle:^(float mediaSize, float fps) {
        
        [self->_infoView setVideoInfoWithAsset:asset mediaSize:mediaSize fps:fps];
        InfoView *view = (InfoView *)[self->_infoView copyView];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        DSHPopupContainer *container = [[DSHPopupContainer alloc] initWithCustomPopupView:view];
        container.maskColor = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:0.76];
        [container show];
    }];
}

- (IBAction)shareClick:(id)sender {
    
    PHAsset *currentAsset = [_localImageArr objectAtIndex:_currentIndex];
    [PhotoTool shareImagesOrVideos:@[currentAsset] presentVC:self resultHandle:^(BOOL isSuccess, NSError * _Nullable error) {
        NSLog(@"isSuccess ===%d",isSuccess);
    }];
}

- (IBAction)deleteClick:(id)sender {
    PHAsset *asset = self.localImageArr[_currentIndex];
    BOOL isCandelete =  [asset canPerformEditOperation:PHAssetEditOperationDelete];
    if (isCandelete) {
        
        [PhotoTool deleteLocalLibrarySource:@[asset] resultHandle:^(BOOL isSuccess, NSError *error) {
            if (isSuccess == NO) return ;
            if (self->_localImageArr.count == 1) [self popVC];
            else if (self->_localImageArr.count!= 1){
                if (self->_currentIndex == self->_localImageArr.count -1 ) self->_currentIndex --;
                else if (self->_currentIndex == 0) self->_currentIndex = 0;
                [self refreshGalleryImageWithAsset:asset];
            }
        }];
        
    }else{
        
        [ROVAUIMessageTools showAlertVCWithTitle:@"File deletion failed" message:@"No permission to delete,Please delete it in the system gallery" alertActionTitle:@"OK" showInVc:self];
    }
}

- (void)popVC{
    
    if (_reloadGalleryCallback) {
        _reloadGalleryCallback();
    }
    if ([self.navigationController.childViewControllers.firstObject isKindOfClass:[PhotoCollectionVC class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark --- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag != 55) {
        self.currentIndex = (int)scrollView.contentOffset.x/scrollView.frame.size.width;
    }
   // [self setHiddenView];
}

#pragma makr -- Delegate/DataSource
////cell的间距

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//cell的纵向距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

////cell的横向距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[Editing_Collectionview class]]) {
        return CGSizeMake(collectionView.bounds.size.height, collectionView.bounds.size.height);
    }
    return [UIScreen mainScreen].bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isKindOfClass:[Editing_Collectionview class]]) {
        if (_index == 0) {
            return filter_arr.count;
        }
        return music_arr.count;
    }
    return [self.localImageArr count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[Editing_Collectionview class]]) {
        
        EditiingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EditiingCell" forIndexPath:indexPath];
        if (_index == 0) {
            cell.name_lab.text = filter_arr[indexPath.row];
            [cell.eiditing_imageView setImage:[UIImage imageNamed:@"filter_1"]];
            cell.eiditing_imageView.contentMode = UIViewContentModeScaleToFill;
        }else{
            cell.name_lab.text = music_arr[indexPath.row];
            [cell.eiditing_imageView setImage:[UIImage imageNamed:@"musicIcon3"]];
            cell.eiditing_imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        return cell;
    }
    PhotosDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotosDetailCell" forIndexPath:indexPath];
    cell.assetImageview.userInteractionEnabled = YES;
    PHAsset *assert = self.localImageArr[indexPath.row];
    if (assert.mediaType == PHAssetMediaTypeVideo) {
        cell.videoTypeImageview.hidden = NO;
    }else{
        cell.videoTypeImageview.hidden = YES;
    }
    [cell setDataWithAssert:assert];
    [PhotoTool  requestPhotoLabraryImageforAssert:assert targetSize:CGSizeMake(assert.pixelWidth,assert.pixelHeight) contentMode:PHImageContentModeDefault resultHandler:^(UIImage *result, NSDictionary *info) {
        cell.assetImageview.image = result;
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[Editing_Collectionview class]]) {
    
        if (_index == 2 ) {
            if (audioPlayer.audioPlay.playing &&  music_index == indexPath.row) {
                return;
            }
            if (playerIng) {
                [self playClick:nil];
            }
            if (!audioPlayer) {
                audioPlayer = [[MusicAudioPlayer alloc]init];
            }
            if (audioPlayer.audioPlay.playing) {
                [audioPlayer.audioPlay stop];
            }
            music_index = indexPath.row;
            [audioPlayer playWithMusic:[[NSBundle mainBundle]pathForResource:@"Music" ofType:@"m4a"]];
        }else if (_index == 0){
            
            //NSLog(@"indexPath.row ==== %d",indexPath.row);
            filter_index = indexPath.row;
            CIFilter *filter =  [CHPhotoFilters filterForDisplayName:[[self filterNames] objectAtIndex:indexPath.row]];
            self.cameraPreview.filter = filter;
        }
    }
}

- (IBAction)indexSelected:(UIButton *)sender {
    
    PHAsset *asset = self.localImageArr[_currentIndex];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        
        PHCachingImageManager *manager = [[PHCachingImageManager alloc] init];
        [manager requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AVPlayerViewController *avPlayer = [[AVPlayerViewController alloc] init];
                avPlayer.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
                [self presentViewController:avPlayer animated:YES completion:nil];
            });
        }];
    }
}

//playView  click
- (IBAction)playClick:(UIButton *)sender {
    
    if (!playerIng) {
        [player play];
        [self.videoPlayerView.playButton setImage:[UIImage imageNamed:@"photoIconSuspend"] forState:UIControlStateNormal];
    }else{
        [player pause];
        [self.videoPlayerView.playButton setImage:[UIImage imageNamed:@"photoIconPlay1"] forState:UIControlStateNormal];
    }
    playerIng = !playerIng;
}

- (IBAction)touch_begin:(UISlider *)sender {
    
    playerIng = NO;
    [player scrubbingDidStart];
}

- (IBAction)sliderValue_changed:(UISlider *)sender {
    
    [player scrubbedToTime:(int)sender.value];
    self.videoPlayerView.currentTimeLab.text = [NSString stringWithFormat:@"%02d:%02d",(int)sender.value/60,(int)sender.value%60];
}

- (IBAction)sliderValue_touchInside:(UISlider *)sender {
    
    playerIng = YES;
    [player scrubbingDidEnd];
}

- (IBAction)remove_playerView:(UIButton *)sender {
    
    if ([self.view.subviews containsObject:self.videoPlayerView]) {
        [self.videoPlayerView removeFromSuperview];
    }
    if (playerIng) {
        [player stop];
    }
}


- (IBAction)playView_delete_click:(UIButton *)sender {
    
    [self deleteClick:nil];
}

- (IBAction)playerview_share_click:(UIButton *)sender {
    
    [self shareClick:nil];
}

- (IBAction)playerview_info_click:(UIButton *)sender {
    
    [self infoclick:nil];
}

- (void)displayPixelBuffer:(CVPixelBufferRef _Nullable )pixelBuffer{
    
    CIImage *sourceImage = [CIImage imageWithCVImageBuffer:pixelBuffer];
    [self.cameraPreview setImage:sourceImage];
    CVPixelBufferRelease(pixelBuffer);
}


- (void)updatePlayTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration{
    
    self.videoPlayerView.slider.value = currentTime;
    self.videoPlayerView.currentTimeLab.text = [NSString stringWithFormat:@"%02d:%02d",(int)currentTime/60,(int)currentTime%60];
}


- (void)playbackComplete{
    
    //[player stop];
    self.videoPlayerView.slider.value = 0;
    self.videoPlayerView.currentTimeLab.text = [NSString stringWithFormat:@"00:00"];
    playerIng = NO;
    [self.videoPlayerView.playButton setImage:[UIImage imageNamed:@"photoIconPlay1"] forState:UIControlStateNormal];
}

//编辑视图
- (IBAction)cancel_editing:(UIButton *)sender {
    if (audioPlayer) {
        [audioPlayer.audioPlay stop];
    }
    [self remove_playerView:nil];
    //self.editing_bottomView.hidden = YES;
}

- (IBAction)ok_editing:(UIButton *)sender {
    if (audioPlayer) {
        [audioPlayer.audioPlay stop];
    }
    
    //self.editing_bottomView.hidden = YES;
    [self remove_playerView:nil];
    NSURL *audioURL = nil;
    if (music_index != -1) {
        audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"Music.m4a" ofType:nil]];
        //NSLog(@"audioURL >>>>%@",audioURL);
    }
    
    NSString *filterName = [[self filterNames] objectAtIndex:0];
    if (filter_index != -1) {
        filterName = [[self filterNames] objectAtIndex:filter_index];
    }
    PHAsset *asset = self.localImageArr[_currentIndex];

    [self showProgressHUDWithMessage:@"正在生成新视频文件"];
  //  dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [VideoManager getURLAssetWithAsset:asset completion:^(AVURLAsset *urlAsset) {
            
            
            [VideoManager addBackgroundMiusicWithVideoUrlStr:urlAsset.URL audioUrl:audioURL needVoice:NO andCaptureVideoWithRange:NSMakeRange(self->_startTime, self->_endTime) filterName:filterName completion:^(NSURL *outputURL) {
                //
                [PhotoTool saveAssetFileFormWritedPath:outputURL.path];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //
                    [self hideProgressHUD:YES];
                    //[self showProgressHUDNotice:@"s" showTime:<#(NSTimeInterval)#>]
                });
                
            }];
        }];
   // });
}

- (IBAction)editing_filter_clcik:(UIButton *)sender {
    if (_index == 0) {
        return;
    }
    if (audioPlayer) {
        [audioPlayer.audioPlay stop];
    }
    _index = 0;
    self.videoPlayerView.collectionView.hidden = NO;
    
    self.slider.hidden = YES;
    [self.videoPlayerView.collectionView reloadData];
    [self.videoPlayerView updateButtonview:sender];
}

- (IBAction)editing_shera_click:(UIButton *)sender {
    
    if (_index == 1) {
        return;
    }
    if (audioPlayer) {
        [audioPlayer.audioPlay stop];
    }
    _index = 1;
    self.videoPlayerView.collectionView.hidden = YES;
    [self.videoPlayerView updateButtonview:sender];
    if (![self.videoPlayerView.collectionView.superview.subviews  containsObject:self.slider]) {
        [self.videoPlayerView.collectionView.superview addSubview:self.slider];
    }else{
        self.slider.hidden = NO;
    }
    AVURLAsset *urlAsset = player.asset;
    [self.slider getMovieFrame:urlAsset.URL];
}

- (IBAction)editing_music_click:(UIButton *)sender {
    
    if (_index == 2) {
        return;
    }
    if (audioPlayer) {
        [audioPlayer.audioPlay stop];
    }
    _index = 2;
    self.slider.hidden = YES;
    self.videoPlayerView.collectionView.hidden = NO;
    [self.videoPlayerView.collectionView reloadData];
    [self.videoPlayerView updateButtonview:sender];
}

- (SAVideoRangeSlider *)slider
{
    if (!_slider) {
        _slider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.videoPlayerView.collectionView.frame.size.height-20)];
        _slider.delegate = self;
    }
    return _slider;
}

#pragma mark - SAVideoRangeSliderDelegate
- (void)videoRange:(SAVideoRangeSlider *)videoRange isLeft:(BOOL)isLeft didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition
{
    //NSLog(@"%f ---- %f",leftPosition,rightPosition);
    float f = 0;
    if (isLeft) {
        f = leftPosition;
    }else {
        f = rightPosition;
    }
    self.startTime = leftPosition;
    self.endTime = rightPosition;
   // PHAsset *asset = self.localImageArr[_currentIndex];
    [player scrubbedToTime:f];
}

-(NSArray *)filterNames
{
    return @[
             @"CIPhotoEffect_原生效果",
             @"CIPhotoEffectChrome",
             @"CIPhotoEffectTransfer",
             @"CIPhotoEffectProcess",
             @"CIPhotoEffectNoir",
             @"CIPhotoEffectMono"
             ];
}




#pragma mark - Action Progress
- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        _progressHUD.minSize = CGSizeMake(60, 60);
        _progressHUD.minShowTime = 1;
        _progressHUD.dimBackground = YES;
        // The sample image is based on the
        // work by: http://www.pixelpressicons.com
        // licence: http://creativecommons.org/licenses/by/2.5/ca/
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MWPhotoBrowser.bundle/images/Checkmark.png"]];
        [self.view.window addSubview:_progressHUD];
    }
    return _progressHUD;
}

- (void)showProgressHUDNotice:(NSString *)message
                     showTime:(NSTimeInterval)time {
    if (message) {
        [self.progressHUD show:YES];
        self.progressHUD.labelText = message;
        self.progressHUD.mode = MBProgressHUDModeText;
        [self.progressHUD hide:YES afterDelay:time];
    } else {
        [self.progressHUD hide:YES];
    }
}

- (void)showProgressHUDWithMessage:(NSString *)message {
    
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD show:YES];
}

- (void)showProgressHUDCompleteMessage:(NSString *)message {
    
    if (message) {
        [self.progressHUD show:YES];
        self.progressHUD.labelText = message;
        self.progressHUD.detailsLabelText = nil;
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:1.0];
    } else {
        [self.progressHUD hide:YES];
    }
}

- (void)hideProgressHUD:(BOOL)animated {
    [self.progressHUD hide:animated];
}


@end
