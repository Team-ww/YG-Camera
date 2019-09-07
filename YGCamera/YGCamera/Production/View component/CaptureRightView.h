//
//  CaptureRightView.h
//  YGCamera
//
//  Created by chen hua on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaptureRightView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *hdrImageview;
@property (weak, nonatomic) IBOutlet UIImageView *timingImageview;

- (void)showHDRView:(BOOL)hrdHidden   timingImageHidden:(BOOL)timingImageHidden   timIndex:(NSInteger)timIndex;

@end

NS_ASSUME_NONNULL_END
