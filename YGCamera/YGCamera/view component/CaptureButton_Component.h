//
//  CaptureButton_Component.h
//  Potensic
//
//  Created by chen hua on 2019/1/28.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,CaptureButtonMode) {
    
    CaptureButtonMode_Photo = 0,
    CaptureButtonMode_Video = 1
};

@interface CaptureButton_Component : UIButton

+ (instancetype)captureButton;

+ (instancetype)captureButtonWithMode:(CaptureButtonMode)captureButtonMode;

@property (nonatomic)CaptureButtonMode captureButtonMode;

@end


NS_ASSUME_NONNULL_END
