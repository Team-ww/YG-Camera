//
//  BleListCell.h
//  YGCamera
//
//  Created by chen hua on 2019/5/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BleListCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *selectStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *macNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *ble_RSSI_Imageview;


- (void)setImageWithRSSID:(NSInteger)rssidValue;

@end

NS_ASSUME_NONNULL_END
