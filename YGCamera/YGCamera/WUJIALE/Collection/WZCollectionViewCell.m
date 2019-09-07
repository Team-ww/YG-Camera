//
//  WZCollectionViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "WZCollectionViewCell.h"

@implementation WZCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setCellWithIndex:(NSInteger)index indexPath:(nonnull NSIndexPath *)indexPath {
    
    if (index == 0) {
        
        if (indexPath.row == 0) {
            self.titleLabel.text = @"1s";
        }else if (indexPath.row == 1){
            self.titleLabel.text = @"2s";
        }else{
            self.titleLabel.text = @"60s";
        }
    }else if (index == 1){
        if (indexPath.row == 0) {
            self.titleLabel.text = @"30s";
        }else if (indexPath.row == 1){
            self.titleLabel.text = @"1min";
        }else{
            self.titleLabel.text = @"5h";
        }
    }
    
}


#pragma mark 希区柯克
- (void)setCollectionWithData:(CameraAreaModel *)model indentifier:(NSString *)indentifier indexPath:(nonnull NSIndexPath *)indexPath {
    
    if ([indentifier isEqualToString:@"WT"]) {
        
        if (indexPath.row < model.wtArr.count) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@",model.wtArr[indexPath.row]];
        }
        
    }else if ([indentifier isEqualToString:@"MF"]){
        
        if (indexPath.row < model.mfArr.count) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@",model.mfArr[indexPath.row]];
        }
        
    }
    
}


- (void)setRecordWithData:(CameraAreaModel *)model indexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row < model.recordArr.count) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",model.recordArr[indexPath.row]];
    }
    
}

@end
