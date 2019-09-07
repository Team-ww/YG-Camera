//
//  GPUImageBeautifyFilter.h
//  BeautifyFaceDemo
//
//  Created by guikz on 16/4/28.
//  Copyright © 2016年 guikz. All rights reserved.
//

#import "GPUImage.h"

@class GPUImageCombinationFilter;

@interface GPUImageBeautifyFilter : GPUImageFilterGroup
//{
//
//    GPUImageBilateralFilter *bilateralFilter;
//    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
//    GPUImageCombinationFilter *combinationFilter;
//    GPUImageHSBFilter *hsbFilter;
//}
@property (nonatomic, strong) GPUImageBilateralFilter *bilateralFilter;
@property (nonatomic, strong) GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
@property (nonatomic, strong) GPUImageCombinationFilter *combinationFilter;
@property (nonatomic, strong) GPUImageHSBFilter *hsbFilter;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightFilter;

- (void)setLastFilter:(BOOL)isBright;

@end
