//
//  LineView.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/31.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#define k_width  [UIScreen mainScreen].bounds.size.width
#define k_height [UIScreen mainScreen].bounds.size.height

#import "LineView.h"

@implementation LineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat width = MAX(k_width, k_height)/3;
    CGFloat height = MIN(k_width, k_height)/3;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor grayColor] setStroke];
    
    CGContextSetLineWidth(context, 0.5);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, MAX(k_width, k_height), MIN(k_width, k_height));
    
    CGContextMoveToPoint(context,0, MIN(k_width, k_height));
    CGContextAddLineToPoint(context, MAX(k_width, k_height),0);
    
    CGContextMoveToPoint(context, width, 0);
    CGContextAddLineToPoint(context, width, MIN(k_width, k_height));
    
    CGContextMoveToPoint(context, width * 2, 0);
    CGContextAddLineToPoint(context, width * 2, MIN(k_width, k_height));
    
    
    CGContextMoveToPoint(context, 0, height);
    CGContextAddLineToPoint(context, MAX(k_width, k_height), height);
    
    CGContextMoveToPoint(context, 0, height * 2);
    CGContextAddLineToPoint(context, MAX(k_width, k_height), height*2);
    
    
    CGContextStrokePath(context);
}

@end
