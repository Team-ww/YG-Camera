//
//  CameraAreaSwitchTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CameraAreaSwitchTableViewCell.h"
#import "WZLayout.h"
#import "WZCollectionViewCell.h"
#import "constants.h"

@interface CameraAreaSwitchTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
    CGFloat spaceing;//间距
    NSIndexPath *indexPathRow;
    getMFBlock _block;
}

@property(nonatomic,strong)CameraAreaModel *model;

@end

@implementation CameraAreaSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.areaSwitch.onTintColor = [UIColor colorWithRed:180/255.0 green:201/255.0 blue:91/255.0 alpha:1.0];
    self.areaSwitch.tintColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.areaSwitch.hidden = YES;
    [self setuoCollectionView];
}


- (void)setuoCollectionView {
    
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    
    WZLayout *layout = [[WZLayout alloc] init];
    layout.itemSize = CGSizeMake(28, 28);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    spaceing = (width * 0.8 - 140  - 28 * 3)/2;
    layout.minimumLineSpacing = spaceing;
    
    //第一个cell和最后一个cell居中显示
    CGFloat margin = (width * 0.8 - 140 - 28) * 0.5;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.frame =CGRectMake(0, 0, width * 0.8 - 140, 30);
    collectionView.backgroundColor = [UIColor colorWithRed:227/255.0 green:221/255.0 blue:214/255.0 alpha:1.0];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.prewView addSubview:collectionView];
    
    //设置偏移
    [collectionView setContentOffset:CGPointMake(spaceing + 28, 0)];
    
    [collectionView registerNib:[UINib nibWithNibName:@"WZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell_1"];
    
}

#pragma mark -- method

- (void)setCellWithData:(CameraAreaModel *)model indexPath:(NSIndexPath *)indexPath {
    
    self.model = model;
    
    if (indexPath.section == 0) {
        self.areaSwitch.on = model.st_flag;
    }else{
        self.areaSwitch.on = model.ed_flag;
    }
}


#pragma mark collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.model.mfArr.count;
    //return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)cov cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZCollectionViewCell *cell = [cov dequeueReusableCellWithReuseIdentifier:@"Cell_1" forIndexPath:indexPath];
    [cell setCollectionWithData:self.model indentifier:@"MF" indexPath:indexPath];
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger offset = scrollView.contentOffset.x/(28.0 + (NSInteger)spaceing);
    
    if (_block) {
        _block(offset);
    }
    
    if (offset == 0) {
        NSLog(@"====> 1s");
    }else if (offset == 1){
        NSLog(@"====> 2s");
    }else{
        NSLog(@"====> 60s");
    }
    
}


#pragma mark 回调
- (void)getMfValueWithBlock:(getMFBlock)block {
    _block = block;
}


@end
