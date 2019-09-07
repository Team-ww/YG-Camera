//
//  DragView.m
//  VideoPlayer
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 吴家乐. All rights reserved.
//

#import "DragView.h"

@interface DragView (){
    
    UIView *iconView;
}

@property(nonatomic,assign)BOOL isLeft;

@end

@implementation DragView

- (instancetype)initWithFrame:(CGRect)frame Left:(BOOL)left {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6;
        [self addSubview:backView];
        self.isLeft = left;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGRect viewFrame = CGRectZero;
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    if (self.isLeft) {
        viewFrame = CGRectMake(width - 1, -10, 1, height + 20);
    }else{
        viewFrame = CGRectMake(0, -10, 1, height + 20);
    }
    
    self.timeLabel.frame = CGRectMake(-29.5, -9, 60, 10);
    self.timeLabel.text = @"00:00:00";
    iconView = [[UIView alloc] initWithFrame:viewFrame];
    iconView.backgroundColor = [UIColor redColor];
    [self addSubview:iconView];
    [iconView addSubview:self.timeLabel];
    
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    return [self pointInsideSelf:point];
}

- (BOOL)pointInsideSelf:(CGPoint)point {
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, _hitTestEdgInsets);
    return CGRectContainsPoint(hitFrame, point);
}

- (BOOL)pointInsideImgView:(CGPoint)point {
    
    CGRect relativeFrame = iconView.frame;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, _hitTestEdgInsets);
    return CGRectContainsPoint(hitFrame, point);
}











@end
