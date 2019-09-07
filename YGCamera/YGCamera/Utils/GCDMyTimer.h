//
//  GCDMyTimer.h
//  Potensic
//
//  Created by chen hua on 2019/1/22.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDMyTimer : NSObject

-(void)start_GCDTimerWithQueue:(dispatch_queue_t)queue  frequency:(float)frequency  handleBlock:(void(^)(void))handleBlock;

- (void)stop_GCDTimer;

- (BOOL)countDownStatus;

@end

NS_ASSUME_NONNULL_END
