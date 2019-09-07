//
//  CHFunctions.m
//  Potensic
//
//  Created by chen hua on 2019/3/28.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "CHFunctions.h"

CGRect CHCenterCropImageRect(CGRect sourceRect, CGRect previewRect) {
    
    CGFloat sourceAspectRatio = sourceRect.size.width / sourceRect.size.height;
    CGFloat previewAspectRatio = previewRect.size.width  / previewRect.size.height;
    
    // we want to maintain the aspect radio of the screen size, so we clip the video image
    CGRect drawRect = sourceRect;
    
    if (sourceAspectRatio > previewAspectRatio) {
        
        // use full height of the video image, and center crop the width
        CGFloat scaledHeight = drawRect.size.height * previewAspectRatio;
        drawRect.origin.x += (drawRect.size.width - scaledHeight) / 2.0;
        drawRect.size.width = scaledHeight;
        
    } else {
        
        // use full width of the video image, and center crop the height
        drawRect.origin.y += (drawRect.size.height - drawRect.size.width / previewAspectRatio) / 2.0;
        drawRect.size.height = drawRect.size.width / previewAspectRatio;
    }
    return drawRect;
}


CGAffineTransform CHTransformForDeviceOrientation(UIDeviceOrientation orientation) {
    CGAffineTransform result;
    
    switch (orientation) {
            
        case UIDeviceOrientationLandscapeRight:
            result = CGAffineTransformMakeRotation(M_PI);
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            result = CGAffineTransformMakeRotation((M_PI_2 * 3));
            break;
            
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            result = CGAffineTransformMakeRotation(M_PI_2);
            break;
            
        default: // Default orientation of landscape left
            result = CGAffineTransformIdentity;
            break;
    }
    
    return result;
}

