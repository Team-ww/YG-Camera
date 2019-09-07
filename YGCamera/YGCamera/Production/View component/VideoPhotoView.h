//
//  VideoPhotoView.h
//  YGCamera
//
//  Created by iOS_App on 2019/7/22.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPhotoView : UIView


@property (weak, nonatomic) IBOutlet UIButton *button_video;
@property (weak, nonatomic) IBOutlet UIView *video_video;
@property (weak, nonatomic) IBOutlet UIImageView *cameraVideoImageView;

@property (weak, nonatomic) IBOutlet UIButton *button_capture;
@property (weak, nonatomic) IBOutlet UIView *video_capture;
@property (weak, nonatomic) IBOutlet UIImageView *cameraCaptureImageview;


- (void)updateVideoAndPhotoView:(BOOL)isPhotoType;

@end

NS_ASSUME_NONNULL_END
