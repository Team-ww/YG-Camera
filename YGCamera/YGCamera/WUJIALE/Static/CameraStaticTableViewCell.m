//
//  CameraStaticTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CameraStaticTableViewCell.h"
#import "WZLayout.h"
#import "WZCollectionViewCell.h"
#import "constants.h"


@interface CameraStaticTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate> {
    
    CGFloat spaceing;//间距
    NSInteger indexOne;
    getStaticTimeBlock _block;
}

@end

@implementation CameraStaticTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    indexOne = -1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setuoCollectionView];
}

- (void)setuoCollectionView {
    
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    
    WZLayout *layout = [[WZLayout alloc] init];
    
    layout.itemSize = CGSizeMake(28, 28);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    spaceing = (width * 0.8 * 0.55  - 28 * 3)/2;
    layout.minimumLineSpacing = spaceing;
    
    //第一个cell和最后一个cell居中显示
    CGFloat margin = (width * 0.8 * 0.55 - 28) * 0.5;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.frame =CGRectMake(0, 0, width * 0.8 * 0.55, 30);
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.preView addSubview:collectionView];
    //设置偏移
    [collectionView setContentOffset:CGPointMake(spaceing + 28, 0)];
    
    [collectionView registerNib:[UINib nibWithNibName:@"WZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
}


- (void)setCellWithData:(NSArray *)dataArr indexPath:(NSIndexPath *)index {
    
    indexOne = index.row;
    
    if (index.row == 0) {
        self.titleLabel.text = @"快门间隔";
    }else{
        self.titleLabel.text = @"录制时长";
    }
    
}

#pragma mark collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        [cell setCellWithIndex:indexOne indexPath:indexPath];
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger offset = scrollView.contentOffset.x/(28.0 + (NSInteger)spaceing);
//    NSLog(@"======> content offset = %f width = %f offset = %ld",scrollView.contentOffset.x,(28+spaceing),offset);
    
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
- (void)getStaticTimeWithBlock:(getStaticTimeBlock)block {
    _block = block;
}



@end
