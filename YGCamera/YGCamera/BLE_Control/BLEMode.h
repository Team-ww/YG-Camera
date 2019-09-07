//
//  BLEMode.h
//  YGCamera
//
//  Created by chen hua on 2019/5/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


NS_ASSUME_NONNULL_BEGIN

@interface BLEMode : NSObject

@property (nonatomic,strong)CBPeripheral *peripheral;
@property (nonatomic,copy)NSString *macStr;
@property (nonatomic,assign)BOOL  isconnected;

@end

NS_ASSUME_NONNULL_END
