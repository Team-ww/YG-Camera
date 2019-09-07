//
//  CameraAreTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraAreaModel.h"

typedef void(^wtAdMfBlock)(NSInteger wtIndex);
NS_ASSUME_NONNULL_BEGIN

@interface CameraAreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *preView;

- (void)setCellWithData:(CameraAreaModel *)model index:(NSIndexPath *)indexPath;

- (void)getStAdEdWithBlock:(wtAdMfBlock)block;

@end

NS_ASSUME_NONNULL_END
