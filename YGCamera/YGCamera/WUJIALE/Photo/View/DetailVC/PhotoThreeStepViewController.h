//
//  PhotoThreeStepViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/3.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoThreeStepViewController : UIViewController


@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *selectedImageViewArr;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectedButtonArr;


@end

NS_ASSUME_NONNULL_END
