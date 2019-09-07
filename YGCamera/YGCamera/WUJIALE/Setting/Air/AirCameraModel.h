//
//  AirCameraModel.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AirCameraModel : NSObject

@property (nonatomic,assign)NSInteger pitch_sd;
@property (nonatomic,assign)NSInteger roll_sd;
@property (nonatomic,assign)NSInteger yaw_sd;

@property (nonatomic,assign)NSInteger pitch_dh;
@property (nonatomic,assign)NSInteger roll_dh;
@property (nonatomic,assign)NSInteger yaw_dh;

@end

NS_ASSUME_NONNULL_END
