//
//  CacheModel.m
//  AEE
//
//  Created by mac_w on 2017/2/17.
//  Copyright © 2017年 LIU. All rights reserved.
//

#import "CacheModel.h"
static id cache = nil;

@implementation CacheModel

+ (instancetype)shareCache
{
    static CacheModel *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] initSingleton];
        [cache removeAllObjects];
    });
    return cache;
}

-(id)init
{
    return [self initSingleton];
}

- (id)initSingleton
{
    if (self = [super init]) {
        [cache setCountLimit:60];
        [cache setTotalCostLimit:2048];
    }
    return self;
}
@end
