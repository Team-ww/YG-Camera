//
//  WJLPopViewController.h
//  弹出下拉菜单
//
//  Created by 王建龙 on 16/4/12.
//  Copyright © 2016年 王建龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJLPopViewController;

@protocol WJLPopViewControllerDelegate <NSObject>

- (void)popViewController:(WJLPopViewController*)con didSelectAtIndex:(int)index;

@end

@interface WJLPopViewController : UIViewController

@property (nonatomic,weak)id<WJLPopViewControllerDelegate>delegate;

@property (nonatomic,strong)NSArray *listsArr;
@property (nonatomic,assign)BOOL isPreview;
@property (nonatomic,strong)NSArray *imageArr;
@property (nonatomic,assign)NSInteger selectIndex;


/**
 *soureceV和item二者选一
 */
- (instancetype)initWithPopView:(UIView*)soureceV orBaritem:(UIBarButtonItem*)item;



@end
