//
//  PhotoCollectionVC.m
//  YGCamera
//
//  Created by chen hua on 2019/4/10.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PhotoCollectionVC.h"
#import "PhotoTool.h"
#import "NoPhotosCell.h"
#import "GalleryDateCell.h"
#import "GalleryPreImageCell.h"
#import "Utils.h"
#import "ROVAUIMessageTools.h"
#import "PhotoThumbBottomView.h"
#import "NoPhotosCell.h"
#import "PhotosDetailVC.h"
#import "ACVideoEditorViewController.h"
#import "ACPhotoViewController.h"

@interface PhotoCollectionVC ()<UINavigationControllerDelegate>{
    
    BOOL isAllselected;
    BOOL isNoPhotos;
}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButtonItem;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (assign,nonatomic)  BOOL iEditingMode;
@property (strong, nonatomic) NSMutableArray *localImageArr;
@property (strong, nonatomic) NSMutableArray *localDateArr;
@property (strong, nonatomic) NSMutableArray *selectDateArr;
@property (strong, nonatomic) IBOutlet PhotoThumbBottomView *thumbBottomView;
@end

@implementation PhotoCollectionVC


- (void)viewDidLoad {
    
    [super viewDidLoad];
    isAllselected = NO;
    self.navigationController.delegate = self;
    [self.selectButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]} forState:UIControlStateNormal];
    self.selectDateArr = [NSMutableArray array];
    [self getLibrarySource:CameraSource_HandleType_Collection];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)getLibrarySource:(CameraSource_HandleType)type{

    NSMutableArray *arr = [NSMutableArray arrayWithArray: [PhotoTool fetchResultWithType:type]];
    self.localDateArr = [arr[0] mutableCopy];
    self.localImageArr = [arr[1] mutableCopy];
    if (self.localDateArr.count != 0) {
        isNoPhotos = NO;
    }else{
        isNoPhotos = YES;
    }
}

- (IBAction)segmentControlClick:(UISegmentedControl *)sender {
    
    if (_iEditingMode) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenBar" object:@(NO)];
        _iEditingMode = NO;
        [self.selectButtonItem setTitle:@"选择"];
        [self.thumbBottomView removeFromSuperview];
        [self.selectDateArr removeAllObjects];
    }
    [self getLibrarySource:sender.selectedSegmentIndex];
    [self.collectionView reloadData];
}


- (IBAction)selectButtonItemClick:(UIBarButtonItem *)sender {
    
    if (!_iEditingMode) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenBar" object:@(YES)];
        _iEditingMode = YES;
        [self.selectButtonItem setTitle:@"取消"];
       self.thumbBottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -80, [UIScreen mainScreen].bounds.size.width, 80);
        [self.navigationController.view addSubview:self.thumbBottomView];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenBar" object:@(NO)];
        _iEditingMode = NO;
        [self.selectButtonItem setTitle:@"选择"];
        [self.thumbBottomView removeFromSuperview];
        [self.selectDateArr removeAllObjects];
    }
    [self getLibrarySource:self.segmentControl.selectedSegmentIndex];
    [self.collectionView reloadData];
}

//删除操作
- (void)deletePhotoLibSourceWithAssets:(NSArray *)tempSelectDateArr{
    [PhotoTool deleteLocalLibrarySource:tempSelectDateArr resultHandle:^(BOOL isSuccess, NSError *error) {
        
        if (isSuccess == NO) {
            //提示失败
            [ROVAUIMessageTools showAlertVCWithTitle:@"0 items deleted from drone library" message:nil alertActionTitle:@"OK" showInVc:self];
        }
        self->isAllselected = NO;
        self->_iEditingMode = NO;
        [self.selectDateArr removeAllObjects];
        [self.thumbBottomView removeFromSuperview];
        [self.selectButtonItem setTitle:@"选择"];
        [self getLibrarySource:self.segmentControl.selectedSegmentIndex];
        [self.collectionView reloadData];
        
    }];
}


