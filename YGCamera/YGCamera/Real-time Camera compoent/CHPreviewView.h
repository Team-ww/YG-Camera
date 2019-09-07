//
//  CHPreviewView.h
//  Potensic
//
//  Created by chen hua on 2019/3/28.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "CHImageTarget.h"

@interface CHPreviewView : GLKView<CHImageTarget>


@property(strong,nonatomic)CIFilter *filter;
@property(strong,nonatomic)CIContext*coreImageContext;


//显示/隐藏网格
- (void)switchGrid:(BOOL)toShow;

- (void)setImage:(CIImage *)sourceImage;
@end

