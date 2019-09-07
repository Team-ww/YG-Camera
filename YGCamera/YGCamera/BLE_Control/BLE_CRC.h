//
//  BLE_CRC.h
//  Potensic
//
//  Created by chen hua on 2019/4/1.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>

struct BLECRC16 {
    
    UInt8 checkSum_1;
    UInt8 checkSum_2;
};
typedef struct BLECRC16 BLECRC16;

NS_ASSUME_NONNULL_BEGIN

@interface BLE_CRC : NSObject


+ (BLECRC16)checkSumWithCMD:(uint8_t)cmd lens:(uint8_t)lens data:(Byte *)data;



//didDiscoverCharacteristicsForService
//设备的服务(<CBService: 0x282b68c40, isPrimary = YES, UUID = FFE0>)
//服务对应的特征值(<CBCharacteristic: 0x281ae2be0, UUID = FFE1, properties = 0x10, value = <55aaa302 011dc3b1>, notifying = NO>)
//UUID(FFE1)
//count(2)



@end

NS_ASSUME_NONNULL_END
