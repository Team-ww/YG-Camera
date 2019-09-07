//
//  CameraStaticModel.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraStaticModel : NSObject


@property (nonatomic,assign)NSInteger ever_index;
@property (nonatomic,assign)NSInteger every_time;

@property (nonatomic,assign)NSInteger record_index;

@property (nonatomic,assign)NSInteger record_time;

@property (nonatomic,assign)NSInteger switchFlag;

@end

NS_ASSUME_NONNULL_END
