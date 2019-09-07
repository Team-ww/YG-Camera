//
//  GalleryEditVC.m
//  SelFly
//
//  Created by wenhh on 2017/11/10.
//  Copyright © 2017年 AEE. All rights reserved.
//

#import "GalleryEditVC.h"
#import "XWNaviTransition.h"
#import "UIImage+Rotate.h"
#import "GalleryEditEditView.h"

#import "FWApplyFilter.h"
#import "GalleryEditFilterViews.h"
#import "GPUImage.h"
#import "GalleryEditSkinView.h"
#import "PhotoTool.h"
#import "UIView+HUD.h"
#import "TOCropViewController.h"
#import "TOCropViewControllerTransitioning.h"
#import "UIImage+CropRotate.h"
#import "CacheModel.h"
#import "constants.h"


@interface GalleryEditVC ()<UIViewControllerTransitioningDelegate,TOCropViewControllerDelegate,UIScrollViewDelegate>
{
    //当前亮度,对比度等值
    CGFloat _ContranstValue,_BrightnessValue,_SaturationValue,_ExposureValue,_SharpenValue,_HueValue,_WhiteningValue,_skinValue;
}

@property (weak, nonatomic) IBOutlet UIButton *editCorlorBtn;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIButton *skinBtn;
@property (weak, nonatomic)  UIButton *oldBtn;
@property (strong, nonatomic) IBOutlet GalleryEditEditView *editView;//编辑视图
@property (strong, nonatomic) IBOutlet GalleryEditFilterViews *customFilterView;//滤镜
@property (strong, nonatomic) IBOutlet GalleryEditSkinView *skinCareView;//美颜视图
@property (weak, nonatomic) IBOutlet UIView *titleBtnView;              //头部视图
@property (weak, nonatomic) IBOutlet UIView *bottomBtnView;             //底部按钮视图
@property (strong,nonatomic) TOCropViewController *cropController;      //转场动画控制器
@property (weak, nonatomic) IBOutlet UIScrollView *srollView;
@property (nonatomic, strong) TOCropViewControllerTransitioning *transitionController;
@property (assign, nonatomic) NSInteger filtersSelectedCount;


@end

@implementation GalleryEditVC

- (instancetype)init
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GalleryEditVC *galleryEditVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"GalleryEditVC"];
    return galleryEditVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Do any additional setup after loading the view.
    self.transitioningDelegate = self;
    [self.srollView setMaximumZoomScale:2.0f];
    [self.srollView setMinimumZoomScale:1.0f];
    [self.srollView setZoomScale:1];
    _transitionController = [[TOCropViewControllerTransitioning alloc] init];
    self.filtersSelectedCount = 0;
    _BrightnessValue=_ContranstValue=_SharpenValue=_SaturationValue=10000;
    _HueValue=_ExposureValue=_skinValue=_WhiteningValue=10000;
    self.contentImgView.image = self.originIMG;
}

//返回
- (IBAction)cancelBtnAction:(UIButton *)sender {
    self.originIMG = nil;
    [self cleanGpuImageCache];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = @"EditFILESelfly.PNG";
    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)cleanGpuImageCache{
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

//保存图片
- (IBAction)saveBtnAction:(UIButton *)sender {
    __block UIImage *img = self.contentImgView.image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PhotoTool saveImageGallery:img];
    });
    [self.view showHUDWithStr:NSLocalizedString(@"Save image...", nil) Delay:2.0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cleanGpuImageCache];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileName = @"EditFILESelfly.PNG";
        NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:filePath]) {
            [fileManager removeItemAtPath:filePath error:nil];
        }
         [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    });
    
}

//- (CGRect)checkTheVersionWith:(CGFloat)H{
//
//    UIEdgeInsets insets;
//    if(@available(iOS 11.0, *)){
//        insets = self.view.safeAreaInsets;
//    } else insets = UIEdgeInsetsZero;
//    CGRect frame = CGRectMake(insets.left, KMainScreenHeight-H-insets.bottom, KMainScreenWidth-insets.left-insets.right, H);
//    return frame;
//}

