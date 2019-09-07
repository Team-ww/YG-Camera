//
//  ACMixMusicTableViewCell.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/30.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACMixMusicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *musicTitle;

@property (weak, nonatomic) IBOutlet UILabel *musicName;

- (void)setCellWithName:(NSString *)musicName indexPath:(NSIndexPath *)index selcted:(NSInteger)selectedNumber;

@end

NS_ASSUME_NONNULL_END
