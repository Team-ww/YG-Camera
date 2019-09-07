//
//  GalleryEditSkinView.h
//  SelFly
//
//  Created by wenhh on 2017/11/16.
//  Copyright © 2017年 AEE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^skinViewReturnBlock)(CGFloat whiteningValue,CGFloat skinVlaue,NSInteger skinState);

@interface GalleryEditSkinView : UIView
@property (weak, nonatomic) IBOutlet UIView *skinSliderView;

@property (copy, nonatomic) skinViewReturnBlock skinReturnBlock;
- (void)refreshSkinView;

@end
