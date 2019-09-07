//
//  WZCollectionViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraAreaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WZCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setCellWithIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

- (void)setCollectionWithData:(CameraAreaModel *)model indentifier:(NSString *)indentifier indexPath:(NSIndexPath *)indexPath;

- (void)setRecordWithData:(CameraAreaModel *)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
