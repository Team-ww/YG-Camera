//
//  PhotoFilterViewCollectionViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/3.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoFilterViewCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *filterImageView;

@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;


@end

NS_ASSUME_NONNULL_END
