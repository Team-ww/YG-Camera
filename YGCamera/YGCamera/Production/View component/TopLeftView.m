//
//  TopLeftView.m
//  YGCamera
//
//  Created by iOS_App on 2019/7/20.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "TopLeftView.h"
#import "DeviceInfo.h"


@implementation TopLeftView

- (void)startAnimation{
    
//    self.recordTimeStatusImageview.hidden = NO;
//    self.recordTimeLab.hidden = NO;
}

- (void)stopAnimation{
//    self.recordTimeStatusImageview.hidden = YES;
//    self.recordTimeLab.hidden = YES;
}

- (void)updateRecordTime:(NSInteger)timeCount{
    
    NSInteger hours = (timeCount / 3600);
    NSInteger minutes = (timeCount / 60) % 60;
    NSInteger seconds = timeCount % 60;
    NSString *format = @"%02i:%02i:%02i";
    NSString *timeString = [NSString stringWithFormat:format, hours, minutes, seconds];
//    self.recordTimeLab.text = timeString;
//    [UIView animateWithDuration:0.6 animations:^{
//        self.recordTimeStatusImageview.alpha = 0;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.4 animations:^{
//            self.recordTimeStatusImageview.alpha = 1;
//        }];
//    }];
}

- (void)UpdateDeviceInfo{
    
    self.iphoneBatteryLab.text = [NSString stringWithFormat:@"%d%%",[DeviceInfo getCurrentBatteryLevel]];
    self.sdCardLab.text = [NSString stringWithFormat:@"%d%%",[DeviceInfo getAvailableDiskLevel]];

}


//- (NSString *)batteryInfo_noraml:(BOOL)isNormal{
//    
////    int value = [DeviceInfo getCurrentBatteryLevel];
////    if (value >=100) {
////        return isNormal?@"statusEquiBetteryIcon_N5":@"statusEquiBetteryIconC5";
////    }else if (value >= 70){
////        return isNormal?@"statusEquiBetteryIcon_N4":@"statusEquiBetteryIconC4";
////    }else if (value >= 30){
////        return isNormal?@"statusEquiBetteryIcon_N3":@"statusEquiBetteryIconC3";
////    }else if (value >= 10){
////        return isNormal?@"statusEquiBetteryIcon_N2":@"statusEquiBetteryIconC2";
////    }else{
////        return isNormal?@"statusEquiBetteryIcon_N1":@"statusEquiBetteryIconC1";
////    }
//}


//- (void)updateFlashStatus:(AVCaptureFlashMode)flashMode isHDROpen:(BOOL)isHDROpen{
//
//    NSString *flash_str = nil;
//    if (flashMode == AVCaptureFlashModeOff) {
//        flash_str = @"statusFlashLampClose";
//    }else if (flashMode == AVCaptureFlashModeOn){
//        flash_str = @"statusFlashLampOpen";
//    }else if (flashMode == AVCaptureFlashModeAuto){
//        flash_str = @"statusFlashLampAuto";
//    }
//
//    self.flashStatusImageview.image = [UIImage imageNamed:flash_str];
//    self.hdrStatusImageView.image = [UIImage imageNamed:isHDROpen?@"statusHdr":@"statusHdrClose"];
//}


@end
