//
//  PhotosDetailCell.h
//  YGCamera
//
//  Created by chen hua on 2019/4/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;

@interface PhotosDetailCell : UICollectionViewCell



@property (weak, nonatomic) IBOutlet UIImageView *assetImageview;
@property (weak, nonatomic) IBOutlet UIImageView *videoTypeImageview;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollview;

- (void)setDataWithAssert:(PHAsset *)fileMode ;

@end

NS_ASSUME_NONNULL_END
