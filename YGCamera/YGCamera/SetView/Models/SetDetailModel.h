//
//  SetDetailModel.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/28.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraModel.h"
#import "FilterModel.h"
#import "TimerModel.h"
#import "HDRModel.h"
#import "LightModel.h"
#import "SportModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SetDetailModel : NSObject

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)CameraModel *cameraModel;
@property(nonatomic,strong)FilterModel *filterModel;
@property(nonatomic,strong)TimerModel *timeModel;
@property(nonatomic,strong)HDRModel *hdrModel;
@property(nonatomic,strong)LightModel *lightModel;
@property(nonatomic,strong)SportModel *sportModel;



@end

NS_ASSUME_NONNULL_END
