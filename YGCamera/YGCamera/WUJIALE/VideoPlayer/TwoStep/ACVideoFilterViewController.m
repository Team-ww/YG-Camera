//
//  ACVideoFilterViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACVideoFilterViewController.h"
#import "constants.h"
#import "Utils.h"
#import "ACVideoFilterCollectionViewCell.h"

@interface ACVideoFilterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    
    NSArray *filterTitleArr;
    NSMutableArray *filterImageArr;
    filterBlock _block;
}

@property(nonatomic,strong)UICollectionView *mainCollection;

@end

@implementation ACVideoFilterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.indexNumber = 0;
    filterTitleArr = @[@"原图",@"胶片",@"复古",@"黑白"];
    filterImageArr = [[NSMutableArray alloc] init];
    
    CGFloat H = [self getScrollViewHeight] - 60;
    CGFloat space = 5;
    CGFloat W = (MIN(KMainScreenWidth, KMainScreenHeight) - 25 - 40)/4;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(W, H);
    flowLayout.minimumLineSpacing = space;
    
    
    self.mainCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.mainCollection.frame = CGRectMake(20,0,MIN(KMainScreenWidth, KMainScreenHeight) - 40,H);
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    self.mainCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainCollection];
    
    //cell register
    [self.mainCollection registerNib:[UINib nibWithNibName:@"ACVideoFilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"filterCell"];
    
}

- (void)setFiltersArr:(NSMutableArray *)filtersArr {
    filterImageArr = [NSMutableArray arrayWithArray:filtersArr];
    [self.mainCollection reloadData];
}


#pragma mark - UICollection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return filterTitleArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ACVideoFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
    if (indexPath.row < filterImageArr.count) {
        [cell setCellDataWithTitle:filterTitleArr[indexPath.row] image:filterImageArr[indexPath.row]];
    }
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    self.indexNumber = indexPath.row;
    if (_block) {
        _block(indexPath.row);
    }
}



#pragma mark 获取自适应View的高度
- (CGFloat)getScrollViewHeight {
    
    CGFloat offsetH = 0;
    if ([Utils isiphoneX]) {
        offsetH = MAX(KMainScreenWidth, KMainScreenHeight) - 84 - 34 - 100 - 100 - MIN(KMainScreenWidth, KMainScreenHeight) * 9/16.0;
    }else{
        offsetH = MAX(KMainScreenWidth, KMainScreenHeight) - 64 - 100 - 100 - MIN(KMainScreenWidth, KMainScreenHeight) * 9/16.0;
    }
    
    return offsetH;
}


#pragma mark - block
- (void)setVideoWithFilter:(filterBlock)block {
    _block = block;
}

@end
