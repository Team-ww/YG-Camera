//
//  ACCameraDetailsCollectionViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/28.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACCameraDetailsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


- (void)setCellWithData:(SetDetailModel *)model defaultArr:(NSArray *)defaultArr selectedArr:(NSArray *)selectedArr titleArr:(NSArray *)titleArr item:(NSInteger)itemIndex index:(NSIndexPath *)index;



@end

NS_ASSUME_NONNULL_END
