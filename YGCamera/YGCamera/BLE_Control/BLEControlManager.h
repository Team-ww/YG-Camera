//
//  BLEControlManager.h
//  Potensic
//
//  Created by iOS_App on 2019/3/31.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define M_BLE_NAME @"BT16"
#define M_BLE_MAC  @"A4C138050DC2"

NS_ASSUME_NONNULL_BEGIN

@protocol BLEControlManagerDelegate <NSObject>

- (void)updatePlatformStateWithCMD:(uint8_t)cmd playloadData:(NSData *)data;

- (void)connectResult:(BOOL )isuccess;

- (void)assetLibraryWriteFailedWithError:(NSError *)error;

- (void)updateDiscoverPeripheral;

@end

@interface BLEControlManager : NSObject


//手机设备
@property (nonatomic,strong)CBCentralManager *centralManager;

//外设设备
@property (nonatomic,strong)CBPeripheral *peripheral;

//特征值
@property (nonatomic,strong)CBCharacteristic *characteristic;

//服务
@property (nonatomic,strong)CBService *service;

//描述
@property (nonatomic,strong)CBDescriptor *descriptor;


@property(nonatomic,strong)NSMutableArray *peripheralArr;


@property (nonatomic,weak)id<BLEControlManagerDelegate> delegate;


@property (nonatomic,strong)NSMutableData *bleRecevieData;


+ (instancetype)sharedInstance;


- (void)initCentralManager;


- (void)connectDevice:(CBPeripheral *)peripheral;


//MARK: 2. 退出页面后，停止扫描 断开连接
- (void)stopScan;


// 查看连接状态
- (BOOL)checkConnectStatus;


-(void)sendDataToBLE:(NSData *)data;

@end

NS_ASSUME_NONNULL_END


