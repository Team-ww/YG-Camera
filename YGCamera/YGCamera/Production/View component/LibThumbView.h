//
//  LibThumbView.h
//  YGCamera
//
//  Created by chen hua on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LibThumbView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *thumbImageview;
@property (weak, nonatomic) IBOutlet UIImageView *videoIndictImageview;
@property (weak, nonatomic) IBOutlet UIButton *thumbButton;

- (void)updateCapturePhoto:(NSData *)processedPNG;

- (void)updateThumImage;


@end

NS_ASSUME_NONNULL_END
