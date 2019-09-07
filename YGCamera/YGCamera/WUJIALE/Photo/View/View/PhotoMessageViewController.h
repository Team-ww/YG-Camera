//
//  PhotoMessageViewController.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/4.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoMessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *widthLabel;

@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *formatLabel;

@end

NS_ASSUME_NONNULL_END
