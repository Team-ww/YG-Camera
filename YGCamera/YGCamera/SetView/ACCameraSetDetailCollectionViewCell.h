//
//  ACCameraSetDetailCollectionViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/28.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACCameraSetDetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

- (void)setCellWithModel:(SetDetailModel *)model defaultArr:(NSArray *)defaultArr select:(NSArray *)selectedArr titleArr:(NSArray *)titleArr  index:(NSIndexPath *)index;

@end

NS_ASSUME_NONNULL_END
