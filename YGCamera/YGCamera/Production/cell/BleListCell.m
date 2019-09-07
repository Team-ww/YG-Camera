//
//  BleListCell.m
//  YGCamera
//
//  Created by chen hua on 2019/5/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "BleListCell.h"



@implementation BleListCell


- (void)setImageWithRSSID:(NSInteger)rssidValue{
    
    
    //NSLog(@"rssidValue == %ld",(long)rssidValue);
    [self.ble_RSSI_Imageview setImage:[UIImage imageNamed:[NSString stringWithFormat:@"wifiCopy%ld",rssidValue+1]]];
    
}

@end
