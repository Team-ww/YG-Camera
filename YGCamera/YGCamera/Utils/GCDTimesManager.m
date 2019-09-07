//
//  GCDTimesManager.m
//  Potensic
//
//  Created by chen hua on 2019/1/17.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "GCDTimesManager.h"

@implementation GCDTimesManager

+(void)countDown_GCDTimerWithQueue:(dispatch_queue_t)queue   handleBlock:(void(^)(bool isChanged))handleBlock{
    
    __block int timeout = 8;//倒计时时间
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        timeout --;
        handleBlock(timeout <=4?YES:NO);
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
}

@end
