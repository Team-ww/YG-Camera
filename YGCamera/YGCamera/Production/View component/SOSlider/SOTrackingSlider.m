//
//  SOTrackingSlider.m
//  SOSlider
//
//  Created by wangli on 2017/3/30.
//  Copyright © 2017年 wangli. All rights reserved.
//

#import "SOTrackingSlider.h"

@implementation SOTrackingSlider

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - subclassed
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL begin = [super beginTrackingWithTouch:touch withEvent:event];
    if (begin) {
        if ([self.delegate respondsToSelector:@selector(currentValueOfSlider:)]) {
            [self.delegate currentValueOfSlider:self];
        }
        if ([self.delegate respondsToSelector:@selector(beginSwipSlider:)]) {
            [self.delegate beginSwipSlider:self];
        }
    }
    return begin;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL continueTrack = [super continueTrackingWithTouch:touch withEvent:event];
    if (continueTrack) {
        if ([self.delegate respondsToSelector:@selector(currentValueOfSlider:)]) {
            [self.delegate currentValueOfSlider:self];
        }
    }
    return continueTrack;
}
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    if ([self.delegate respondsToSelector:@selector(currentValueOfSlider:)]) {
        [self.delegate currentValueOfSlider:self];
    }
    if ([self.delegate respondsToSelector:@selector(endSwipSlider:)]) {
        [self.delegate endSwipSlider:self];
    }
}


@end
