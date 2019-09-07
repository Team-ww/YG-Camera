//
//  CameraPhotoTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraPhotoTableViewCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray *dataSourceArr;

@property (weak, nonatomic) IBOutlet UIView *preView;


@end

NS_ASSUME_NONNULL_END
