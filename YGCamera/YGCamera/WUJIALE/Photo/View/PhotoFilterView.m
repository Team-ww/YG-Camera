//
//  PhotoFilterView.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PhotoFilterView.h"
#import "constants.h"
#import "PhotoFilterViewCollectionViewCell.h"
#import "FWApplyFilter.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"
#import "GPUImageFilterPipeline.h"



@interface PhotoFilterView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    filterViewReturnBlock _block;
}

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic,strong)UICollectionView *mainCollection;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,assign)NSInteger indexRow;//选中的

@end


@implementation PhotoFilterView


- (void)initSubViews {
    
    self.indexRow = 0;
    self.titleArr = @[@"原图",@"童话",@"日出",@"日落"];
    NSArray *filterNames = @[@"CIColorCube",@"CIPhotoEffectFade",@"CIPhotoEffectTonal",@"CIPhotoEffectNoir"];
    self.dataSourceArr = [[NSMutableArray alloc] init];
    
//    [filterNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CIImage *ciImage = [[CIImage alloc] initWithImage:self.contentImage];
//
//        CIFilter *filter = [CIFilter filterWithName:obj keysAndValues:kCIInputImageKey,ciImage, nil];
//        [filter setDefaults];
//
//        CIImage *outputImage = [filter outputImage];
//
//        CIContext *context = [CIContext contextWithOptions:nil];
//
//        CGImageRef imageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
//
//        UIImage *image = [UIImage imageWithCGImage:imageRef];
//
//        [self->_dataSourceArr addObject:image];
//
//        CGImageRelease(imageRef);
//
//    }];
    

    //原图
    UIImage *image = [FWApplyFilter changeImageWith:10000 Contrast:10000 Saturation:10000 Exposure:10000 Hue:10000 Sharpen:10000 Whitening:10000 sking:10000 sourceimg:self.contentImage count:0];
    //1
    UIImage *image_1 = [FWApplyFilter changeImageWith:10000 Contrast:10000 Saturation:10000 Exposure:10000 Hue:10000 Sharpen:10000 Whitening:10000 sking:10000 sourceimg:self.contentImage count:1];
    
    UIImage *image_2 = [FWApplyFilter changeImageWith:10000 Contrast:10000 Saturation:10000 Exposure:10000 Hue:10000 Sharpen:10000 Whitening:10000 sking:10000 sourceimg:self.contentImage count:2];
    
    UIImage *image_3 = [FWApplyFilter changeImageWith:10000 Contrast:10000 Saturation:10000 Exposure:10000 Hue:10000 Sharpen:10000 Whitening:10000 sking:10000 sourceimg:self.contentImage count:3];
    
    [self.dataSourceArr addObject:image];
    [self.dataSourceArr addObject:image_1];
    [self.dataSourceArr addObject:image_2];
    [self.dataSourceArr addObject:image_3];
    
    
    
    
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    CGFloat space = 5;
    CGFloat collectionWith = (width - 40 - 25)/4;
    CGFloat collectionHeight = 120;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(collectionWith,collectionHeight);
    flowLayout.minimumLineSpacing = space;
    
    self.mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width - 40, collectionHeight+10) collectionViewLayout:flowLayout];
    self.mainCollection.backgroundColor = [UIColor whiteColor];
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    [self.mainView addSubview:self.mainCollection];
    
    //register cell
    [self.mainCollection registerNib:[UINib nibWithNibName:@"PhotoFilterViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FilterCell"];
}

- (void)cancelFilterView {

    self.indexRow = 0;
    if (_block) {
        _block(0,0);
    }
}

- (void)confirmFilterView {
    
    if (_block) {
        _block(self.indexRow,2);
    }
}




#pragma mark UICollection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoFilterViewCollectionViewCell *filterCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    filterCell.filterImageView.image = (UIImage *)self.dataSourceArr[indexPath.row];
    filterCell.filterNameLabel.text = (NSString *)self.titleArr[indexPath.row];
    return filterCell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.indexRow = indexPath.row;
    if (_block) {
        _block(indexPath.row,1);
    }
}


#pragma mark -block
- (void)getFilterViewWithBlock:(filterViewReturnBlock)block {
    _block = block;
}




@end
