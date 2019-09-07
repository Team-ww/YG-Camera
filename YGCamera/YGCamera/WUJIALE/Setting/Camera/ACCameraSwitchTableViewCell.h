//
//  ACCameraSwitchTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACCameraSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *modelSwitch;


@property (weak, nonatomic) IBOutlet UILabel *switchLab;

- (void)setSwitchStatus:(NSArray *)dataSource index:(NSIndexPath *)index;


@end

NS_ASSUME_NONNULL_END
