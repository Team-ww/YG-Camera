//
//  GalleryEditFiltersCell.m
//  SelFly
//
//  Created by wenhh on 2017/11/15.
//  Copyright © 2017年 AEE. All rights reserved.
//

#import "GalleryEditFiltersCell.h"
#import "UIColor+Utils.h"

@implementation GalleryEditFiltersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //点击选择的图
    UIView *selectView = [[UIView alloc]initWithFrame:self.bounds];
    selectView.backgroundColor = [UIColor clearColor];
    UIView *alphaView = [[UIView alloc]initWithFrame:selectView.bounds];
    alphaView.backgroundColor = [UIColor clearColor];
//    alphaView.alpha = 0.3;
    [selectView addSubview:alphaView];
    
//    CGRect currentImgViewRect = [self getContentImageRect];
    self.selectStateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 33, self.bounds.origin.y+14, 14, 14)];
    self.selectStateImageView.image = [UIImage imageNamed:@"galleryList_cell_select"];
    [selectView addSubview:self.selectStateImageView];
    self.selectLab = [[UILabel alloc] init];
    self.selectLab.backgroundColor = [UIColor blackColor];
    self.selectLab.textColor = [UIColor colorWithStringHex:@"#FFE688" alpha:1.0];
    [selectView addSubview:self.selectLab];
    self.selectedBackgroundView = selectView;
    [self bringSubviewToFront:self.selectedBackgroundView];
}
- (CGRect)getContentImageRect{
    CGFloat ratio = self.cellFilterImgView.frame.size.width/ self.cellFilterImgView.image.size.width;
    CGSize size = self.cellFilterImgView.image.size;
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
   return CGRectMake(self.cellFilterImgView.center.x-W/2,self.cellFilterImgView.center.y-H/2, W, H);
}

@end
