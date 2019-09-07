//
//  BLEPacket.m
//  Potensic
//
//  Created by chen hua on 2019/4/1.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "BLEPacket.h"
#import "BLE_CRC.h"


@implementation BLEPacket


+(NSData *)sendControlDatawithBytes:(Byte *)byte  cmd:(uint8_t)cmd    length:(uint8_t)length{
    
    Byte packet[6+length];
    
    packet[0] = 0x55;
    packet[1] = 0xAA;
    packet[2] = cmd;
    packet[3] = length;
    for (int i = 0; i < length; i++) {
        packet[4+i] = byte[i];
    }
    BLECRC16  crc16;
    crc16 = [BLE_CRC checkSumWithCMD:cmd lens:length data:byte];
    packet[length +4] = crc16.checkSum_1;
    packet[length +5] = crc16.checkSum_2;
    return [NSData dataWithBytes:packet length:6+length];
}
@end
