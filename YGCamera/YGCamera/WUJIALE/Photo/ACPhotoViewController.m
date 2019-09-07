//
//  ACPhotoViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACPhotoViewController.h"
#import "PhotoEditorView.h"
#import "PhotoBeatifulView.h"
#import "PhotoFilterView.h"
#import "PhotoVerbView.h"
#import "constants.h"
#import "Utils.h"
#import "GPUImageContext.h"
#import "PhotoTool.h"
#import "UIView+HUD.h"
#import "GalleryEditEditView.h"
#import "FWApplyFilter.h"
#import "TOCropViewController.h"
#import "TOCropViewControllerTransitioning.h"
#import "ROVAUIMessageTools.h"
#import "PhotoMessageViewController.h"
#import "UIViewController+MJPopupViewController.h"




#define VIEW_HEIGHT 180

@interface ACPhotoViewController ()<UIViewControllerTransitioningDelegate,TOCropViewControllerDelegate> {
    
    BOOL isPopView;
    UIButton *backItemBack;
    UIButton *saveItemBack;
    delectedImageBlock _block;
    //当前亮度,对比度等值
    CGFloat _ContranstValue,_BrightnessValue,_SaturationValue,_ExposureValue,_SharpenValue,_HueValue,_WhiteningValue,_skinValue;
}

@property (weak, nonatomic) IBOutlet UIImageView *preViewImageView;
@property (strong, nonatomic) IBOutlet PhotoEditorView *photoEditorView;
@property (strong, nonatomic) IBOutlet PhotoBeatifulView *photoBeatifulView;
@property (strong, nonatomic) IBOutlet PhotoFilterView *photoFilterView;
@property (strong, nonatomic) IBOutlet PhotoVerbView *photoVerbView;
@property (strong,nonatomic) TOCropViewController *cropController;//转场动画控制器
@property (nonatomic, strong) TOCropViewControllerTransitioning *transitionController;

@property (strong, nonatomic)UIImage *baseImage;//
@property (strong, nonatomic)UIImage *originalImage;//原图
@property (nonatomic, assign)NSInteger filtersSelectedCount;
@property (nonatomic,assign)NSInteger selectedIndex;//判断选择哪一个

@end

@implementation ACPhotoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initPhotoEditor];
    [self initBackButton];
    [self initSubViews];
    
}


