//
//  CameraMessageModel.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraMessageModel : NSObject

@property (nonatomic,copy)NSString *cameraName;

@property (nonatomic,copy)NSString *version;

@property (nonatomic,copy)NSString *liveMessage;


@end

NS_ASSUME_NONNULL_END
