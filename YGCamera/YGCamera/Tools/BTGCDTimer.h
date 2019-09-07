//
//  BTGCDTimer.h
//  Potensic
//
//  Created by chen hua on 2019/6/17.
//  Copyright © 2019 szbotanCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTGCDTimer : NSObject

-(void)start_GCDTimerWithQueue:(dispatch_queue_t)queue  frequency:(float)frequency  handleBlock:(void(^)(void))handleBlock;

- (void)stop_GCDTimer;

- (BOOL)isHeartIng;

@end

NS_ASSUME_NONNULL_END
