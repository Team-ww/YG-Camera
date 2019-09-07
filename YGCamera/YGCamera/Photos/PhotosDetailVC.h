//
//  PhotosDetailVC.h
//  YGCamera
//
//  Created by chen hua on 2019/4/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotosDetailVC : UIViewController

@property (nonatomic, assign) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray *localImageArr;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@property (nonatomic,assign)CGRect finalCellRect;

- (void)reloadGalleryData:(void(^)())callBack;


@end

NS_ASSUME_NONNULL_END
