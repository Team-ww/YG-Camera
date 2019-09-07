//
//  CameraMoveTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AASlider.h"
#import "CameraMoveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CameraMoveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AASlider *sliderAA;

- (void)setCellWithModel:(CameraMoveModel *)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
