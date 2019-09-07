//
//  GalleryEditFilterViews.h
//  SelFly
//
//  Created by wenhh on 2017/11/15.
//  Copyright © 2017年 AEE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FilterViewsReturnBlock)(NSInteger Row,NSInteger filterViewState);

@interface GalleryEditFilterViews : UIView

@property (copy, nonatomic) FilterViewsReturnBlock filterReturnBlock;

- (void)refreshFiltersView;

@end
