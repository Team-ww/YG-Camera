//
//  CameraTimeAreaTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CameraTimeAreaTableViewCell.h"
#import "WZLayout.h"
#import "WZCollectionViewCell.h"
#import "constants.h"

@interface CameraTimeAreaTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
    CGFloat spaceing;//间距
    NSIndexPath *indexPathRow;
    recordTimeBlock _block;
}
@property (nonatomic,strong)CameraAreaModel *model;
@property (weak, nonatomic) IBOutlet UIView *preView;


@end

@implementation CameraTimeAreaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //scrollView 40
    [self setuoCollectionView];

}


- (void)setuoCollectionView {
    
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    
    WZLayout *layout = [[WZLayout alloc] init];
    layout.itemSize = CGSizeMake(28, 28);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    spaceing = (width * 0.8 - 110  - 28 * 3)/2;
    layout.minimumLineSpacing = spaceing;
    
    //第一个cell和最后一个cell居中显示
    CGFloat margin = (width * 0.8 - 110 - 28) * 0.5;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.frame =CGRectMake(0, 0, width * 0.8 - 110, 31);
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.preView addSubview:collectionView];

    //设置偏移
    [collectionView setContentOffset:CGPointMake(spaceing + 28, 0)];
    
    [collectionView registerNib:[UINib nibWithNibName:@"WZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell_1"];
    
}

#pragma mark --Method
- (void)setCellWithData:(CameraAreaModel *)model indexPath:(NSIndexPath *)indexPath {
    self.model = model;
}


#pragma mark collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.model.recordArr.count;
//    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)cov cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZCollectionViewCell *cell = [cov dequeueReusableCellWithReuseIdentifier:@"Cell_1" forIndexPath:indexPath];
    [cell setRecordWithData:self.model indexPath:indexPath];
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


#pragma mark block

- (void)getRecordTimeWithBlock:(recordTimeBlock)block {
    _block = block;
}



@end
