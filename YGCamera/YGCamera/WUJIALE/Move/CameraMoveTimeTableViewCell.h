//
//  CameraMoveTimeTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraMoveModel.h"

typedef void(^timeBlock)(NSInteger leftIndex,NSInteger rightIndex);

NS_ASSUME_NONNULL_BEGIN

@interface CameraMoveTimeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *leftPreView;

@property (weak, nonatomic) IBOutlet UIView *rightPreView;

- (void)setCellWithModel:(CameraMoveModel *)model indexPath:(NSIndexPath *)indexPath;

- (void)getTimeWithBlock:(timeBlock)block;

@end

NS_ASSUME_NONNULL_END
