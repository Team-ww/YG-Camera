//
//  ACVideoMessageViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/31.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACVideoMessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *widthLabel;

@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *formLabel;
@end

NS_ASSUME_NONNULL_END
