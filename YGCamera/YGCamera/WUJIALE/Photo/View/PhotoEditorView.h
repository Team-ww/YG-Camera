//
//  PhotoEditorView.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/8/1.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonDidSelectedBlock)(CGFloat contranstValue,CGFloat exposureValue,CGFloat saturetionValue,CGFloat sharpenValue,CGFloat brightnessValue,CGFloat hueValue,NSInteger changeState,NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface PhotoEditorView : UIView

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topLeftImageView;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *bottomImageViewArr;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *bottomLabel;

- (void)clickButtonWithBlock:(buttonDidSelectedBlock)block;

- (void)refreshEditView;//初始化数据

- (void)cancelEditorButton;//取消编辑

- (void)confirmEditorButton;//完成编辑

@end

NS_ASSUME_NONNULL_END
