//
//  HJTAnimationView.h
//  TestPopView
//
//  Created by AEE_ios on 2017/5/26.
//  Copyright © 2017年 AEE_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

//选择位置
typedef void (^CLBlock)(NSInteger index);
//选择按钮
typedef void(^CLBtnBlock)(UIButton *btn);

@interface HJTAnimationView : UIView

@property (nonatomic,copy) CLBlock block;
@property (nonatomic,copy) CLBtnBlock btnBlock;
@property (nonatomic,strong) UIView *largeView;

/**
 *  初始化动画视图
 *
 *  @param titlearray title数组
 ＊ @param picarray    图标数组
 */

- (id)initWithTitleArray:(NSArray *)titlearray picarray:(NSArray *)picarray pointY:(CGFloat)pointY isLeft:(BOOL)isLeft   margin:(CGFloat)margin  selectIndex:(NSInteger)selectIndex;

//视图展示
- (void)show;

//选中的index
- (void)selectedWithIndex:(CLBlock)block;

//按钮block
- (void)CLBtnBlock:(CLBtnBlock)block;
@end
