//
//  RecordTimeView.h
//  YGCamera
//
//  Created by iOS_App on 2019/7/22.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordTimeView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *recordTimeStatusImageview;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLab;

- (void)startRecord;

- (void)stopRecord;

- (void)updateRecordTime;

- (NSInteger)getTimCount;

@end

NS_ASSUME_NONNULL_END
