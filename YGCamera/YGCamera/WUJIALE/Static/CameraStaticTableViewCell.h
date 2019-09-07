//
//  CameraStaticTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraStaticModel.h"

typedef void(^getStaticTimeBlock)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface CameraStaticTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *preView;

- (void)setCellWithData:(NSArray *)dataArr indexPath:(NSIndexPath *)index;

//回调
- (void)getStaticTimeWithBlock:(getStaticTimeBlock)block;

@end

NS_ASSUME_NONNULL_END
