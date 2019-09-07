//
//  VideoPhotoView.m
//  YGCamera
//
//  Created by iOS_App on 2019/7/22.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "VideoPhotoView.h"

@implementation VideoPhotoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.button_video setTitle:@"拍摄" forState:UIControlStateNormal];
    self.button_video.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.button_capture setTitle:@"照片" forState:UIControlStateNormal];
    self.button_capture.transform = CGAffineTransformMakeRotation(-M_PI_2);
}


- (void)updateVideoAndPhotoView:(BOOL)isPhotoType{
    
    if (isPhotoType) {
        [self.cameraVideoImageView setImage:[UIImage imageNamed:@"camera_notSelectVideoMode"]];
        [self.cameraCaptureImageview setImage:[UIImage imageNamed:@"camera_selectphotoMode"]];
        [self.button_capture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button_video setTitleColor:[UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else{
        [self.cameraVideoImageView setImage:[UIImage imageNamed:@"camera_selectVideoMode"]];
        [self.cameraCaptureImageview setImage:[UIImage imageNamed:@"camera_notSelectphotoMode"]];
        [self.button_capture setTitleColor:[UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.button_video setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
