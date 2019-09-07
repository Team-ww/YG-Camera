//
//  TopLeftView.h
//  YGCamera
//
//  Created by iOS_App on 2019/7/20.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopLeftView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bluetoothImageview;
@property (weak, nonatomic) IBOutlet UIImageView *sdCardImageview;
@property (weak, nonatomic) IBOutlet UILabel *sdCardLab;


@property (weak, nonatomic) IBOutlet UIImageView *iphoneBatteryImageview;
@property (weak, nonatomic) IBOutlet UILabel *iphoneBatteryLab;


@property (weak, nonatomic) IBOutlet UIImageView *equipBatteryImageview;
@property (weak, nonatomic) IBOutlet UILabel *equipBatteryLab;

- (void)UpdateDeviceInfo;


@end

NS_ASSUME_NONNULL_END
