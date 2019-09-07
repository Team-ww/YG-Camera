//
//  FWCommonFilter.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-2.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FWApplyFilter : NSObject

+ (UIImage *)changeImageWith:(CGFloat)BValue Contrast:(CGFloat)CValue Saturation:(CGFloat)SaValue Exposure:(CGFloat)EValue Hue:(CGFloat)HValue Sharpen:(CGFloat)ShValue Whitening:(CGFloat)WValue sking:(CGFloat)SKValue sourceimg:(UIImage *)IMG count:(NSInteger)count;

@end
