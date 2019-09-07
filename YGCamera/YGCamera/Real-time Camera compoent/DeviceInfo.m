//
//  DeviceInfo.m
//  Potensic
//
//  Created by chen hua on 2019/3/22.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "DeviceInfo.h"
#import <UIKit/UIKit.h>
#include <sys/mount.h>

@implementation DeviceInfo

+ (int)getCurrentBatteryLevel{
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return  (int)([[UIDevice currentDevice] batteryLevel] *100);
}


+ (long long)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}


+ (long long)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}

//获取百分比

+(int)getAvailableDiskLevel{
    
    return  100 * [self getAvailableDiskSize] / ([self getTotalDiskSize]*1.0);
}

@end
