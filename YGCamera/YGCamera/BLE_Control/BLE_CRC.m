//
//  BLE_CRC.m
//  Potensic
//
//  Created by chen hua on 2019/4/1.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "BLE_CRC.h"

@implementation BLE_CRC

+ (BLECRC16)checkSumWithCMD:(uint8_t)cmd lens:(uint8_t)lens data:(Byte *)data{
    
    
    BLECRC16  crc16;
    crc16.checkSum_1 = cmd;
    crc16.checkSum_2 = crc16.checkSum_1;
    
    
    crc16.checkSum_1 += lens;
    crc16.checkSum_2 += crc16.checkSum_1;
    
    
    for (int i = 0; i < lens; i++) {
        crc16.checkSum_1 += data[i];
        crc16.checkSum_2 += crc16.checkSum_1;
    }
    
    
    return crc16;
}

@end
