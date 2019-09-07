//
//  ACVideoFilterCollectionViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/30.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACVideoFilterCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setCellDataWithTitle:(NSString *)title image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