- (void)initBackButton {
    
    backItemBack = [UIButton buttonWithType:UIButtonTypeCustom];
    backItemBack.frame = CGRectMake(0, 0, 44, 44);
    [backItemBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backItemBack addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    
    saveItemBack = [UIButton buttonWithType:UIButtonTypeCustom];
    saveItemBack.frame = CGRectMake(0, 0, 44, 44);
//    [saveItemBack setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveItemBack setTitle:@"保存" forState:UIControlStateNormal];
    [saveItemBack setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [saveItemBack addTarget:self action:@selector(savePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backItemBack];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveItemBack];

}


#pragma mark 初始化
- (void)initSubViews {
    
    isPopView = NO;
    self.selectedIndex = -1;
    self.filtersSelectedCount = 0;
    _BrightnessValue = _ContranstValue = _SharpenValue = _SaturationValue = 10000;
    _HueValue = _ExposureValue = _skinValue = _WhiteningValue = 10000;
    
    self.transitionController = [[TOCropViewControllerTransitioning alloc] init];
    
    CGFloat view_width = MIN(KMainScreenWidth, KMainScreenHeight);
    CGFloat view_y = MAX(KMainScreenWidth, KMainScreenHeight);
    
    self.photoEditorView.frame = CGRectMake(0, view_y, view_width, VIEW_HEIGHT);
    
    [self.photoEditorView refreshEditView];
    [self.photoEditorView.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    self.photoBeatifulView.frame = CGRectMake(0, view_y, view_width, VIEW_HEIGHT);
    [self.photoBeatifulView refreshSkinView];
    [self.photoBeatifulView.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
    self.photoBeatifulView.skinButton.layer.cornerRadius = 5;
    self.photoBeatifulView.skinButton.clipsToBounds = YES;
    self.photoBeatifulView.skinButton.layer.borderWidth = 1;
    self.photoBeatifulView.skinButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.photoBeatifulView.whiteButton.layer.cornerRadius = 5;
    self.photoBeatifulView.whiteButton.clipsToBounds = YES;
    self.photoBeatifulView.whiteButton.layer.borderWidth = 1;
    self.photoBeatifulView.whiteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.photoFilterView.frame = CGRectMake(0, view_y, view_width, VIEW_HEIGHT);
    self.photoFilterView.contentImage = self.preViewImageView.image;
    [self.photoFilterView initSubViews];

    
    self.photoVerbView.frame = CGRectMake(0, view_y, view_width, VIEW_HEIGHT);
    
    [self.view addSubview:self.photoEditorView];
//    [self.view addSubview:self.photoVerbView];
    [self.view addSubview:self.photoBeatifulView];
    [self.view addSubview:self.photoFilterView];
}


#pragma mark - 取消或返回
- (void)popView:(UIButton *)sender {
    
    if (isPopView) {
        isPopView = NO;
        self.selectedIndex = -1;
        self.title = @"照片编辑";
        [backItemBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [saveItemBack setTitle:@"保存" forState:UIControlStateNormal];
        [saveItemBack setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect viewFrame = obj.frame;
            if (viewFrame.origin.y == MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT) {
                viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    obj.frame = viewFrame;
                }];
                
                *stop = YES;
                
                if (obj == self.photoEditorView) {
                    [self.photoEditorView cancelEditorButton];
                }else if (obj == self.photoVerbView){
                    
                }else if (obj == self.photoBeatifulView){
                    [self.photoBeatifulView cancelSkinView];
                }else if (obj == self.photoFilterView){
                    [self.photoFilterView cancelFilterView];
                }
            }
        }];
//        self.preViewImageView.image = self.baseImage;
    }else{
        [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileName = @"EditFILESelfly.PNG";
        NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:filePath]) {
            [fileManager removeItemAtPath:filePath error:nil];
        }
        if ([[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

#pragma mark -保存图片
- (void)savePhoto:(UIButton *)sender {
    
    if (isPopView) {
        isPopView = NO;
        self.title = @"照片编辑";
        [backItemBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [saveItemBack setTitle:@"保存" forState:UIControlStateNormal];
        [saveItemBack setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect viewFrame = obj.frame;
            if (viewFrame.origin.y == MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT) {
                viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    obj.frame = viewFrame;
                }];
                *stop = YES;
                
                if (obj == self.photoEditorView) {
                    //保存编辑后的数据
                    [self.photoEditorView confirmEditorButton];
                }else if (obj == self.photoVerbView){
                    
                }else if (obj == self.photoBeatifulView){
                    //保存编辑后的数据
                    [self.photoBeatifulView confirmSkinView];
                }else if (obj == self.photoFilterView){
                    //保存编辑后数据
                    [self.photoFilterView confirmFilterView];
                }
            }
        }];
        
    }else{
     
        __block UIImage *img = self.preViewImageView.image;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [PhotoTool saveImageGallery:img];
        });
        
        [self.view showHUDWithStr:NSLocalizedString(@"Save image...", nil)  Delay:2.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *fileName = @"EditFILESelfly.PNG";
            NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:filePath]) {
                [fileManager removeItemAtPath:filePath error:nil];
            }
        });
    }
}




#pragma mark --Method

#pragma mark 删除

