//
//  CameraSetModel.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraSetModel : NSObject

@property (nonatomic,copy) NSString *videoResolution;//视频分辨率
@property (nonatomic,assign) NSInteger videoResolution_indx;

//@property (nonatomic,copy) NSString *photoResolution;//图片分辨率
//@property (nonatomic,assign) NSInteger photoResolution_indx;


@property (nonatomic,copy) NSString *gridType;//网格类型
@property (nonatomic,assign) NSInteger gridType_indx;

@property (nonatomic,copy) NSString *previewModel;//预览模式
@property (nonatomic,assign) NSInteger previewModel_indx;

@property (nonatomic,assign) NSInteger cameraModel;//相机手动模式
@property (nonatomic,assign) NSInteger shakeIndex;//相机防抖动

@property (nonatomic,copy) NSString *speed;//变焦速度
@property (nonatomic,assign) NSInteger speed_indx;



@end

NS_ASSUME_NONNULL_END
