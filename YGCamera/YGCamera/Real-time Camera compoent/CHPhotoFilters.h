//
//  CHPhotoFilters.h
//  Potensic
//
//  Created by chen hua on 2019/3/28.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHPhotoFilters : NSObject


+(NSArray *)filterNames;
+(CIFilter *)filterForDisplayName:(NSString *)displayName;
+(CIFilter *)defaultFilter;


@end

NS_ASSUME_NONNULL_END