//编辑
- (IBAction)editBtnAction:(UIButton *)sender {
    __block UIImage *currentImage = self.contentImgView.image;
    [self.srollView setZoomScale:1.0f];
    [self.srollView setMaximumZoomScale:1.0f];
    _editView.frame = CGRectMake(0, KMainScreenHeight-WInsets(self.view).bottom, KMainScreenWidth-WInsets(self.view).left-WInsets(self.view).right, 128);
    [self.editView refreshEditView];
    [self.view addSubview:self.editView];
    [UIView animateWithDuration:0.5f animations:^{
        _editView.frame = CGRectMake(0, KMainScreenHeight-128-WInsets(self.view).bottom, KMainScreenWidth-WInsets(self.view).right-WInsets(self.view).left, 128);
    }];
    __weak typeof(self) weakself = self;
    self.editView.sliderValueBlock = ^(CGFloat ContranstValue, CGFloat BrightnessValue, CGFloat SaturationValue, CGFloat ExposureValue, CGFloat SharpenValue, CGFloat HueValue, NSInteger changeState) {
        switch (changeState) {
            case 0:
            {//取消编辑
                weakself.contentImgView.image = currentImage;
                currentImage = nil;
                [weakself hiddenTitleViewAndBottomView:NO];
                [weakself.srollView setMaximumZoomScale:2.0f];
            }
                break;
            case 1:
            {//编辑的过程中
                __block UIImage *tempImage;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    tempImage = [FWApplyFilter changeImageWith:BrightnessValue Contrast:ContranstValue Saturation:SaturationValue Exposure:ExposureValue Hue:HueValue Sharpen:SharpenValue Whitening:_WhiteningValue sking:_skinValue sourceimg:weakself.originIMG count:weakself.filtersSelectedCount];
                    [weakself cleanGpuImageCache];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.contentImgView.image = tempImage;
                        tempImage = nil;
                    });
                });
            }
                break;
            case 2:
            {//确定编辑
                currentImage = nil;
                [weakself hiddenTitleViewAndBottomView:NO];
                [weakself.srollView setMaximumZoomScale:2.0f];
                _ContranstValue = ContranstValue;
                _BrightnessValue = BrightnessValue;
                _SaturationValue = SaturationValue;
                _ExposureValue = ExposureValue;
                _SharpenValue = SharpenValue;
                _HueValue = HueValue;
            }
                break;
            default:
                break;
        }
    };
    
    [self hiddenTitleViewAndBottomView:YES];
}

- (void)hiddenTitleViewAndBottomView:(BOOL)ishidden{
    self.titleBtnView.hidden = ishidden;
    self.bottomBtnView.hidden = ishidden;
}

//剪切
- (IBAction)CutBtnAction:(UIButton *)sender {
    [self.srollView setZoomScale:1.0f];
    //传入原图和渲染后的图片,裁剪的流程是:同时裁剪原图和渲染后的图,但是界面显示用户看的是渲染图的裁剪画面,
    //裁剪完成后,取到的是原图,并用原图重新渲染,这样就保证用户经过各种编辑,滤镜,裁剪后,还可以复原到原图的效果.
    self.cropController = [[TOCropViewController alloc] initWithOriginal:self.originIMG WithProcessIMG:self.contentImgView.image];
    self.cropController.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.contentImgView.hidden = YES;
    });
    [self presentViewController:self.cropController animated:YES completion:nil];
    
}

//滤镜
- (IBAction)filterBtnAction:(UIButton *)sender {
    __block  UIImage *currentImage = self.contentImgView.image;
    [self.srollView setZoomScale:1.0f];
    [self.srollView setMaximumZoomScale:1.0f];
    self.customFilterView.frame = CGRectMake(0, KMainScreenHeight-WInsets(self.view).bottom, KMainScreenWidth-WInsets(self.view).left-WInsets(self.view).right, 150);
    [self.customFilterView refreshFiltersView];
    [self.view addSubview:self.customFilterView];
    [UIView animateWithDuration:0.5f animations:^{
        self.customFilterView.frame = CGRectMake(0, KMainScreenHeight-150-WInsets(self.view).bottom, KMainScreenWidth-WInsets(self.view).right-WInsets(self.view).left, 150);
        
    }];
    __weak typeof(self) weakSelf = self;
    self.customFilterView.filterReturnBlock = ^(NSInteger Row, NSInteger filterViewState) {
        
        
        switch (filterViewState) {
            case 0:
            {//点击取消按钮
                weakSelf.contentImgView.image = currentImage;
                currentImage = nil;
                [weakSelf hiddenTitleViewAndBottomView:NO];
                [weakSelf.srollView setMaximumZoomScale:2.0f];
            }
                break;
            case 1:
            {
                if (Row == 0) {
                    weakSelf.contentImgView.image = weakSelf.originIMG;
                    return ;
                }
                __block UIImage *filterTempImage;
                //开始渲染图片并赋飞imageView
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    filterTempImage = [FWApplyFilter changeImageWith:_BrightnessValue Contrast:_ContranstValue Saturation:_SaturationValue Exposure:_ExposureValue Hue:_HueValue Sharpen:_SharpenValue Whitening:_WhiteningValue sking:_skinValue sourceimg:weakSelf.originIMG count:Row];
                    //                    [weakSelf cleanGpuImageCache];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.contentImgView.image = filterTempImage;
                        filterTempImage = nil;
                    });
                });
            }
                break;
            case 2:
            {//点击确定按钮
                weakSelf.filtersSelectedCount = Row;
                currentImage = nil;
                [weakSelf hiddenTitleViewAndBottomView:NO];
                [weakSelf.srollView setMaximumZoomScale:2.0f];
            }
                break;
            default:
                break;
        }
    };
    [self hiddenTitleViewAndBottomView:YES];
}

