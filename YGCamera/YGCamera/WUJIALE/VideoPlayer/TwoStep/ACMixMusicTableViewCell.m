//
//  ACMixMusicTableViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/30.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACMixMusicTableViewCell.h"

@implementation ACMixMusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setCellWithName:(NSString *)musicName indexPath:(NSIndexPath *)index selcted:(NSInteger)selectedNumber {
    
    if (index.row == selectedNumber) {
        self.musicTitle.textColor = [UIColor colorWithRed:174/255.0 green:204/255.0 blue:68/255.0 alpha:1.0];
        self.musicName.textColor = [UIColor colorWithRed:174/255.0 green:204/255.0 blue:68/255.0 alpha:1.0];
    }else {
        self.musicTitle.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.musicName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    }
    
    self.musicTitle.text = [NSString stringWithFormat:@"曲目%02ld",index.row+1];
    self.musicName.text = musicName;
    
}



@end
