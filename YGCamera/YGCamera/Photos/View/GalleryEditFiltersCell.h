//
//  GalleryEditFiltersCell.h
//  SelFly
//
//  Created by wenhh on 2017/11/15.
//  Copyright © 2017年 AEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryEditFiltersCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellFilterImgView;
@property (weak, nonatomic) IBOutlet UILabel *filterNameLab;
@property (nonatomic,strong) UIImageView *selectStateImageView;
@property (strong, nonatomic) UILabel *selectLab;

@end
