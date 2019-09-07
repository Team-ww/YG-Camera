//
//  CaptureButton_Component.m
//  Potensic
//
//  Created by chen hua on 2019/1/28.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "CaptureButton_Component.h"
//#import <Metal/Metal.h>

#define LINE_WIDTH 6.0f
#define DEFAULT_FRAME  CGRectMake(0.0f, 0.0f, 68.0f, 68.0f)

@interface CaptureButton_Component ()

@property (nonatomic,strong)CALayer *circleLayer;

@end

@implementation CaptureButton_Component


+ (instancetype)captureButton
{
    return [[self alloc] initWithCaptureButtonMode:CaptureButtonMode_Photo];
}

+ (instancetype)captureButtonWithMode:(CaptureButtonMode)captureButtonMode
{
    return [[self alloc] initWithCaptureButtonMode:CaptureButtonMode_Photo];
}

- (id)initWithCaptureButtonMode:(CaptureButtonMode)captureButtonMode{
    
    self = [super initWithFrame:DEFAULT_FRAME];
    if (self) {
        _captureButtonMode = captureButtonMode;
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _captureButtonMode = CaptureButtonMode_Photo;
    [self setupView];
}

- (void)setupView{
    
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    _circleLayer = [CALayer layer];
    _circleLayer.bounds = CGRectInset(self.bounds, 8.0, 8.0);
    _circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _circleLayer.cornerRadius = _circleLayer.bounds.size.width / 2;
    _circleLayer.backgroundColor = (_captureButtonMode == CaptureButtonMode_Photo) ? [UIColor whiteColor].CGColor :[UIColor redColor].CGColor;
    [self.layer addSublayer:_circleLayer];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = 0.2f;
    if (highlighted) {
        animation.toValue = @0.0f;
    }else{
        animation.toValue = @1.0f;
    }
    self.circleLayer.opacity = [animation.toValue floatValue];
    [self.circleLayer addAnimation:animation forKey:@"animation_highlight"];
}

- (void)setCaptureButtonMode:(CaptureButtonMode)captureButtonMode
{
    _captureButtonMode = captureButtonMode;
    _circleLayer.backgroundColor = (_captureButtonMode == CaptureButtonMode_Photo) ? [UIColor whiteColor].CGColor :[UIColor redColor].CGColor;
   // [self setNeedsDisplay];
//    CFRunLoopRunInMode (CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()), 0, FALSE);
}
//
//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//    if (_captureButtonMode == CaptureButtonMode_Video) {
//        //开启动画显示效果
//        [CATransaction disableActions];
//        //self.layer.transform.scale;
//        CABasicAnimation *radius_animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
//        CABasicAnimation *scale_animation  =  [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        if (selected) {
//            scale_animation.toValue  = @0.6f;
//            radius_animation.toValue = @(self.bounds.size.width/4.0);
//        }else{
//            radius_animation.toValue = @1.0f;
//            scale_animation.toValue  = @(self.bounds.size.width/2.0);
//        }
//        CAAnimationGroup *group = [CAAnimationGroup animation];
//        group.animations = @[scale_animation,radius_animation];
//        group.beginTime  = CACurrentMediaTime();
//        group.duration   = 0.25;
//        group.removedOnCompletion = NO;
//        group.fillMode   = kCAFillModeForwards;
//        [self.circleLayer addAnimation:group forKey:@"scaleAndRadiusAnimation"];
//    }
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGColorRef   color = [UIColor whiteColor].CGColor ;
////    CGColorRef   color = (_captureButtonMode == CaptureButtonMode_Photo)? [UIColor whiteColor].CGColor :[UIColor redColor].CGColor;
//    CGContextSetFillColorWithColor(context, color);
//    CGContextSetStrokeColorWithColor(context, color);
//    CGContextSetLineWidth(context, LINE_WIDTH);
//    CGContextStrokeEllipseInRect(context, CGRectInset(rect, LINE_WIDTH / 2, LINE_WIDTH / 2));//上下文删除
//}

@end
