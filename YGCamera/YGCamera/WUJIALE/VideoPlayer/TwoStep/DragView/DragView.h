//
//  DragView.h
//  VideoPlayer
//
//  Created by 吴家乐 on 2019/7/26.
//  Copyright © 2019 吴家乐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DragView : UIView

@property (nonatomic,strong)UILabel *timeLabel;

@property(assign ,nonatomic)UIEdgeInsets hitTestEdgInsets;

- (instancetype)initWithFrame:(CGRect)frame Left:(BOOL)left;

- (BOOL)pointInsideSelf:(CGPoint)point;

- (BOOL)pointInsideImgView:(CGPoint)point;



@end

NS_ASSUME_NONNULL_END
