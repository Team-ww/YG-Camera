//
//  UIColor+Utils.m
//  AppGeneralVesion
//
//  Created by wenhuahai on 16/3/29.
//  Copyright © 2016年 Messoft_iOSTeam. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

#pragma mark - Hex

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithStringHex:(NSString *)stringHex alpha:(CGFloat)alpha
{
    NSMutableString *stringMHex = [NSMutableString stringWithFormat:@"%@",stringHex];
    [stringMHex replaceCharactersInRange:[stringMHex rangeOfString:@"#"] withString:@"0x"];
    long hexLong = strtoul([stringMHex cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    return [UIColor colorWithRed:((long)((hexLong & 0xFF0000) >> 16))/255.0
                           green:((long)((hexLong & 0xFF00) >> 8))/255.0
                            blue:((long)(hexLong & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

#pragma mark -

+ (UIColor *)mainColor
{
    return [UIColor colorWithRed:198.0/255.0 green:63.0/255.0 blue:72.0/255.0 alpha:1.0];
//    return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

+ (UIColor *)mainTranslucentColor
{
    return [UIColor colorWithRed:198.0/255.0
                           green:63.0/255.0
                            blue:72.0/255.0
                           alpha:0.5];
}

#pragma mark -

+ (UIColor *)balanceViewBgColor
{
    return [UIColor colorWithRed:240.0/255.0
                           green:240.0/255.0
                            blue:240.0/255.0
                           alpha:1.0];
}

+ (UIColor *)originalPriceTextColor
{
    return [UIColor colorWithRed:120.0/255.0
                           green:120.0/255.0
                            blue:120.0/255.0
                           alpha:1.0];
}

+ (UIColor *)productPropertyColor
{
    return [UIColor colorWithRed:150.0/255.0
                           green:150.0/255.0
                            blue:150.0/255.0
                           alpha:1.0];
}

+ (UIColor *)textColor
{
    return [UIColor colorWithRed:70.0/255.0
                           green:70.0/255.0
                            blue:70.0/255.0
                           alpha:1.0];
}

+ (UIColor *)classifyColor
{
    return [UIColor colorWithRed:110.0/255.0
                           green:110.0/255.0
                            blue:110.0/255.0
                           alpha:1.0];
}


+(UIColor *)priceColor
{
    return [UIColor colorWithRed:255.0/255.0
                           green:59.0/255.0
                            blue:48.0/255.0
                           alpha:1.0];

}

+ (UIColor *)textLightColor
{
    return [UIColor colorWithRed:110.0/255.0
                           green:110.0/255.0
                            blue:110.0/255.0
                           alpha:1.0];
}

+ (UIColor *)borderColor
{
    return [UIColor colorWithRed:180.0/255.0
                           green:180.0/255.0
                            blue:180.0/255.0
                           alpha:1.0];
}


+ (UIColor *)dividingLineColor
{
    return [UIColor colorWithRed:225.0/255.0
                           green:225.0/255.0
                            blue:225.0/255.0
                           alpha:1.0];
}

+ (UIColor *)linebackgroundColor {
    
    return [UIColor colorWithRed:200/255.0
                           green:200/255.0
                            blue:200/255.0
                           alpha:1.0f];
}

#pragma mark -

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:240.0/255.0
                           green:240.0/255.0
                            blue:240.0/255.0
                           alpha:1.0];
}

+ (UIColor *)btnBackgroundColor
{
    return [UIColor colorWithRed:255.0/255.0
                           green:87.0/255.0
                            blue:90.0/255.0
                           alpha:1.0];
}

@end
