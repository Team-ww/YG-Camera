//
//  CameraAreaModel.h
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraAreaModel : NSObject

@property(nonatomic,assign)NSInteger wt_st_index;
@property(nonatomic,assign)float wt_st_number;

@property(nonatomic,assign)NSInteger mf_st_index;
@property(nonatomic,assign)NSInteger mf_st_number;

@property(nonatomic,assign)NSInteger st_flag;

@property(nonatomic,assign)NSInteger wt_ed_index;
@property(nonatomic,assign)float     wt_ed_number;

@property(nonatomic,assign)NSInteger mf_ed_index;
@property(nonatomic,assign)NSInteger mf_ed_number;

@property(nonatomic,assign)NSInteger ed_flag;

@property(nonatomic,assign)NSInteger record_index;
@property(nonatomic,assign)NSInteger record_time;

@property(nonatomic,strong)NSMutableArray *wtArr;
@property(nonatomic,strong)NSMutableArray *mfArr;
@property(nonatomic,strong)NSMutableArray *recordArr;


@end

NS_ASSUME_NONNULL_END
