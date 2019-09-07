//
//  DeviceMationManager.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/7.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DeviceDirection) {
    
    DeviceDirectionUnknown = 0,
    DeviceDirectionPortrait = 1,
    DeviceDirectionLeft = 2,
    DeviceDirectionDown = 3,
    DeviceDirectionRight = 4,
};

NS_ASSUME_NONNULL_BEGIN

@protocol DeviceMationManagerDelegate <NSObject>

- (void)directionChange:(DeviceDirection)direction;

@end

@interface DeviceMationManager : NSObject

@property (nonatomic,assign)id<DeviceMationManagerDelegate> delegate;

- (void)startMonitor;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
