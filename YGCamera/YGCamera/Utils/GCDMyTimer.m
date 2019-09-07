//
//  GCDMyTimer.m
//  Potensic
//
//  Created by chen hua on 2019/1/22.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "GCDMyTimer.h"

@interface GCDMyTimer (){
    
    dispatch_source_t timer;
    int i ;
    
    BOOL isCounting;
}

@end


@implementation GCDMyTimer

-(void)start_GCDTimerWithQueue:(dispatch_queue_t)queue  frequency:(float)frequency  handleBlock:(void(^)(void))handleBlock{
    
    isCounting =  YES;
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    i = 0;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, frequency * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{

        if (self->i == 1) {
            handleBlock();
        }
        self->i++;
    });
    dispatch_resume(timer);
}



- (void)stop_GCDTimer{
    
    dispatch_source_cancel(timer);
    isCounting =  NO;
    
}


- (BOOL)countDownStatus{
    
    return isCounting;
}

@end
