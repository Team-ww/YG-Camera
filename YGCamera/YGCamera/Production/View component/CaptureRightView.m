//
//  CaptureRightView.m
//  YGCamera
//
//  Created by chen hua on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CaptureRightView.h"

@implementation CaptureRightView

- (void)showHDRView:(BOOL)hrdHidden   timingImageHidden:(BOOL)timingImageHidden   timIndex:(NSInteger)timIndex{
    
    self.hdrImageview.hidden = !hrdHidden;
    self.timingImageview.hidden = timingImageHidden;
    NSString  *imageStr = nil;
    if (timIndex == 0) {
        imageStr = @"timing_right_0s";
    }else if (timIndex == 1){
        imageStr = @"timing_right_3s";
    }else if (timIndex == 2){
        imageStr = @"timing_right_5s";
    }else if (timIndex == 3){
        imageStr = @"timing_right_10s";
    }
    [self.timingImageview setImage:[UIImage imageNamed:imageStr]];
}

@end
