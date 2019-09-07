//
//  PHAsset+YGAsset.m
//  YGCamera
//
//  Created by iOS_App on 2019/7/22.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PHAsset+YGAsset.h"

@implementation PHAsset (YGAsset)


+ (PHAsset *)latestAsset {
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    return [assetsFetchResults firstObject];
}

@end
