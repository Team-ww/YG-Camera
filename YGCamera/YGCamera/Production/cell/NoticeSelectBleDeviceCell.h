//
//  NoticeSelectBleDeviceCell.h
//  YGCamera
//
//  Created by chen hua on 2019/5/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSelectBleDeviceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *slelectTipSLab;
@property (weak, nonatomic) IBOutlet UIImageView *rotate_imageview;

- (void)startAnimation;

- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
