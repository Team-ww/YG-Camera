//
//  CameraAreTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CameraAreTableViewCell.h"
#import "WZLayout.h"
#import "WZCollectionViewCell.h"
#import "constants.h"

@interface CameraAreTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    CGFloat spaceing;//间距
    NSIndexPath *indexPathRow;
    UICollectionView *collectionView;
    wtAdMfBlock _block;
}

@property(nonatomic,strong)CameraAreaModel *model;


@end

@implementation CameraAreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setuoCollectionView];
}


- (void)setuoCollectionView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    
    WZLayout *layout = [[WZLayout alloc] init];
    layout.itemSize = CGSizeMake(28, 28);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    spaceing = (width * 0.8 - 140 - 28 * 3)/2;
    layout.minimumLineSpacing = spaceing;
    
    //第一个cell和最后一个cell居中显示
    CGFloat margin = (width * 0.8 - 140 - 28) * 0.5;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.frame =CGRectMake(0, 0, width * 0.8 - 140, 30);
    collectionView.backgroundColor = [UIColor colorWithRed:227/255.0 green:221/255.0 blue:214/255.0 alpha:1.0];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.preView addSubview:collectionView];
    //设置偏移
    [collectionView setContentOffset:CGPointMake(spaceing + 28, 0)];
    
    [collectionView registerNib:[UINib nibWithNibName:@"WZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell_1"];
    
}


#pragma mark ---

- (void)setCellWithData:(CameraAreaModel *)model index:(NSIndexPath *)indexPath {
    
    indexPathRow = indexPath;
    self.model = model;
    
    if (indexPath.section == 0) {
        self.titleLabel.text = @"开始位置";
    }else{
        self.titleLabel.text = @"结束位置";
    }
}


#pragma mark collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.model.wtArr.count;
//    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)cov cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZCollectionViewCell *cell = [cov dequeueReusableCellWithReuseIdentifier:@"Cell_1" forIndexPath:indexPath];
    
    [cell setCollectionWithData:self.model indentifier:@"WT" indexPath:indexPath];
    
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    NSInteger offset_wt = scrollView.contentOffset.x/(28.0 + (NSInteger)spaceing);
    
    if (_block) {
        _block(offset_wt);
    }
}


#pragma mark block

- (void)getStAdEdWithBlock:(wtAdMfBlock)block {
    _block = block;
}


@end
