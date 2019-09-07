//
//  CameraPhotoTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CameraPhotoTableViewCell.h"
#import "CameraDefaultCollectionViewCell.h"
#import "constants.h"
#import "CameraCatchPhotoCollectionViewCell.h"

@interface CameraPhotoTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CameraPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupCollectionView];
}


- (void)setupCollectionView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.dataSourceArr = [[NSMutableArray alloc] init];
    
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    CGFloat view_width = width * 0.8 - 40;
    CGFloat view_height = 50;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(45, 45);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 4;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.frame = CGRectMake(0, 0, view_width, view_height);
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.preView addSubview:collectionView];
    //注册
    [collectionView registerNib:[UINib nibWithNibName:@"CameraDefaultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [collectionView registerNib:[UINib nibWithNibName:@"CameraCatchPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"photo_cell"];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloataCollectionView:) name:@"NSNotification_relationCollectionView" object:nil];
    
}


#pragma mark --更新
- (void)reloataCollectionView:(NSNotification *)notification {
    
    [self.dataSourceArr addObject:(UIImage *)notification.object];
    
    [self.preView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UICollectionView class]]) {
            *stop = YES;
            [(UICollectionView *)obj reloadData];
        }
    }];
}


#pragma mark -collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArr.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row < self.dataSourceArr.count) {
        CameraCatchPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo_cell" forIndexPath:indexPath];
        cell.imageView.image = (UIImage *)self.dataSourceArr[indexPath.row];
        return cell;
    }
    
    CameraDefaultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_setCameraImage" object:nil];
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
