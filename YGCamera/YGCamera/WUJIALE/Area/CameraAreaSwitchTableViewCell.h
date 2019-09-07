//
//  CameraAreaSwitchTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraAreaModel.h"

typedef void(^getMFBlock)(NSInteger mfIndex);
NS_ASSUME_NONNULL_BEGIN

@interface CameraAreaSwitchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *areaSwitch;

@property (weak, nonatomic) IBOutlet UIView *prewView;

- (void)setCellWithData:(CameraAreaModel *)model indexPath:(NSIndexPath *)indexPath;

- (void)getMfValueWithBlock:(getMFBlock)block;

@end

NS_ASSUME_NONNULL_END
