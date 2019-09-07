//
//  BTGCDTimer.m
//  Potensic
//
//  Created by chen hua on 2019/6/17.
//  Copyright © 2019 szbotanCompany. All rights reserved.
//


#import "BTGCDTimer.h"

@interface BTGCDTimer (){
    
    dispatch_source_t timer;
    BOOL isHeart;
}

@end

@implementation BTGCDTimer


-(void)start_GCDTimerWithQueue:(dispatch_queue_t)queue  frequency:(float)frequency  handleBlock:(void(^)(void))handleBlock{
    
    isHeart = YES;
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, frequency * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        handleBlock();
    });
    dispatch_resume(timer);
}


- (void)stop_GCDTimer{
    
    isHeart = NO;
    dispatch_source_cancel(timer);
    
}


- (BOOL)isHeartIng{
    
    return isHeart;
}

@end
