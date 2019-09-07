//
//  PreviewBottomCell.h
//  YGCamera
//
//  Created by chen hua on 2019/7/27.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewBottomCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *parameterDetailLab;

@property(nonatomic,assign)BOOL showPArametersView;

- (void)setCellTextColor;

- (void)setMiddleTextColor;

@end

NS_ASSUME_NONNULL_END
