//
//  GalleryEditFilterViews.m
//  SelFly
//
//  Created by wenhh on 2017/11/15.
//  Copyright © 2017年 AEE. All rights reserved.
//

#import "GalleryEditFilterViews.h"
#import "GalleryEditFiltersCell.h"

@interface GalleryEditFilterViews ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@property (copy, nonatomic) NSArray *dataArr;
@property (nonatomic,assign) NSInteger selectRow;               //确定时选中的cell
@property (nonatomic,assign) NSInteger currentRow;              //当前选中的cell
@property (copy, nonatomic) NSArray *imageArr;


@end

@implementation GalleryEditFilterViews

- (void)awakeFromNib {
    [super awakeFromNib];
    self.filterCollectionView.delegate = self;
    self.filterCollectionView.dataSource = self;
    self.dataArr = @[@"Original",@"Nostalgic",@"Classic",@"RainbowFall",@"Cloud",@"Elegant",@"Pink",@"Antique",@"Bl-White",@"Bronze"];
//    self.dataArr = @[@"原图",@"优格",@"HDR",@"流年",@"唯美",@"上野",@"经典色",@"彩虹瀑",@"云端",@"谈雅",@"粉红佳人",@"复古",@"候鸟",@"黑白",@"1900",@"古铜"];
    self.selectRow = 0;
}

- (void)refreshFiltersView {
    [self.filterCollectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        // 默认选中行
        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:self.selectRow inSection:0];
        [self.filterCollectionView selectItemAtIndexPath:firstPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        if ([self.filterCollectionView.delegate respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
            [self.filterCollectionView.delegate collectionView:self.filterCollectionView didSelectItemAtIndexPath:firstPath];
        }
    });
}

- (IBAction)filterViewCancelBtnAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;

    self.filterReturnBlock(weakSelf.selectRow, 0);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0,self.superview.frame.size.height, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)filterViewConfirmBtnAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    self.selectRow = self.currentRow;
    self.filterReturnBlock(weakSelf.selectRow, 2);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0,self.superview.frame.size.height, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GalleryEditFiltersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryEditFiltersCell" forIndexPath:indexPath];
    cell.cellFilterImgView.image = [UIImage imageNamed:@"planeMode"];
    cell.filterNameLab.text = self.dataArr[indexPath.row];
    cell.cellFilterImgView.image = [UIImage imageNamed:self.dataArr[indexPath.row]];
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.filterCollectionView.frame.size.height*4/5, self.filterCollectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryEditFiltersCell *cell = (GalleryEditFiltersCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectLab.frame = cell.filterNameLab.frame;
    cell.selectLab.text = cell.filterNameLab.text;
    cell.selectLab.textAlignment = NSTextAlignmentCenter;
    if (self.currentRow != indexPath.row) {
        self.filterReturnBlock(indexPath.row, 1);
    }
    self.currentRow = indexPath.row;
}

@end
