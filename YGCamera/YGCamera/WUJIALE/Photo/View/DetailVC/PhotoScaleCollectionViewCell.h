//
//  PhotoScaleCollectionViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/4.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoScaleCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign)NSInteger totalNum;

- (void)setImageViewBackground:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
