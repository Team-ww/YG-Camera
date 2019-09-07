//
//  ThumbImageTools.m
//  YGCamera
//
//  Created by chen hua on 2019/4/14.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ThumbImageTools.h"
#import <UIKit/UIKit.h>

@implementation ThumbImageTools

+ (void)generateThumbnailForVideoAtURL:(NSURL *)videoURL {
    
    dispatch_async(dispatch_queue_create("com.thumbImage.DispatchQueue", NULL), ^{
        
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        AVAssetImageGenerator *imageGenerator =                             // 5
        [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        imageGenerator.maximumSize = CGSizeMake(100.0f, 0.0f);
        imageGenerator.appliesPreferredTrackTransform = YES;
        //获取单帧图片
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:kCMTimeZero // 6
                                                     actualTime:NULL
                                                          error:nil];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ThumbImage_Notify_Video" object:image];
        });
    });
}

@end
