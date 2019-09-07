//
//  ACCameraAirTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirCameraModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACCameraAirTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISlider *ariSlider;

- (void)setCellDataWithModel:(AirCameraModel *)model indexPath:(NSIndexPath *)index;

@end

NS_ASSUME_NONNULL_END
