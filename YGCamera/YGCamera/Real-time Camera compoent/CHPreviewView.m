//
//  CHPreviewView.m
//  Potensic
//
//  Created by chen hua on 2019/3/28.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "CHPreviewView.h"
#import "CHContextManager.h"
#import "CHFunctions.h"
#import "CHNotifications.h"
#import "SCCommon.h"

@interface CHPreviewView ()

@property(nonatomic)CGRect drawableBounds;

@end

@implementation CHPreviewView


- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context
{
    self = [super initWithFrame:frame context:context];
    if (self) {
        
        self.enableSetNeedsDisplay = NO;
        self.backgroundColor = [UIColor blackColor];
        self.opaque = YES;
        //self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.frame = frame;
        [self bindDrawable];
        _drawableBounds = self.bounds;
        _drawableBounds.size.width = self.drawableWidth;
        _drawableBounds.size.height = self.drawableHeight;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterChanged:) name:CHFilterSelectionChangedNotfication object:nil];
    }
    return self;
}

- (void)filterChanged:(NSNotification *)notification {
    self.filter = notification.object;
}

- (void)setImage:(CIImage *)sourceImage
{
    [self bindDrawable];
    if (self.filter) {
        
        [self.filter setValue:sourceImage forKey:kCIInputImageKey];
        CIImage *filteredImage = self.filter.outputImage;
        if (filteredImage) {
            
            CGRect cropRect = CHCenterCropImageRect(sourceImage.extent, self.drawableBounds);
            [self.coreImageContext drawImage:filteredImage
                                      inRect:self.drawableBounds
                                    fromRect:cropRect];
        }
        [self display];
        [self.filter setValue:nil forKey:kCIInputImageKey];
    }else{
        
        CGRect cropRect = CHCenterCropImageRect(sourceImage.extent, self.drawableBounds);
        [self.coreImageContext drawImage:sourceImage
                                  inRect:self.drawableBounds
                                fromRect:cropRect];
        [self display];
    }
}


//显示/隐藏网格
- (void)switchGrid:(BOOL)toShow{
    
   //NSLog(@"toShow ===== %d",toShow);
    if (!toShow) {
        NSArray *layersArr = [NSArray arrayWithArray:self.layer.sublayers];
        for (CALayer *layer in layersArr) {
            if (layer.frame.size.width == 0.5 || layer.frame.size.height == 0.5) {
                [layer removeFromSuperlayer];
            }
        }
        return;
    }
    CGFloat headHeight = self.layer.bounds.size.height- [[UIScreen mainScreen] bounds].size.width;
    CGFloat squareLength = [[UIScreen mainScreen] bounds].size.width;
    CGFloat eachAreaLength = squareLength / 3;
    CGFloat margin = [[UIScreen mainScreen] bounds].size.height/3;
    
    for (int i = 0; i < 4; i++) {
        CGRect frame = CGRectZero;
        if (i == 0 || i == 1) {//画横线
            frame = CGRectMake(0, headHeight + (i + 1) * eachAreaLength, squareLength, 0.5);
        } else if (i == 2){
             frame = CGRectMake((i + 1 - 2) * margin, 0, 0.5, squareLength);
        }
        else   {
            frame = CGRectMake((i + 1 - 2) * margin, 0, 0.5, squareLength);
        }
        [SCCommon drawALineWithFrame:frame andColor:[UIColor colorWithWhite:1.0 alpha:0.6] inLayer:self.layer];
    }
}

@end
