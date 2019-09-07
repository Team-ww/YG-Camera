//
//  CHPhotoFilters.m
//  Potensic
//
//  Created by chen hua on 2019/3/28.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "CHPhotoFilters.h"

@implementation CHPhotoFilters

+(NSArray *)filterNames
{
    return @[
             @"CIPhotoEffect_原生效果",
             @"CIPhotoEffectChrome",
             @"CIPhotoEffectFade",
             @"CIPhotoEffectInstant",
             @"CIPhotoEffectMono",
             @"CIPhotoEffectNoir",
//             @"CIPhotoEffectProcess",
//             @"CIPhotoEffectTonal",
             @"CIPhotoEffectTransfer"
             ];
}

+ (CIFilter *)defaultFilter {
    
    return [CIFilter filterWithName:[[self filterNames] firstObject]];
}

+ (CIFilter *)filterForDisplayName:(NSString *)displayName {
    
    for (NSString *name in [self filterNames]) {
        if ([name containsString:displayName]) {
            return [CIFilter filterWithName:name];
        }
    }
    return nil;
}
@end
