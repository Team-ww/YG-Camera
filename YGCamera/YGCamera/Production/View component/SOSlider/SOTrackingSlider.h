//
//  SOTrackingSlider.h
//  SOSlider
//
//  Created by wangli on 2017/3/30.
//  Copyright © 2017年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SOTrackingSliderDelegate;
@interface SOTrackingSlider : UISlider
@property (nonatomic, unsafe_unretained) id<SOTrackingSliderDelegate>delegate;
@end
@protocol SOTrackingSliderDelegate <NSObject>
@optional
- (void)currentValueOfSlider:(SOTrackingSlider *)slider;
- (void)beginSwipSlider:(SOTrackingSlider *)slider;
- (void)endSwipSlider:(SOTrackingSlider *)slider;
@end
