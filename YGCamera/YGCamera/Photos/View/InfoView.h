//
//  InfoView.h
//  YGCamera
//
//  Created by chen hua on 2019/4/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSHPopupContainer.h"
#import "PhotoTool.h"

@interface InfoView : UIView <DSHCustomPopupView>

@property (weak, nonatomic) IBOutlet UILabel *videoOrImageType_Lab;

@property (weak, nonatomic) IBOutlet UILabel *filenameLab_left;
@property (weak, nonatomic) IBOutlet UILabel *filenameLab_right;

@property (weak, nonatomic) IBOutlet UILabel *timeLab_left;
@property (weak, nonatomic) IBOutlet UILabel *timeLab_right;

@property (weak, nonatomic) IBOutlet UILabel *widthLab_left;
@property (weak, nonatomic) IBOutlet UILabel *widthLab_right;

@property (weak, nonatomic) IBOutlet UILabel *heightLab_left;
@property (weak, nonatomic) IBOutlet UILabel *heightLab_right;


@property (weak, nonatomic) IBOutlet UILabel *fileSizeLab_left;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLab_right;

@property (weak, nonatomic) IBOutlet UILabel *formatLab_left;
@property (weak, nonatomic) IBOutlet UILabel *formatLab_right;



- (UIView *)copyView;

- (void)setVideoInfoWithAsset:(PHAsset *)asset mediaSize:(float)mediaSize fps:(float)fps;

@end


