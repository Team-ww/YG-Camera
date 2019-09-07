//
//  RecordTimeView.m
//  YGCamera
//
//  Created by iOS_App on 2019/7/22.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "RecordTimeView.h"

@interface RecordTimeView (){
    
    NSInteger timeCount;
}

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RecordTimeView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
}

- (void)startRecord{
    
    self.hidden = NO;
    timeCount = 0;
    self.recordTimeLab.text = @"00:00:00";
    [self startTimer];
}


- (void)stopRecord{
    
     self.hidden = YES;
    [self stopTimer];
}

- (NSInteger)getTimCount{
    
    return timeCount;
}


- (void)updateRecordTime{
    NSInteger hours = (timeCount / 3600);
    NSInteger minutes = (timeCount / 60) % 60;
    NSInteger seconds = timeCount % 60;
    NSString *format = @"%02i:%02i:%02i";
    NSString *timeString = [NSString stringWithFormat:format, hours, minutes, seconds];
        self.recordTimeLab.text = timeString;
        [UIView animateWithDuration:0.6 animations:^{
            self.recordTimeStatusImageview.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.recordTimeStatusImageview.alpha = 1;
            }];
        }];
}

- (void)startTimer {
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:self
                                       selector:@selector(updateTimeDisplay)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateTimeDisplay {
    
    timeCount++;
    [self updateRecordTime];
    // [self.topBarView updateRecordTime:timeCount];
}


- (void)stopTimer {
    timeCount = 0;
    [self.timer invalidate];
    self.timer = nil;
    self.recordTimeLab.text = @"00:00:00";
}

@end
