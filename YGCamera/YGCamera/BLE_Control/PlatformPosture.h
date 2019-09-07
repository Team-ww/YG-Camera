//
//  PlatformPosture.h
//  Potensic
//
//  Created by chen hua on 2019/4/1.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformPosture : NSObject

@property (nonatomic,assign)float pitch_angle;
@property (nonatomic,assign)float roll_angle;
@property (nonatomic,assign)float yaw_angle;

- (void)updateDataWithValues:(NSData *)data;


@end

NS_ASSUME_NONNULL_END
