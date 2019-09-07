//
//  BLEPacket.h
//  Potensic
//
//  Created by chen hua on 2019/4/1.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLEPacket : NSObject

+(NSData *)sendControlDatawithBytes:(Byte *)byte  cmd:(uint8_t)cmd    length:(uint8_t)length;

@end

NS_ASSUME_NONNULL_END
