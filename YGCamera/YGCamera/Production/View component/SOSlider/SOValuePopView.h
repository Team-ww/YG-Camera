//
//  SOValuePopView.h
//  SOSlider
//
//  Created by wangli on 2017/3/30.
//  Copyright © 2017年 wangli. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SOValuePopViewDelegate <NSObject>
- (CGFloat)currentValueOffset;//expects value in the range 0.0 - 1.0
- (void)animationDidStart;
@end
@interface SOValuePopView : UIView
@property (nonatomic, unsafe_unretained) id<SOValuePopViewDelegate>delegate;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *text;
@end