- (IBAction)photodelegate:(id)sender {
    
    BOOL isCandelete = [self.imageAsset canPerformEditOperation:PHAssetEditOperationDelete];
    
    if (isCandelete) {
        [PhotoTool deleteLocalLibrarySource:@[self.imageAsset] resultHandle:^(BOOL isSuccess, NSError * _Nullable error) {
            if (isSuccess == NO) {
                return ;
            }
            if (self->_block) {
                self->_block(self.imageAsset);
            }
            if ([[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        
        [ROVAUIMessageTools showAlertVCWithTitle:@"File deletion failed" message:@"No permission to delete,Please delete it in the system gallery" alertActionTitle:@"OK" showInVc:self];
    }
    
}

#pragma mark 分享

- (IBAction)photoShare:(id)sender {
    
    [PhotoTool shareImagesOrVideos:@[self.imageAsset] presentVC:self resultHandle:^(BOOL isSuccess, NSError * _Nullable error) {
        //NSLog(@"=======> %d",isSuccess);
    }];
}

#pragma mark 信息

- (IBAction)photoMessage:(id)sender {
    
    PhotoMessageViewController *vc = [[UIStoryboard storyboardWithName:@"PhotoMessageViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoMessageVC_ID"];
    vc.view.frame = CGRectMake(0, 0, MIN(KMainScreenWidth, KMainScreenHeight) * 0.8, MIN(KMainScreenWidth, KMainScreenHeight) * 0.8);
    vc.view.layer.cornerRadius = 10;
    vc.view.clipsToBounds = YES;
    [self presentPopupViewController:vc animationType:MJPopupViewAnimationFade];
    [PhotoTool requestDetailInfoWithAsset:self.imageAsset resultHandle:^(float mediaSize, float fps) {
        
        NSString *fileName = [self.imageAsset valueForKey:@"filename"];
        vc.fileNameLabel.text = fileName;
        vc.timeLabel.text = [Utils getForamtDateStr:self.imageAsset.creationDate];
        vc.widthLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.imageAsset.pixelWidth];
        vc.heightLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.imageAsset.pixelHeight];
        vc.formatLabel.text = @"JPEG";
        vc.fileSizeLabel.text = [NSString stringWithFormat:@"%.2fMB",mediaSize];
    }];
    
}


#pragma mark 照片编辑

- (IBAction)photoEditor:(UIButton *)sender {
    
    self.title = @"裁剪";
    [backItemBack setImage:[UIImage imageNamed:@"cancel_editor"] forState:UIControlStateNormal];
    [saveItemBack setTitle:@"" forState:UIControlStateNormal];
    [saveItemBack setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    isPopView = YES;
    self.selectedIndex = 0;
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect viewFrame = obj.frame;
        
        if ([obj isKindOfClass:[PhotoBeatifulView class]] || [obj isKindOfClass:[PhotoFilterView class]] || [obj isKindOfClass:[PhotoVerbView class]]) {
            if (viewFrame.origin.y == MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT) {
                viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    obj.frame = viewFrame;
                }];
            }
        }else if ([obj isKindOfClass:[PhotoEditorView class]]){
         
            viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT;
            [UIView animateWithDuration:0.25 animations:^{
                obj.frame = viewFrame;
            }];
            
        }
    }];
    
    self.filtersSelectedCount = 0;
    self.baseImage = self.preViewImageView.image;
//    [self.photoEditorView refreshEditView];
    
    //照片编辑回调
    __block UIImage *currentImage = self.preViewImageView.image;
    __weak typeof(self) weakSelf = self;
    [self.photoEditorView clickButtonWithBlock:^(CGFloat contranstValue, CGFloat exposureValue, CGFloat saturetionValue, CGFloat sharpenValue, CGFloat brightnessValue, CGFloat hueValue, NSInteger changeState,NSInteger index) {
        
        switch (changeState) {
            case 0://cancel
                weakSelf.preViewImageView.image = currentImage;
                currentImage = nil;
                break;
            case 1://editor
            {
                __block UIImage *tempImage = nil;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                   
                    tempImage = [FWApplyFilter changeImageWith:brightnessValue Contrast:contranstValue Saturation:saturetionValue Exposure:exposureValue Hue:hueValue Sharpen:sharpenValue Whitening:self->_WhiteningValue sking:self->_skinValue sourceimg:weakSelf.baseImage count:weakSelf.filtersSelectedCount];
                    
                    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.preViewImageView.image = tempImage;
                        tempImage = nil;
                    });
                });
            }
                break;
            case 2://confirm
                currentImage = nil;
                self->_ContranstValue = contranstValue;
                self->_BrightnessValue = brightnessValue;
                self->_SaturationValue = saturetionValue;
                self->_ExposureValue = exposureValue;
                self->_SharpenValue = sharpenValue;
                self->_HueValue = hueValue;
                break;
            default:
                break;
        }
        
    }];

    
    
}