- (IBAction)allSelectClick:(UIButton *)sender {
    
    if (isAllselected) {
        [self.selectDateArr removeAllObjects];
        [self.thumbBottomView.allSelectButton setImage:[UIImage imageNamed:@"photoVideoIconBox1"] forState:UIControlStateNormal];
    }else{
        for (int i = 0; i < _localImageArr.count; i++) {
            [_selectDateArr addObjectsFromArray:_localImageArr[i]];
        }
        
       
     //   [self addImage:@"photoVideoIconBox1" withImage:@"photoVideoIconBox_allSelect"]

        [self.thumbBottomView.allSelectButton setImage:[self addImage:@"photoVideoIconBox1" withImage:@"photoVideoIconBox_allSelect"] forState:UIControlStateNormal];
    }
    isAllselected = !isAllselected;
    [self getLibrarySource:self.segmentControl.selectedSegmentIndex];
    [self.collectionView reloadData];
    
}

- (UIImage *)addImage:(NSString *)imageName1 withImage:(NSString *)imageName2 {
    
    UIImage *image1 = [UIImage imageNamed:imageName1];
    UIImage *image2 = [UIImage imageNamed:imageName2];
    
    UIGraphicsBeginImageContext(image1.size);
    
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    [image2 drawInRect:CGRectMake((image1.size.width - image2.size.width)/2,(image1.size.height - image2.size.height)/2, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


- (IBAction)deleteclick:(id)sender {
    
    if (self.selectDateArr.count != 0) {
        [self deletePhotoLibSourceWithAssets:self.selectDateArr];
    }
}


- (IBAction)shareClick:(UIButton *)sender {
    
    if (self.selectDateArr.count <= 0) {
        return;
    }
    
    [PhotoTool shareImagesOrVideos:self.selectDateArr presentVC:self resultHandle:^(BOOL isSuccess, NSError * _Nullable error) {
        
        self->_iEditingMode = NO;
        self->isAllselected = NO;
        [self.selectDateArr removeAllObjects];
        [self.thumbBottomView removeFromSuperview];
        [self.selectButtonItem setTitle:@"选择"];
        [self getLibrarySource:self.segmentControl.selectedSegmentIndex];
        [self.collectionView reloadData];
       
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma makr -- Delegate/DataSource

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kwidth = [UIScreen mainScreen].bounds.size.width;
    if (indexPath.row == 0) {
        if (isNoPhotos) {
            return CGSizeMake(kwidth, collectionView.bounds.size.height);
        }
        return CGSizeMake(kwidth, 30);
    }else{
        int items = 0;
        if (kwidth <[UIScreen mainScreen].bounds.size.height) {
            items = 3;
        }else items = 5;
        CGFloat width = kwidth/items-5;
        return CGSizeMake(width, width);
    }
}

////cell的间距

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 2, 0, 2);
}

//cell的纵向距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

////cell的横向距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (isNoPhotos) {
        return 1;
    }else
    
    return [self.localImageArr[section] count]+1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (isNoPhotos) {
        return 1;
    }else
    return self.localDateArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isNoPhotos) {
        NoPhotosCell *cell = (NoPhotosCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"NoPhotosCell" forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        return cell;
    }else{
        if (indexPath.row == 0) {
            
            //时间便签
            GalleryDateCell *cell = (GalleryDateCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryDateCell" forIndexPath:indexPath];
            cell.galleryDateLab.text = self.localDateArr[indexPath.section];
            cell.userInteractionEnabled = NO;
            return cell;
        }else{
            
            GalleryPreImageCell *cell = (GalleryPreImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryPreImageCell" forIndexPath:indexPath];
            PHAsset *assert = self.localImageArr[indexPath.section][indexPath.row-1];
            if (_iEditingMode) {
                
                cell.thumbImageSelectType.hidden = NO;
                if ([_selectDateArr containsObject:assert]) {
                    [cell.thumbImageSelectType setImage:[self addImage:@"photoVideoIconBox1" withImage:@"photoVideoIconBox_allSelect"]];
                }else{
                    [cell.thumbImageSelectType setImage:[UIImage imageNamed:@"photoVideoIconBox1"]];
                }
            }else{
                
                cell.thumbImageSelectType.hidden = YES;
            }
            if (assert.mediaType == PHAssetMediaTypeImage) {
                cell.videoTypeImag.hidden = YES;
                cell.videoTimeLAb.hidden = YES;
            }else if (assert.mediaType == PHAssetMediaTypeVideo){
                cell.videoTypeImag.hidden = NO;
                cell.videoTimeLAb.hidden = NO;
                cell.videoTimeLAb.text = [Utils translateSecsToString:assert.duration];
            }
            [PhotoTool  requestPhotoLabraryImageforAssert:assert targetSize:CGSizeMake(CGRectGetWidth(cell.thumbImage.frame) * [UIScreen mainScreen].scale,
                                                                                       CGRectGetHeight(cell.thumbImage.frame) * [UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault resultHandler:^(UIImage *result, NSDictionary *info) {
                cell.thumbImage.image = result;
            }];
            return cell;
        }
    }
}





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GalleryPreImageCell *cell = (GalleryPreImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_iEditingMode) {
        
        BOOL isSelected = [_selectDateArr containsObject:self.localImageArr[indexPath.section][indexPath.row-1]];
        if (isSelected) {
            [cell.thumbImageSelectType setImage:[UIImage imageNamed:@"photoVideoIconBox1"]];
            [_selectDateArr removeObject:self.localImageArr[indexPath.section][indexPath.row-1]];
        }else{
            [cell.thumbImageSelectType setImage:[self addImage:@"photoVideoIconBox1" withImage:@"photoVideoIconBox_allSelect"]];
            [_selectDateArr addObject:self.localImageArr[indexPath.section][indexPath.row-1]];
        }
        
    }else{
        
        
        PHAsset *asset = self.localImageArr[indexPath.section][indexPath.row-1];
        
        if (asset.mediaType == PHAssetMediaTypeImage) {

        
        ACPhotoViewController *photoVC = [[UIStoryboard storyboardWithName:@"ACPhotoViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoVC_ID"];
        photoVC.imageAsset = self.localImageArr[indexPath.section][indexPath.row-1];
        [photoVC deleteImageViewWithBlock:^(PHAsset *imageAsset) {
            [self.localImageArr removeObject:photoVC.imageAsset];
            [collectionView reloadData];
        }];
        [self.navigationController pushViewController:photoVC animated:YES];
        
        
        }else{
        
        ACVideoEditorViewController *editorVC = [[UIStoryboard storyboardWithName:@"ACVideoEditorViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"VideoEditor_ID"];
        editorVC.videoAsset = self.localImageArr[indexPath.section][indexPath.row-1];
        //刷新
        [editorVC selectedVideoWithBlock:^{
            [self.localImageArr removeObject:editorVC.videoAsset];
            [collectionView reloadData];
        }];
        [self.navigationController pushViewController:editorVC animated:YES];
        
            
        }

            
            
    }

}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    if ([viewController isKindOfClass:[ACVideoEditorViewController class]] || [viewController isKindOfClass:[ACPhotoViewController class]]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else{
        
        BOOL isHomePage = ([viewController isKindOfClass:[self class]]) ;
        
        [self.navigationController setNavigationBarHidden:!isHomePage animated:YES];
        

    
//    if ([viewController isKindOfClass:[ACVideoEditorViewController class]]) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }else{
//        BOOL isHomePage = ([viewController isKindOfClass:[self class]]) ;
//        [self.navigationController setNavigationBarHidden:!isHomePage animated:YES];
    }
}

@end
