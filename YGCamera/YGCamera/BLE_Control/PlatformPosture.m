//
//  PlatformPosture.m
//  Potensic
//
//  Created by chen hua on 2019/4/1.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "PlatformPosture.h"

@implementation PlatformPosture


- (void)updateDataWithValues:(NSData *)data{
    
    if (data.length < 6) {
        return;
    }
    uint16_t ptich_angle = 0;
    [data getBytes:&ptich_angle range:NSMakeRange(0, 2)];
    self.pitch_angle = ptich_angle *1.0 /100.0;
    
    uint16_t roll_angle = 0;
    [data getBytes:&roll_angle range:NSMakeRange(2, 2)];
    self.roll_angle = roll_angle *1.0 /100.0;
    
    uint16_t yaw_angle = 0;
    [data getBytes:&yaw_angle range:NSMakeRange(4, 2)];
    self.yaw_angle = yaw_angle *1.0 /100.0;
}

@end
