//
//  HJTView.h
//  TestPopView
//
//  Created by AEE_ios on 2017/5/26.
//  Copyright © 2017年 AEE_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^RRBlock)(NSInteger index);

@interface HJTView : UIView


@property (nonatomic,strong) UIButton *sheetBtn;
@property (nonatomic,strong) UILabel *sheetLab;
@property (nonatomic,copy) RRBlock block;

- (void)selectedIndex:(RRBlock)block;

@end
