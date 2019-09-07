//
//  DeviceInfo.h
//  Potensic
//
//  Created by chen hua on 2019/3/22.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfo : NSObject


//获取可用磁盘剩余容量
+(int)getAvailableDiskLevel;


//获取电量
+ (int)getCurrentBatteryLevel;



@end

NS_ASSUME_NONNULL_END
