//
//  CameraMoveTimeTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CameraMoveTimeTableViewCell.h"
#import "WZLayout.h"
#import "WZCollectionViewCell.h"
#import "constants.h"

@interface CameraMoveTimeTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
    CGFloat spaceing;//间距
    NSInteger indexOne;
    UICollectionView *left_collectionView;
    UICollectionView *right_collectionView;
    timeBlock _block;
}

@property(nonatomic,strong)CameraMoveModel *model;

@end

@implementation CameraMoveTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setuoCollectionView];
}

- (void)setuoCollectionView {
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    CGFloat view_width = (width * 0.8 - 50)/2 - 43;
    
    WZLayout *layout = [[WZLayout alloc] init];
    
    layout.itemSize = CGSizeMake(28, 28);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    spaceing = (view_width - 28 * 3)/2;
    layout.minimumLineSpacing = spaceing;
    
    //第一个cell和最后一个cell居中显示
    CGFloat margin = (view_width - 28) * 0.5;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    left_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    left_collectionView.frame =CGRectMake(0, 0, view_width, 33.5);
    left_collectionView.backgroundColor = [UIColor whiteColor];
    left_collectionView.delegate = self;
    left_collectionView.dataSource = self;
    [self.leftPreView addSubview:left_collectionView];
    //设置偏移
    [left_collectionView setContentOffset:CGPointMake(spaceing + 28, 0)];
    
    [left_collectionView registerNib:[UINib nibWithNibName:@"WZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    WZLayout *layout_1 = [[WZLayout alloc] init];
    
    layout_1.itemSize = CGSizeMake(28, 28);
    layout_1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    spaceing = (view_width  - 28 * 3)/2;
    layout_1.minimumLineSpacing = spaceing;
    
    //第一个cell和最后一个cell居中显示
    CGFloat margin_1 = (view_width - 28) * 0.5;
    layout_1.sectionInset = UIEdgeInsetsMake(0, margin_1, 0, margin_1);
    
    right_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout_1];
    
    right_collectionView.frame =CGRectMake(0, 0, view_width, 33.5);
    right_collectionView.backgroundColor = [UIColor whiteColor];
    right_collectionView.delegate = self;
    right_collectionView.dataSource = self;
    [self.rightPreView addSubview:right_collectionView];
    //设置偏移
    [right_collectionView setContentOffset:CGPointMake(spaceing + 28, 0)];
    
    [right_collectionView registerNib:[UINib nibWithNibName:@"WZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
}

#pragma mark --Method
- (void)setCellWithModel:(CameraMoveModel *)model indexPath:(NSIndexPath *)indexPath {
    
    self.model = model;
    
    left_collectionView.contentOffset = CGPointMake((spaceing+28) * model.ever_index, 0);
    right_collectionView.contentOffset = CGPointMake((spaceing+28) * model.record_index, 0);
}



#pragma mark collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (collectionView == left_collectionView) {
        [cell setCellWithIndex:0 indexPath:indexPath];
    }else{
        [cell setCellWithIndex:1 indexPath:indexPath];
    }

    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    NSInteger leftOffset = self.model.ever_index;
    NSInteger rightOffset = self.model.record_index;
    
    if (scrollView == left_collectionView) {
        leftOffset = scrollView.contentOffset.x/(28.0 + (NSInteger)spaceing);
    }else{
        rightOffset = scrollView.contentOffset.x/(28.0 + (NSInteger)spaceing);
    }
    
    if (_block) {
        _block(leftOffset,rightOffset);
    }
}


#pragma mark block

-  (void)getTimeWithBlock:(timeBlock)block {
    _block = block;
}





@end
