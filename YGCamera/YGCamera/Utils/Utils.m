//
//  Utils.m
//  S1 VR 360
//
//  Created by chen hua on 2018/3/13.
//  Copyright © 2018年 chen hua. All rights reserved.
//
#import "Utils.h"


@implementation Utils

+ (NSString *)saveRtspStreamToFileWithType:(NSString *)fileType{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    //NSLog(@"MP4 PATH: %@",path);
    NSDateFormatter *dateFormatter0 = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [dateFormatter0 setTimeZone:timeZone];
    [dateFormatter0 setDateFormat:@"yyMMddHHmmssAA"];
    NSString *currentDateStr = [dateFormatter0 stringFromDate:[NSDate date]];
    //NSLog(@"Current DateFormat MP4 %@\n",currentDateStr);
    NSString* outputVideoName=[NSString stringWithFormat:@"%@.%@",currentDateStr,fileType];
    NSString *videoOutputPath=[path stringByAppendingPathComponent:outputVideoName];
    return videoOutputPath;
}

+ (NSString *)translateSecsToString:(NSUInteger)secs {
    
    NSString *retVal = nil;
    int tempHour = 0;
    int tempMinute = 0;
    int tempSecond = 0;
    NSString *hour = @"";
    NSString *minute = @"";
    NSString *second = @"";
    tempHour = (int)(secs / 3600);
    tempMinute = (int)(secs / 60 - tempHour * 60);
    tempSecond = (int)(secs - (tempHour * 3600 + tempMinute * 60));
    //hour = [[NSNumber numberWithInt:tempHour] stringValue];
    //minute = [[NSNumber numberWithInt:tempMinute] stringValue];
    //second = [[NSNumber numberWithInt:tempSecond] stringValue];
    hour = [@(tempHour) stringValue];
    minute = [@(tempMinute) stringValue];
    second = [@(tempSecond) stringValue];
    if (tempHour < 10) {
        hour = [@"0" stringByAppendingString:hour];
    }
    if (tempMinute < 10) {
        minute = [@"0" stringByAppendingString:minute];
    }
    if (tempSecond < 10) {
        second = [@"0" stringByAppendingString:second];
    }
    retVal = [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
    return retVal;
}

+(NSString *)getPHAssetPathWithFileName:(NSString *)fileName{
    
   NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
   return  [fullPath stringByAppendingPathComponent:fileName];
}

+(NSString *)translateDateToString:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    return [dateFormatter stringFromDate:date];
}

//文件大小
+(int32_t)fileSizeAtPath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return (int32_t)[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//获取当前主机的地址
+(NSString *)getIpAddresses{
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    //NSLog(@"address  >>>%@",address);//address  >>>192.168.2.13
    return address;
}

//获取沙盒Doucment 地址信息
+(NSString *)getSanbox_Doucment_path{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    return path;
}

//删除某个目录下的所有文件
+(void)deleteFileAtDocmentsPath:(NSString *)path{
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in enumerator) {
    
        NSLog(@"fileName >>%@",fileName);
        [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
    }
}

//某个目录下文件
+(NSString*)getFilePathAtDocmentsPath:(NSString *)path{
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString *fileName = [[enumerator allObjects] firstObject];
    return [path stringByAppendingPathComponent:fileName];
}

//错8小时 UTC
+(NSString *)getForamtDateStr:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return  [formatter stringFromDate:date];
}

+(NSString *)convertToNSStringWithNSData:(NSData *)data{
    
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=0; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    
    return strTemp;
}

+ (NSURL *)outputURL {
    
    NSString *filePath =
    [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie.mov"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    }
    return url;
}

+ (BOOL)isiphoneX {
    
    if (@available(iOS 11.0,*)) {
        
        UIWindow *keywindow = [UIApplication sharedApplication].delegate.window;
        CGFloat bottomSafeInset = keywindow.safeAreaInsets.bottom;
        if (bottomSafeInset == 34.0f || bottomSafeInset == 21.0f) {
            return YES;
        }
    }
    
    return NO;
}

@end