//美颜
- (IBAction)SkinCareBtnAction:(UIButton *)sender {
    __block UIImage *currentImage = self.contentImgView.image;
    [self.srollView setZoomScale:1.0f];
    [self.srollView setMaximumZoomScale:1.0f];
    self.skinCareView.frame = CGRectMake(0, KMainScreenHeight-WInsets(self.view).bottom, KMainScreenWidth-WInsets(self.view).left-WInsets(self.view).right, 128);
    [self.skinCareView refreshSkinView];
    [self.view addSubview:self.skinCareView];
    [UIView animateWithDuration:0.5f animations:^{
        self.skinCareView.frame = CGRectMake(0, KMainScreenHeight-128-WInsets(self.view).bottom, KMainScreenWidth-WInsets(self.view).right-WInsets(self.view).left, 128);
    }];
    __weak typeof(self) weakSelf = self;
    self.skinCareView.skinReturnBlock = ^(CGFloat whiteningValue, CGFloat skinVlaue, NSInteger skinState) {
        switch (skinState) {
            case 0:
            {
                weakSelf.contentImgView.image = currentImage;
                currentImage = nil;
                [weakSelf hiddenTitleViewAndBottomView:NO];
                [weakSelf.srollView setMaximumZoomScale:2.0f];
            }
                break;
            case 1:
            {
                __block UIImage *skinTempImage;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    skinTempImage = [FWApplyFilter changeImageWith:_BrightnessValue Contrast:_ContranstValue Saturation:_SaturationValue Exposure:_ExposureValue Hue:_HueValue Sharpen:_SharpenValue Whitening:whiteningValue sking:skinVlaue sourceimg:weakSelf.originIMG count:self.filtersSelectedCount];
                    [weakSelf cleanGpuImageCache];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.contentImgView.image = skinTempImage;
                        skinTempImage = nil;
                    });
                });
            }
                break;
            case 2:
            {
                currentImage = nil;
                [weakSelf hiddenTitleViewAndBottomView:NO];
                [weakSelf.srollView setMaximumZoomScale:2.0f];
                _WhiteningValue = whiteningValue;
                _skinValue = skinVlaue;
            }
                break;
            default:
                break;
        }
    };
    [weakSelf hiddenTitleViewAndBottomView:YES];
}

#pragma mark -- UIScrollViewDelegate --------------------------------

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentImgView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    //当scrollView自身的宽度或者高度大于其contentSize的时候, 增量为:自身宽度或者高度减去contentSize宽度或者高度除以2,或者为0
    //当scrollView自身的宽度或者高度大于其contentSize的时候, 增量为:自身宽度或者高度减去contentSize宽度或者高度除以2,或者为0
    //条件运算符
    CGFloat delta_x= scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
    CGFloat delta_y= scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
    //让imageView一直居中
    //实时修改imageView的center属性 保持其居中
    self.contentImgView.center=CGPointMake(scrollView.contentSize.width/2 + delta_x, scrollView.contentSize.height/2 + delta_y);
}

#pragma mark - Cropper Delegate -

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle NS_SWIFT_NAME(cropViewController(_:didCropToImage:rect:angle:))
{
    //    self.contentImgView.hidden = YES;
    __block UIImage *cutTempImage;
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cutTempImage = [FWApplyFilter changeImageWith:_BrightnessValue Contrast:_ContranstValue Saturation:_SaturationValue Exposure:_ExposureValue Hue:_HueValue Sharpen:_SharpenValue Whitening:_WhiteningValue sking:_skinValue sourceimg:image count:self.filtersSelectedCount];
         [weakself cleanGpuImageCache];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(cutTempImage){
                self.contentImgView.image = cutTempImage;
                cutTempImage = nil;
            }else
                self.contentImgView.image = image;
            self.contentImgView.hidden = NO;
        });
    });
    self.originIMG = image;
    image = nil;
}
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled NS_SWIFT_NAME(cropViewController(_:didFinishCancelled:)) {
    self.contentImgView.hidden = NO;
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source

{
    return [XWNaviTransition transitionWithType:AnimationTypePresent];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed

{
    return [XWNaviTransition transitionWithType:AnimationTypeDismiss];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
