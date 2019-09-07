//
//  ACCameraMessageTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACCameraMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;


- (void)setCellWithModel:(CameraMessageModel *)model indexPath:(NSIndexPath *)index;


@end

NS_ASSUME_NONNULL_END
