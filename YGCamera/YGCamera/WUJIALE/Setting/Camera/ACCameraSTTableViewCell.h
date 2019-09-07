//
//  ACCameraSTTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^scrollViewDidScrollBlock)(NSInteger offset);

NS_ASSUME_NONNULL_BEGIN

@interface ACCameraSTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

//- (void)setCellDateWithData:(NSArray *)dataArray index:(NSIndexPath *)index;

- (void)setCellDataWithArr:(NSArray *)dataSourceArr index:(NSIndexPath *)index selected:(NSInteger)selected;

- (void)setScrollViewContentOffsetWithBlock:(scrollViewDidScrollBlock)block;


@end

NS_ASSUME_NONNULL_END
