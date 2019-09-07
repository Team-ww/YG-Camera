//
//  DeviceMationManager.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/7.
//  Copyright © 2019 Chenhua. All rights reserved.
//


#import "DeviceMationManager.h"
#import <CoreMotion/CoreMotion.h>

@interface DeviceMationManager ()
{
    CMMotionManager *mManager;
    DeviceDirection direction;
}
@end

//灵敏度
static const float sensitive = 0.77;

@implementation DeviceMationManager

- (void)startMonitor {
    
    if (mManager == nil) {
        mManager = [[CMMotionManager alloc] init];
    }
    mManager.deviceMotionUpdateInterval = 1/2.0;
    if (mManager.deviceMotionAvailable) {
        [mManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                double x = motion.gravity.x;
                double y = motion.gravity.y;
               // double z = motion.gravity.z;
                
                //手机绕自身旋转的角度
                double xyTheta = atan2(x,y)/M_PI*180.0;
                if (xyTheta>=-135 && xyTheta < -45) {
                    if (self->direction != DeviceDirectionLeft) {
                        self->direction =DeviceDirectionLeft ;
                        if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                            [self.delegate directionChange:self->direction];
                        }
                    }
                    
                }else if (xyTheta >=45 && xyTheta <135){
                    
                    if (self->direction != DeviceDirectionRight) {
                        self->direction = DeviceDirectionRight;
                        if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                            [self.delegate directionChange:self->direction];
                        }
                    }
                    
                    
                }else if ((xyTheta >= 135 && xyTheta <180)||(xyTheta >= -180 && xyTheta <-135)){
                    
                    if (self->direction != DeviceDirectionPortrait) {
                        self->direction = DeviceDirectionPortrait;
                        if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                            [self.delegate directionChange:self->direction];
                        }
                    }
                    
                    
                }
                else if (xyTheta >= -45 && xyTheta <45){
                    
                    if (self->direction != DeviceDirectionDown) {
                        self->direction = DeviceDirectionDown;
                        if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
                            [self.delegate directionChange:self->direction];
                        }
                    }
                    
                }
               // NSLog(@"xyTheta=====%f",xyTheta);
//    180         DeviceDirectionPortrait
//
//     0          DeviceDirectionDown
//
//     90            DeviceDirectionLeft
//     -90           DeviceDirectionRight
//
//                if (xyTheta>=315 || xyTheta < 45) {
//                    self->direction = DeviceDirectionPortrait;
//                                                if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                                                    [self.delegate directionChange:self->direction];
//                                                }
//                }else if (xyTheta >=45 && xyTheta <135){
//                    self->direction = DeviceDirectionLeft;
//                    if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                        [self.delegate directionChange:self->direction];
//                    }
//                }else if (xyTheta >= 135 && xyTheta <225){
//                    self->direction = DeviceDirectionDown;
//                    if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                        [self.delegate directionChange:self->direction];
//                    }
//                }else if (xyTheta >= 225 && xyTheta <315 ){
//
//                    self->direction = DeviceDirectionRight;
//                    if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                        [self.delegate directionChange:self->direction];
//                    }
//                }
                
//                if (y < 0) {
//                    if (fabs(y) > sensitive) {
//                        if (self->direction != DeviceDirectionPortrait) {
//                            self->direction = DeviceDirectionPortrait;
//                            if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                                [self.delegate directionChange:self->direction];
//                            }
//                        }
//                    }
//                }else{
//                    if (y > sensitive) {
//                        if (self->direction != DeviceDirectionDown) {
//                            self->direction = DeviceDirectionDown;
//                            if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                                [self.delegate directionChange:self->direction];
//                            }
//                        }
//                    }
//                }
//
//                if (x < 0) {
//
//                    if (fabs(x) > sensitive) {
//                        if (self->direction != DeviceDirectionLeft) {
//                            self->direction = DeviceDirectionLeft;
//                            if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                                [self.delegate directionChange:self->direction];
//                            }
//                        }
//                    }
//
//                }else{
//
//                    if (x > sensitive) {
//                        if (self->direction != DeviceDirectionRight) {
//                            self->direction = DeviceDirectionRight;
//                            if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                                [self.delegate directionChange:self->direction];
//                            }
//                        }
//                    }
//                }
//
//                if (z < 0) {//up和down
//                    if (fabs(z) > sensitive) {
//                        if (self->direction != DeviceDirectionPortrait) {
//                            self->direction = DeviceDirectionPortrait;
//                            if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                                [self.delegate directionChange:self->direction];
//                            }
//                        }
//                    }
//                }else{
//
//                    if (z > sensitive) {
//                        if (self->direction != DeviceDirectionPortrait) {
//                            self->direction = DeviceDirectionPortrait;
//                            if ([self.delegate respondsToSelector:@selector(directionChange:)]) {
//                                [self.delegate directionChange:self->direction];
//                            }
//                        }
//                    }
//                }
            });
        }];
    }
    
    
}


- (void)stop {
    
    [mManager stopDeviceMotionUpdates];
}



@end
