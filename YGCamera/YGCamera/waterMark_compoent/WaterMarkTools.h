//
//  WaterMarkTools.h
//  YGCamera
//
//  Created by chen hua on 2019/4/16.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface WaterMarkTools : NSObject


//视频添加水印
+ (void)videoAddTitlWithTitle:(NSString *)title videoURL:(NSString *)urlStr  outURL:(NSURL *)outUrl  completionHandle:(void(^)())completionHandleBlock;


//图片添加水印
+ (UIImage *)addWaterTextWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed;


@end

NS_ASSUME_NONNULL_END
