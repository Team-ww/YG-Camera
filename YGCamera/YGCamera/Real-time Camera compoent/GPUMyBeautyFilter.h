//
//  GPUMyBeautyFilter.h
//  YGCamera
//
//  Created by chen hua on 2019/7/5.
//  Copyright © 2019 Chenhua. All rights reserved.
//


#import "GPUImage.h"
@class GPUImageCombinationFilter_2;
NS_ASSUME_NONNULL_BEGIN

@interface GPUMyBeautyFilter : GPUImageFilterGroup
{
    
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageCombinationFilter_2 *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}

@end

NS_ASSUME_NONNULL_END
