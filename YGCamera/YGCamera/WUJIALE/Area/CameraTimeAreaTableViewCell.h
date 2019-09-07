//
//  CameraTimeAreaTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraAreaModel.h"

typedef void(^recordTimeBlock)(NSInteger selectedIndex);

NS_ASSUME_NONNULL_BEGIN

@interface CameraTimeAreaTableViewCell : UITableViewCell

- (void)setCellWithData:(CameraAreaModel *)model indexPath:(NSIndexPath *)indexPath;

- (void)getRecordTimeWithBlock:(recordTimeBlock)block;

@end

NS_ASSUME_NONNULL_END