#pragma mark 照片裁剪
- (IBAction)photoVerb:(UIButton *)sender {
    
//    isPopView = YES;
    self.selectedIndex = 1;
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect viewFrame = obj.frame;
        
        if ([obj isKindOfClass:[PhotoBeatifulView class]] || [obj isKindOfClass:[PhotoFilterView class]] || [obj isKindOfClass:[PhotoEditorView class]]) {
            if (viewFrame.origin.y == MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT) {
                viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    obj.frame = viewFrame;
                }];
            }
        }else if ([obj isKindOfClass:[PhotoVerbView class]]){
            
//            viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT;
//            [UIView animateWithDuration:0.25 animations:^{
//                obj.frame = viewFrame;
//            }];
            
        }
    }];
    
    self.baseImage = self.preViewImageView.image;
    
    self.cropController = [[TOCropViewController alloc] initWithOriginal:self.originalImage WithProcessIMG:self.preViewImageView.image];
    self.cropController.delegate = self;
    [self presentViewController:self.cropController animated:YES completion:nil];
}

#pragma mark 照片美颜
- (IBAction)photoBeaiful:(UIButton *)sender {
    
    self.title = @"美颜";
    [backItemBack setImage:[UIImage imageNamed:@"cancel_editor"] forState:UIControlStateNormal];
    [saveItemBack setTitle:@"" forState:UIControlStateNormal];
    [saveItemBack setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    isPopView = YES;
    self.selectedIndex = 2;
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect viewFrame = obj.frame;
        
        if ([obj isKindOfClass:[PhotoEditorView class]] || [obj isKindOfClass:[PhotoFilterView class]] || [obj isKindOfClass:[PhotoVerbView class]]) {
            if (viewFrame.origin.y == MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT) {
                viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    obj.frame = viewFrame;
                }];
            }
        }else if ([obj isKindOfClass:[PhotoBeatifulView class]]){
            
            viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT;
            [UIView animateWithDuration:0.25 animations:^{
                obj.frame = viewFrame;
            }];
            
        }
    }];
    
    self.baseImage = self.preViewImageView.image;
//    [self.photoBeatifulView refreshSkinView];
    
    __block UIImage *currebtImage = self.preViewImageView.image;
    __weak typeof(self) weakSelf = self;
    //sliderd回调
    [self.photoBeatifulView getPhotoSkinWithBlock:^(CGFloat whiteningValue, CGFloat skinValue, NSInteger skinState) {
        
        //NSLog(@"=======> white = %f skin = %f",whiteningValue,skinValue);
        
        switch (skinState) {
            case 0:
                weakSelf.preViewImageView.image = currebtImage;
                break;
            case 1:
            {
                __block UIImage *skinTempImage;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    skinTempImage = [FWApplyFilter changeImageWith:self->_BrightnessValue Contrast:self->_ContranstValue Saturation:self->_SaturationValue Exposure:self->_ExposureValue Hue:self->_HueValue Sharpen:self->_SharpenValue Whitening:whiteningValue sking:skinValue sourceimg:currebtImage count:self.filtersSelectedCount];
                    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.preViewImageView.image = skinTempImage;
                        skinTempImage = nil;
                    });
                });
            }
                break;
                
            case 2:
                currebtImage = nil;
                self->_WhiteningValue = whiteningValue;
                self->_skinValue = skinValue;
                break;
            default:
                break;
        }
        
    }];
    
}

