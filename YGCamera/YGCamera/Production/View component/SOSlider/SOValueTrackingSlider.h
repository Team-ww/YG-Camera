//
//  SOValueTrackingSlider.h
//  SOSlider
//
//  Created by wangli on 2017/3/30.
//  Copyright © 2017年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOValuePopView.h"
#import "SOTrackingSlider.h"

@protocol SOValueTrackingSliderDelegate;
@interface SOValueTrackingSlider : UIView
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) BOOL isVertical;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, strong) UIColor *minimumTrackTintColor;
@property (nonatomic, strong) UIColor *maxmumTrackTintColor;
@property (nonatomic, unsafe_unretained)id<SOValueTrackingSliderDelegate>delegate;
@property (nonatomic, strong) SOValuePopView *valuePopView;
@property (nonatomic, strong) SOTrackingSlider *uiSlider;

@end
@protocol SOValueTrackingSliderDelegate <NSObject>

@optional

- (void)beginSwip;
- (void)endSwip;

@end
