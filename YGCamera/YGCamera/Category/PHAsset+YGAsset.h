//
//  PHAsset+YGAsset.h
//  YGCamera
//
//  Created by iOS_App on 2019/7/22.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (YGAsset)

+ (PHAsset *)latestAsset;

@end

NS_ASSUME_NONNULL_END