#pragma mark 照片滤镜
- (IBAction)photoFilter:(UIButton *)sender {
    
    self.title = @"滤镜";
    [backItemBack setImage:[UIImage imageNamed:@"cancel_editor"] forState:UIControlStateNormal];
    [saveItemBack setTitle:@"" forState:UIControlStateNormal];
    [saveItemBack setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    isPopView = YES;
    self.selectedIndex = 3;
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect viewFrame = obj.frame;
        
        if ([obj isKindOfClass:[PhotoBeatifulView class]] || [obj isKindOfClass:[PhotoEditorView class]] || [obj isKindOfClass:[PhotoVerbView class]]) {
            if (viewFrame.origin.y == MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT) {
                viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    obj.frame = viewFrame;
                }];
            }
        }else if ([obj isKindOfClass:[PhotoFilterView class]]){
            
            viewFrame.origin.y = MAX(KMainScreenWidth, KMainScreenHeight) - VIEW_HEIGHT;
            [UIView animateWithDuration:0.25 animations:^{
                obj.frame = viewFrame;
            }];
            
        }
    }];
    
    self.baseImage = self.preViewImageView.image;

    //回调
    __weak typeof(self) weakSelf = self;
    [self.photoFilterView getFilterViewWithBlock:^(NSInteger row, NSInteger filterViewState) {
        
        switch (filterViewState) {
            case 0:
                weakSelf.preViewImageView.image = weakSelf.baseImage;
                break;
            case 1:
            {
                if (row == 0) {
                    weakSelf.preViewImageView.image = weakSelf.baseImage;
                }else{
                    __block UIImage *filterTempImage;
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        filterTempImage = [FWApplyFilter changeImageWith:self->_BrightnessValue Contrast:self->_ContranstValue Saturation:self->_SaturationValue Exposure:self->_ExposureValue Hue:self->_HueValue Sharpen:self->_SharpenValue Whitening:self->_WhiteningValue sking:self->_skinValue sourceimg:weakSelf.baseImage count:row];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.preViewImageView.image = filterTempImage;
                        });
                    });
                }
            }
                break;
            case 2:
            {
                weakSelf.filtersSelectedCount = row;
            }
                break;
            default:
                break;
        }
        
        
    }];
    
}


#pragma mark -编辑照片需要先初始化
- (void)initPhotoEditor {
    
     //编辑前先拷贝一份图片到缓存中,对缓存中的图片进行编辑而不是直接编辑图库的图片
    PHAssetResourceManager *manager = [PHAssetResourceManager defaultManager];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    PHAssetResource *source = [[PHAssetResource assetResourcesForAsset:self.imageAsset] firstObject];
    NSString *fileName = @"EditFILESelfly.PNG";
    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    NSURL  *fileURL = [NSURL fileURLWithPath:filePath];
    
    [manager writeDataForAssetResource:source toFile:fileURL options:nil completionHandler:^(NSError * _Nullable error) {

        if (!error) {
            self.preViewImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            self.baseImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            self.originalImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
        }
    }];
}


#pragma mark -取消
- (void)cancel {

    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = @"EditFILESelfly.PNG";
    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}


#pragma mark - delegate

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle NS_SWIFT_NAME(cropViewController(_:didCropToImage:rect:angle:)) {
    
    __block UIImage *cutTempImage;
//    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        cutTempImage = [FWApplyFilter changeImageWith:self->_BrightnessValue Contrast:self->_ContranstValue Saturation:self->_SaturationValue Exposure:self->_ExposureValue Hue:self->_HueValue Sharpen:self->_SharpenValue Whitening:self->_WhiteningValue sking:self->_skinValue sourceimg:image count:self.filtersSelectedCount];
         [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (cutTempImage) {
                self.preViewImageView.image = cutTempImage;
            }else{
                self.preViewImageView.image = image;
            }
        });
        
    });
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -block
- (void)deleteImageViewWithBlock:(delectedImageBlock)block {
    _block = block;

}

@end
