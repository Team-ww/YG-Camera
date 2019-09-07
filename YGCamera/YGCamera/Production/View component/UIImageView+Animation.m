//
//  UIImageView+Animation.m
//  YGCamera
//
//  Created by chen hua on 2019/4/8.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "UIImageView+Animation.h"
#import <objc/runtime.h>
static const char * RY_CLICKKEY = "ry_clickkey";


@implementation UIImageView (Animation)

- (void)startAnimation{
    
    static int _angle = 15;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(_angle * (M_PI /180.0f));
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = endAngle;
        
    } completion:^(BOOL finished) {
        
        if (self.isAngle) {
            _angle += 15;
            [self startAnimation];
        }else{
            self.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)endAnimation{
    
    self.isAngle = NO;
}



- (void)setIsAngle:(BOOL)isAngle{
    
    objc_setAssociatedObject(self, RY_CLICKKEY, @(isAngle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAngle{
    return [objc_getAssociatedObject(self, RY_CLICKKEY) boolValue];
    
}
@end
