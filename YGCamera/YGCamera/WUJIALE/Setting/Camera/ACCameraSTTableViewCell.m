//
//  ACCameraSTTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraSTTableViewCell.h"
#import "ACCameraProperyCollectionViewCell.h"


@interface ACCameraSTTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *dataSourceArr;
    NSInteger selectedIndex;
    scrollViewDidScrollBlock _block;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (nonatomic,strong)UICollectionView *mainCollection;

@end

@implementation ACCameraSTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    selectedIndex = 0;
    dataSourceArr = [[NSMutableArray alloc] init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //FlowView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(120, 30);
    flowLayout.minimumLineSpacing = 0.00001;
    
    
    self.mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 120, 30) collectionViewLayout:flowLayout];
    self.mainCollection.backgroundColor = [UIColor whiteColor];
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    self.mainCollection.pagingEnabled = YES;
    self.mainCollection.bounces = NO;
    self.mainCollection.showsVerticalScrollIndicator = NO;
    self.mainCollection.showsHorizontalScrollIndicator = NO;
    [self.infoView addSubview:self.mainCollection];
    
    //注册cell
    [self.mainCollection registerNib:[UINib nibWithNibName:@"ACCameraProperyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ScrollCell"];
    
}


#pragma mark 设置cell上面参数
//- (void)setCellDateWithData:(NSArray *)dataArray index:(NSIndexPath *)index {
//    
//    NSString *value = nil;
//    
//    if (index.row < dataArray.count) {
//        value = dataArray[index.row];
//    }
//    
//    if (index.row == 0) {
//        self.titleLabel.text = @"视频分辨率";
//        self.valueLabel.text = value;
//    }else if (index.row == 1){
//        self.titleLabel.text = @"网格";
//        self.valueLabel.text = value;
//    }else if (index.row == 2){
//        self.titleLabel.text = @"预览模式";
//        self.valueLabel.text = value;
//    }else if (index.row == 5){
//        self.titleLabel.text = @"变焦速度";
//        self.valueLabel.text = [dataArray lastObject];
//    }
//}

- (void)setCellDataWithArr:(NSArray *)arrSource index:(NSIndexPath *)index selected:(NSInteger)selected {
    
    if (index.row == 0) {
        self.titleLabel.text = @"视频分辨率";
    }else if (index.row ==  1){
        self.titleLabel.text = @"网格";
    }else if (index.row == 2){
        self.titleLabel.text = @"预览模式";
    }else if (index.row == 5){
        self.titleLabel.text = @"变焦速度";
    }

    dataSourceArr = [NSMutableArray arrayWithArray:arrSource];
    selectedIndex = selected;
    [self.mainCollection reloadData];
    self.mainCollection.contentOffset = CGPointMake(120 * selected, 0);
}


#pragma mark UICollection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return dataSourceArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ACCameraProperyCollectionViewCell *propertyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScrollCell" forIndexPath:indexPath];
    if (indexPath.row < dataSourceArr.count) {
        propertyCell.propertyLabel.text = dataSourceArr[indexPath.row];
    }
    
    return propertyCell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (_block) {
        _block(scrollView.contentOffset.x/120);
    }
}


#pragma mark -block
- (void)setScrollViewContentOffsetWithBlock:(scrollViewDidScrollBlock)block {
    _block = block;
}

@end
