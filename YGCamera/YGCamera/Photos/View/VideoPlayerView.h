//
//  VideoPlayerView.h
//  YGCamera
//
//  Created by chen hua on 2019/4/12.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MiddlePlayerView.h"
#import "Editing_Collectionview.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerView : UIView


@property (weak, nonatomic) IBOutlet Editing_Collectionview *collectionView;
@property (weak, nonatomic) IBOutlet MiddlePlayerView *middlePlayerView;
@property (weak, nonatomic) IBOutlet UIView   *playView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel  *currentTimeLab;
@property (weak, nonatomic) IBOutlet UILabel  *totalTimeLab;
@property (weak, nonatomic) IBOutlet UISlider *slider;


@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *shearButton;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;


- (void)updateButtonview:(UIButton *)btn;

@end





NS_ASSUME_NONNULL_END
