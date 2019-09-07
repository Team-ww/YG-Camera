//
//  BLEControlManager.m
//  Potensic
//
//  Created by iOS_App on 2019/3/31.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import "BLEControlManager.h"
#import "BLE_CRC.h"
#import "Utils.h"
#import "BLEMode.h"

@interface BLEControlManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>


@end

@implementation BLEControlManager

+ (instancetype)sharedInstance {
    
    static BLEControlManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)initCentralManager{
    
    if (self.peripheralArr) {
        [self.peripheralArr removeAllObjects];
    }
    if (!self.centralManager) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }else{
        // 停止扫描
        [self.centralManager stopScan];
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

//MARK: 2. 退出页面后，停止扫描 断开连接
- (void)stopScan{
    
    // 停止扫描
    [self.centralManager stopScan];
    // 断开连接
    if(self.centralManager!=nil&&self.peripheral.state==CBPeripheralStateConnected){
        [self.centralManager cancelPeripheralConnection:self.peripheral];
    }
    if (self.delegate) {
        self.delegate = nil;
    }
}

// 查看连接状态
- (BOOL)checkConnectStatus{
    
if(self.centralManager!=nil&&self.peripheral.state==CBPeripheralStateConnected){
        return YES;
    }
    return NO;
}


- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    
    switch (central.state) {
        
        case CBManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
            
        case CBManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
            
        case CBManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
            
        case CBManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn: {
            NSLog(@"CBCentralManagerStatePoweredOn");
            //TODO: 搜索外设
            // services:通过某些服务筛选外设 传nil=搜索附近所有设备
            
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        default:
            break;
    }
}


/**
 发现设备后调用
 
 @param central 手机设备
 @param peripheral 外设
 @param advertisementData 外设携带数据
 @param RSSI 信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI
{
    //使用名字判断
    if ([peripheral.name isEqualToString:M_BLE_NAME]) {
        
        if (!_peripheralArr) _peripheralArr = [NSMutableArray array];
        if (_peripheralArr.count == 0) {
            
//            NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
//
//            NSLog(@"kCBAdvDataManufacturerData ==== %@    advertisementData=%@",data,advertisementData);
//
//            NSString *str = [Utils convertToNSStringWithNSData:data];
            BLEMode *mode = [[BLEMode alloc] init];
            mode.macStr = @"BT16";
            mode.peripheral = peripheral;
            [_peripheralArr addObject:mode];
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateDiscoverPeripheral)]) {
                [self.delegate updateDiscoverPeripheral];
            }
            
        }else{
            for (int i = 0; i < _peripheralArr.count; i++) {
                BLEMode *mode = _peripheralArr[i];
                CBPeripheral *currentP = mode.peripheral;
                if (![currentP.identifier.UUIDString isEqual:peripheral.identifier.UUIDString]) {
                    
//                    NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
//                    NSString *str = [Utils convertToNSStringWithNSData:data];
                    BLEMode *mode = [[BLEMode alloc] init];
                    mode.macStr = @"BT16";
                    mode.peripheral = peripheral;
                    [_peripheralArr addObject:mode];
                    if (self.delegate  && [self.delegate respondsToSelector:@selector(updateDiscoverPeripheral)]) {
                        [self.delegate updateDiscoverPeripheral];
                    }
                }
            }
        }

//        self.peripheral = peripheral;
//        [self.centralManager connectPeripheral:peripheral options:nil];
    }else{
        
    }
}


- (void)removeDevice_source{
    
    [_peripheralArr removeAllObjects];
}

- (void)connectDevice:(CBPeripheral *)peripheral{
    
    [self.centralManager connectPeripheral:peripheral options:nil];
}

//5.1外设连接成功

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if(self.centralManager!=nil&&self.peripheral.state==CBPeripheralStateConnected){
        [self.centralManager cancelPeripheralConnection:self.peripheral];
    }
    self.peripheral = peripheral;
    for (int i = 0; i < self.peripheralArr.count; i++) {
        BLEMode *mode = self.peripheralArr[i];
        if ([mode.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            mode.isconnected = YES;
        }else{
             mode.isconnected = NO;
        }
    }
    
//    [self removeDevice_source];
    NSLog(@"设备连接成功：%@",peripheral.name);
    // 设置代理
    [self.peripheral setDelegate:self];
    //6.1 外设发现服务，传nil代表不过滤
    [self.peripheral discoverServices:nil];
    //停止扫描
    [self.centralManager stopScan];
    if (self.delegate) {
        [self.delegate connectResult:YES];
    }
}


//5.2外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"设备连接失败：%@",peripheral.name);
    //重新从搜索外设开始
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    if (self.delegate) {
        [self.delegate connectResult:NO];
    }
}

//5.3丢失设备
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    [_peripheralArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BLEMode *mode = obj;
        CBPeripheral *currentP = mode.peripheral;
        if ([currentP.identifier.UUIDString isEqual:peripheral.identifier.UUIDString]) {
            [self->_peripheralArr removeObject:mode];
        }
    }];
    self.peripheral = nil;
    NSLog(@"设备丢失连接:%@",peripheral.name);
    //重新x从搜索外设开始
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    if (self.delegate) {
        [self.delegate connectResult:NO];
    }
}

//6.2 发现外设服务回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"设备获取w服务失败：%@",peripheral.name);
        return;
    }
    for (CBService *service in peripheral.services) {
        
        self.service = service;
        NSLog(@"设备的服务(%@),UUID(%@),count(%u)",service,service.UUID,peripheral.services.count);
        //7.1外设发现特征
        [peripheral discoverCharacteristics:nil forService:service];
        
    }
}

//7.2从服务中发现外设特征的回调

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error
{
    
    for (CBCharacteristic *cha in service.characteristics) {
        
         NSLog(@"其他特征值：：：：：%@ ---- %@",cha.UUID,cha);
        if ([cha.UUID isEqual:[CBUUID UUIDWithString:@"FFE2"]]) {
             self.characteristic = cha;
           // [peripheral setNotifyValue:YES forCharacteristic:cha];
        }else if ([cha.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]){
            
//            NSLog(@"其他特征值：：：：：%@ ---- %@",cha.UUID,cha);
//            [peripheral readValueForCharacteristic:cha];
            [peripheral setNotifyValue:YES forCharacteristic:cha];
        }

        [peripheral discoverDescriptorsForCharacteristic:cha];
        //MARK9.1获取特征的值  会回调didUpdateValueForCharacteristic
      //  [peripheral readValueForCharacteristic:cha];
    }
}


//8.2 更新描述值回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"描述(%@)",descriptor.description);
}

//9.2更新特征值回调，可以理解为获取蓝牙发回的数据 //////////////////////////////////////////
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
    
    if (!self.bleRecevieData) {
        self.bleRecevieData = [NSMutableData data];
    }
    //NSLog(@"characteristic.value ==== %@",characteristic.value);
    NSData *readData = characteristic.value;
    [self.bleRecevieData appendData:readData];
    if (self.bleRecevieData.length < 6) return;
    int16_t   head = 0xAA55; //小端模式/大端模式
    NSData   *headData = [NSData dataWithBytes:&head length:2];
    
    for (NSUInteger i = 0;  i < [self.bleRecevieData length]; i ++) {
        
        NSRange range = [self.bleRecevieData rangeOfData:headData options:kNilOptions range:NSMakeRange(i, self.bleRecevieData.length - i)];
        if (range.location == NSNotFound) {
            
            continue;
        }
        
        i = range.location;
        
       // NSLog(@"range ==== %@",NSStringFromRange(range));
        if (self.bleRecevieData.length < range.location + 6) {
            continue ;
        }
        
        uint8_t cmd   = 0;
        uint8_t lens  = 0;
        [self.bleRecevieData getBytes:&cmd range:NSMakeRange(range.location+range.length, 1)];
        [self.bleRecevieData getBytes:&lens range:NSMakeRange(range.location+range.length+1, 1)];
        if (lens <= 0 ) {
            continue;
        }
        
        if (self.bleRecevieData.length < range.location + 6 + lens) {
            
            continue;
        }
        
        //<5555aaa0 020002a4 55aaa002 0701aa95>
        //算校验值
        Byte playLoadData [lens];
        [self.bleRecevieData getBytes:playLoadData range:NSMakeRange(range.location+4, lens)];
        BLECRC16 crc16 = [BLE_CRC checkSumWithCMD:cmd lens:lens data:playLoadData];
        
        uint8_t crc16_checkSum1 = 0;
        uint8_t crc16_checkSum2 = 0;
        [self.bleRecevieData getBytes:&crc16_checkSum1 range:NSMakeRange(range.location+4+lens, 1)];
        [self.bleRecevieData getBytes:&crc16_checkSum2 range:NSMakeRange(range.location+4+lens+1, 1)];
        
        if (crc16.checkSum_1 != crc16_checkSum1) continue ;
        if (crc16.checkSum_2 != crc16_checkSum2) continue ;
      
//        NSLog(@"cmd ====%d",cmd);
        if ([self.delegate respondsToSelector:@selector(updatePlatformStateWithCMD:playloadData:)]) {
            
            [self.delegate updatePlatformStateWithCMD:cmd playloadData:[self.bleRecevieData subdataWithRange:NSMakeRange(range.location+4, lens)]];
        }
        [self.bleRecevieData replaceBytesInRange:NSMakeRange(0, range.location + lens + 6) withBytes:NULL length:0];
        break;
    }
}

//MARK: 通知状态改变回调
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    } else {
//        NSLog(@"改变通知状态 Notification stopped on %@.  Disconnecting", characteristic);
//        NSLog(@"%@", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

//MAKR: 发现外设的特征的描述数组
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    // 在此处读取描述即可
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        self.descriptor = descriptor;
        //NSLog(@"发现外设的特征descriptor(%@)",descriptor);
        [peripheral readValueForDescriptor:descriptor];
    }
}

//MARK: 10.2 发送数据成功回调
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"写入数据失败:(%@)\n error:%@",characteristic,error.userInfo);
        // 这里用withResponse如果报错："Writing is not permitted."说明设备不允许写入，这个时候要用 WithoutResponse
        // 使用 WithoutResponse的时候，不走这个代理。
        return;
    }
    NSLog(@"写入数据成功:%@",characteristic);
    [peripheral readValueForCharacteristic:characteristic];
}

// MARK: 10.1 发送数据
//- (IBAction)openTheDoor:(id)sender {
//
//    NSString *doorStr =@"85019557102018082314450536D9BBAAF5A43B79F1B4639F995E4701DA57AFCDBDD0C866F07995EAB8MAG139A7D4V4B3QE1BQ2E5KETCI0H619OAO8MFA8FD1";
//    [self writeData:[doorStr dataUsingEncoding:NSUTF8StringEncoding]];
//}


//MARK: 发送数据
-(void)sendDataToBLE:(NSData *)data{
    
    if(nil != self.characteristic){
        
        // data: 数据data
        // characteristic: 发送给哪个特征
        // type:     CBCharacteristicWriteWithResponse,  CBCharacteristicWriteWithoutResponse,
        // 这里要跟硬件确认好，写入的特征是否有允许写入，允许用withResponse 不允许只能强行写入，用withoutResponse
        // 或者根据 10.2 回调的error查看一下是否允许写入，下面说
        // 我这里是不允许写入的，所以用了 WithoutResponse
        [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
    }
}

//MARK: 分段写入
- (void)writeData:(NSData *)data
{
    // 判断能写入字节的最大长度
    int maxValue;
    if (@available(iOS 9.0, *)) {
        // type:这里和上面一样，
        maxValue =(int)[self.peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithResponse];
    } else {
        // 默认是20字节
        maxValue =20;
    }
    NSLog(@"%i",maxValue);
    for (int i = 0; i < [data length]; i += maxValue) {
        // 预加 最大包长度，如果依然小于总数据长度，可以取最大包数据大小
        if ((i + maxValue) < [data length]) {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, maxValue];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            [self sendDataToBLE:subData];
            // 根据接收模块的处理能力做相应延时
            usleep(10 * 1000);
        }
        else {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, (int)([data length] - i)];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            [self sendDataToBLE:subData];
            usleep(10 * 1000);
        }
    }
}




@end
