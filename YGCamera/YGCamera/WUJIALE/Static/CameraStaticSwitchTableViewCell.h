//
//  CameraStaticSwitchTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraStaticSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *staticSwitch;

- (void)setSwitchWithData:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
