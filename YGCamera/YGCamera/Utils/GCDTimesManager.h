//
//  GCDTimesManager.h
//  Potensic
//
//  Created by chen hua on 2019/1/17.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDTimesManager : NSObject


+(void)countDown_GCDTimerWithQueue:(dispatch_queue_t)queue   handleBlock:(void(^)(bool isChanged))handleBlock;


@end

NS_ASSUME_NONNULL_END
