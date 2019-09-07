//
//  UITabBarVC.m
//  YGCamera
//
//  Created by chen hua on 2019/4/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "UITabBarVC.h"

@interface UITabBarVC ()

@end

@implementation UITabBarVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBarItemStatus:) name:@"HiddenBar" object:nil];
    NSArray *select_imageArr = @[@"tab_default_icon_select",@"tab_icon_album_select",@"tab_icon_find_sel",@"tab_icon_we_sel"];
    NSArray *unSelect_imageArr = @[@"tab_equipment_icon",@"tab_icon_album",@"tab_icon_find",@"tab_icon_we_icon"];
    NSArray *title_Arr = @[@"设备",@"相册",@"发现",@"我们"];
    NSArray<UITabBarItem *> *items = self.tabBar.items;
    for (int i = 0; i < items.count; i++) {
        UITabBarItem *item = items[i];
        [item setImage:[UIImage imageNamed:unSelect_imageArr[i]]];
        [item setSelectedImage:[UIImage imageNamed:select_imageArr[i]]];
        [item setTitle:title_Arr[i]];
    }
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.4]} forState:UIControlStateSelected];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBarItemStatus:) name:@"HiddenBar" object:nil];
}

- (void)updateBarItemStatus:(NSNotification *)notify{

    id object = notify.object;
    if ([object boolValue] == YES) {
        self.tabBar.hidden = YES;
    }else{
        self.tabBar.hidden = NO;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
