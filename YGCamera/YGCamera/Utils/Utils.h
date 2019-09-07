//
//  Utils.h
//  S1 VR 360
//
//  Created by chen hua on 2018/3/13.
//  Copyright © 2018年 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <netinet/tcp.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height


@interface Utils : NSObject

//存储文件沙盒路径
+ (NSString *)saveRtspStreamToFileWithType:(NSString *)fileType;

//录像时间格式转化
+(NSString *)translateSecsToString:(NSUInteger)secs;

//获取图库文件路径
+(NSString *)getPHAssetPathWithFileName:(NSString *)fileName;

//NSDate 转 NSString
+(NSString *)translateDateToString:(NSDate *)date;

//文件大小
+(int32_t)fileSizeAtPath:(NSString *)filePath;

//获取当前主机的地址
+(NSString *)getIpAddresses;

//获取沙盒Doucment 地址信息
+(NSString *)getSanbox_Doucment_path;

//删除某个目录下的所有文件
+(void)deleteFileAtDocmentsPath:(NSString *)path;

//某个目录下文件
+(NSString*)getFilePathAtDocmentsPath:(NSString *)path;

//错8小时 UTC
+(NSString *)getForamtDateStr:(NSDate *)date;

+(NSString *)convertToNSStringWithNSData:(NSData *)data;

+ (NSURL *)outputURL;


//判断手机是否为iohoneX类型
+ (BOOL)isiphoneX;
@end
