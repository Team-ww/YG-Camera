//
//  PhotoTwoStepViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/3.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoTwoStepViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoScaleButtonArr;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *selectedImageArr;


@end

NS_ASSUME_NONNULL_END
