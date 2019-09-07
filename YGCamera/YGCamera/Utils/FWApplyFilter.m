//
//  FWCommonFilter.m
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-2.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWApplyFilter.h"
#import "FWAmaroFilter.h"
#import "FWRiseFilter.h"
#import "FWHudsonFilter.h"
#import "FW1977Filter.h"
#import "FWValenciaFilter.h"
#import "FWXproIIFilter.h"
#import "FWInkwellFilter.h"
#import "FWEarlybirdFilter.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"
#import "GPUImageFilterPipeline.h"

@implementation FWApplyFilter

#pragma mark ----------- //-------------------------------------

//+ (UIImage *)getFilterImageWith:(UIImage *)image With:(NSInteger)count{
//    UIImage *img;
//    if (count!=0) {
//        GPUImageFilterGroup *filter = [self getTheGroupByCount:count];
//        [filter forceProcessingAtSize:image.size];
//        GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
//        [pic addTarget:filter];
//
//        [pic processImage];
//        [filter useNextFrameForImageCapture];
//        img = [filter imageFromCurrentFramebuffer];
//        [pic removeAllTargets];
//        pic = nil;
//        filter = nil;
//        [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
//    }
//
//    return img;
//}

+ (GPUImageFilterGroup *)getTheGroupByCount:(NSInteger)count{
    GPUImageFilterGroup *group ;
    
    switch (count) {
        case 0 :
            
            break;
        case 1:
            group = [[GPUImageSoftEleganceFilter alloc] init];
            break;
        case 2:
            group = [[FWAmaroFilter alloc] init];
            break;
        case 3:
            group = [[FWRiseFilter alloc] init];
            break;
        case 4:
            group = [[FWHudsonFilter alloc] init];
            break;
        case 5:
            group = [[FWXproIIFilter alloc] init];
            break;
        case 6:
            group = [[FW1977Filter alloc] init];
            break;
        case 7:
            group = [[FWValenciaFilter alloc] init];
            break;
        case 8:
            group = [[FWInkwellFilter alloc] init];
            break;
        case 9:
            group = [[FWEarlybirdFilter alloc] init];
            break;
        default:
            break;
    }
    return group;
}

//亮度 //对比度 //饱和度  //曝光  // //锐化  //色度
+ (UIImage *)changeImageWith:(CGFloat)BValue Contrast:(CGFloat)CValue Saturation:(CGFloat)SaValue Exposure:(CGFloat)EValue Hue:(CGFloat)HValue Sharpen:(CGFloat)ShValue Whitening:(CGFloat)WValue sking:(CGFloat)SKValue sourceimg:(UIImage *)IMG count:(NSInteger)count{
    GPUImageFilterGroup *groups = [[GPUImageFilterGroup alloc] init];
    
    if (BValue !=10000) {
        GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];    //亮度
        brightnessFilter.brightness = BValue;
        [self addGPUImageFilter:brightnessFilter group:groups];
    }
    if (CValue!=10000) {
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];        //对比度
        contrastFilter.contrast = CValue;
        [self addGPUImageFilter:contrastFilter group:groups];
    }
    if (SaValue!=10000) {
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];    //饱和度
        saturationFilter.saturation = SaValue;
        [self addGPUImageFilter:saturationFilter group:groups];
    }
    if (EValue!=10000) {
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];        //曝光
        exposureFilter.exposure = EValue;
        [self addGPUImageFilter:exposureFilter group:groups];
    }
    if (ShValue!=10000) {
        GPUImageSharpenFilter *sharpenFilter = [[GPUImageSharpenFilter alloc] init];          //锐化
        sharpenFilter.sharpness = ShValue;
        [self addGPUImageFilter:sharpenFilter group:groups];
    }
    if (HValue!=10000) {
        GPUImageHueFilter  *hueFilter = [[GPUImageHueFilter alloc] init];                  //色度
        hueFilter.hue = HValue;
        [self addGPUImageFilter:hueFilter group:groups];
    }
    if (SKValue!=10000||WValue!=10000) {
        GPUImageBeautifyFilter *BeautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        if (SKValue!=10000)  BeautifyFilter.bilateralFilter.distanceNormalizationFactor = SKValue;
        if (WValue!=10000) BeautifyFilter.brightFilter.brightness = WValue;
        [self addGPUImageFilter:BeautifyFilter group:groups];
    }
    if (count != 0) {
        GPUImageFilterGroup *filters = [self getTheGroupByCount:count];
        [self addGPUImageFilter:filters group:groups];
    }
    //    if (filters) [self addGPUImageFilter:filters group:groups];
    UIImage *image;
    if (groups.filterCount>0) {
        GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:IMG];
        [pic addTarget:groups];
        [pic processImage];
        [groups useNextFrameForImageCapture];
        image =  [groups imageFromCurrentFramebuffer];
        [pic removeAllTargets];
        //        if (image) {
        //            [pic removeOutputFramebuffer];
        //            [groups removeOutputFramebuffer];
        //        }
        //        pic = nil;
    }else image =IMG;
    //    [groups removeAllTargets];
    //    groups= nil;
    //    IMG = nil;
    return image;
}

+ (void)addGPUImageFilter:(GPUImageOutput<GPUImageInput> *)filters group:(GPUImageFilterGroup *)group
{
    [group addFilter:filters];
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filters;
    
    NSInteger count = group.filterCount;
    
    if (count == 1)
    {
        group.initialFilters = @[newTerminalFilter];
        group.terminalFilter = newTerminalFilter;
        
        
    } else
    {
        GPUImageOutput<GPUImageInput> *terminalFilter    = group.terminalFilter;
        NSArray *initialFilters                          = group.initialFilters;
        [terminalFilter addTarget:newTerminalFilter];
        group.initialFilters = @[initialFilters[0]];
        group.terminalFilter = newTerminalFilter;
    }
}

@end
