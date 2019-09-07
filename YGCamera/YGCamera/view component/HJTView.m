//
//  HJTView.m
//  TestPopView
//
//  Created by AEE_ios on 2017/5/26.
//  Copyright © 2017年 AEE_ios. All rights reserved.
//

//self.sheetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
////       self.sheetBtn.clipsToBounds = YES;
////        self.sheetBtn.layer.cornerRadius = 30;
////        [self.sheetBtn setCenter:CGPointMake(self.frame.size.width/2, 30)];
////        self.sheetBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
////        self.sheetLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, self.frame.size.width, 10)];
////        [self addSubview:self.sheetLab];
//
//[self.sheetBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
////        [self.sheetLab setTextAlignment:NSTextAlignmentCenter];
////        self.sheetLab.font = [UIFont systemFontOfSize:9];
//[self addSubview:self.sheetBtn];


#import "HJTView.h"

@implementation HJTView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sheetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
 //       self.sheetBtn.clipsToBounds = YES;
//        self.sheetBtn.layer.cornerRadius = 30;
//        [self.sheetBtn setCenter:CGPointMake(self.frame.size.width/2, 30)];
//        self.sheetBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        self.sheetLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, self.frame.size.width, 10)];
//        [self addSubview:self.sheetLab];
        
        [self.sheetBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//      [self.sheetLab setTextAlignment:NSTextAlignmentCenter];
//      self.sheetLab.font = [UIFont systemFontOfSize:9];
        [self addSubview:self.sheetBtn];
        
        self.sheetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height -10 )];
        self.sheetBtn.clipsToBounds = YES;
        self.sheetBtn.layer.cornerRadius = 25;
      //  [self.sheetBtn setCenter:CGPointMake(self.frame.size.width/2, 10)];
        self.sheetLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.width-25, self.frame.size.width , 25)];
        [self addSubview:self.sheetBtn];
        [self addSubview:self.sheetLab];
        [self.sheetBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.sheetLab setTextAlignment:NSTextAlignmentCenter];
        self.sheetLab.font = [UIFont systemFontOfSize:9];
        self.sheetLab.textColor = [UIColor redColor];
        //self.sheetLab.backgroundColor = [UIColor redColor];
        
    }
    return self;
}


- (void)btnClick
{
    if (self.block) {
        self.block(self.sheetBtn.tag);
    }
}

- (void)selectedIndex:(RRBlock)block
{
    self.block = block;
}



@end
