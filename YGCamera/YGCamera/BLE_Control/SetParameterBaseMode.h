//
//  SetParameterBaseMode.h
//  YGCamera
//
//  Created by iOS_App on 2019/8/20.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SetParameterBaseMode : NSObject

@property (nonatomic,assign)int8_t CtrlRate;
@property (nonatomic,assign)int8_t CtrlDeadband;
@property (nonatomic,assign)int8_t RockerCtrlRate;
@property (nonatomic,assign)int8_t RockerCtrlDeadband;

@end

