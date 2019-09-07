//
//  ACCameraDetailsCollectionViewCell.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/28.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraDetailsCollectionViewCell.h"

@implementation ACCameraDetailsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithData:(SetDetailModel *)model defaultArr:(NSArray *)defaultArr selectedArr:(NSArray *)selectedArr titleArr:(NSArray *)titleArr item:(NSInteger)itemIndex index:(NSIndexPath *)index {

    if (itemIndex == 0) {
        if (index.row == model.cameraModel.index) {
            
            
            NSLog(@"index.row = %ld----%ld",(long)model.cameraModel.index,(long)index.row);
            self.imageIcon.image = [UIImage imageNamed:selectedArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:202/255.0 blue:91/255.0 alpha:1.0];
        }else{
            self.imageIcon.image = [UIImage imageNamed:defaultArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
        }
    }else if (itemIndex == 1){
        if (index.row == model.filterModel.index) {
            
            self.imageIcon.image = [UIImage imageNamed:selectedArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:202/255.0 blue:91/255.0 alpha:1.0];
            
        }else{
            
            self.imageIcon.image = [UIImage imageNamed:defaultArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
        }
    }else if (itemIndex == 2){
        if (index.row == model.timeModel.index) {
            
            self.imageIcon.image = [UIImage imageNamed:selectedArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:202/255.0 blue:91/255.0 alpha:1.0];
            
        }else{
            
            self.imageIcon.image = [UIImage imageNamed:defaultArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
        }
    }else if (itemIndex == 3){
        if (index.row == model.hdrModel.index) {
            
            self.imageIcon.image = [UIImage imageNamed:selectedArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:202/255.0 blue:91/255.0 alpha:1.0];
            
        }else{
            
            self.imageIcon.image = [UIImage imageNamed:defaultArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
        }
    }else if (itemIndex == 4){
        if (index.row == model.lightModel.index) {
            
            self.imageIcon.image = [UIImage imageNamed:selectedArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:202/255.0 blue:91/255.0 alpha:1.0];
            
        }else{
            
            self.imageIcon.image = [UIImage imageNamed:defaultArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
        }
    }else if (itemIndex == 5){
        if (index.row == model.sportModel.index) {
            
            self.imageIcon.image = [UIImage imageNamed:selectedArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:180/255.0 green:202/255.0 blue:91/255.0 alpha:1.0];
            
        }else{
            
            self.imageIcon.image = [UIImage imageNamed:defaultArr[index.row]];
            self.titleLabel.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
        }
    }
    
    self.titleLabel.text = titleArr[index.row];
}



@end
