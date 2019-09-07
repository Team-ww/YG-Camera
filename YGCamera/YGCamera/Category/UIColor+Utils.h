//
//  UIColor+Utils.h
//  AppGeneralVesion
//
//  Created by wenhuahai on 16/3/29.
//  Copyright © 2016年 Messoft_iOSTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithStringHex:(NSString *)stringHex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

/**
 *  设置app主色调
 *
 *  @return 返回app主色调
 */
+ (UIColor *)mainColor;
+ (UIColor *)mainTranslucentColor;

+ (UIColor *)balanceViewBgColor;
+ (UIColor *)originalPriceTextColor;
+ (UIColor *)productPropertyColor;
+ (UIColor *)textColor;
+ (UIColor *)textLightColor;
+ (UIColor *)borderColor;
+ (UIColor *)linebackgroundColor;
+ (UIColor *)priceColor;
+ (UIColor *)classifyColor;

+ (UIColor *)dividingLineColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)btnBackgroundColor;

@end
