//
//  PhotoLibraryManager.h
//  Potensic
//
//  Created by chen hua on 2019/3/21.
//  Copyright © 2019 chen hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RequestAssetsLibraryAuthCompletion)(Boolean isAuth);
typedef void(^SavePhotoCompletionBlock)(UIImage *image, NSError *error);
typedef void(^SaveVideoCompletionBlock)(NSURL *vedioUrl, NSError *error);

@interface PhotoLibraryManager : NSObject


/**
 *  请求照片权限，注意，强烈要求用户获得照片权限，否则视频写入照片会有崩溃
 */
+ (void)requestALAssetsLibraryAuthorizationWithCompletion:(RequestAssetsLibraryAuthCompletion) requestAssetsLibraryAuthCompletion;

/**
 *  保存照片
 *
 *  @param image                UImage
 *  @param assetCollectionName  相册名字，不填默认为app名字+相册
 */
+ (void)savePhotoWithImage:(UIImage *)image andAssetCollectionName:(NSString *)assetCollectionName withCompletion:(SavePhotoCompletionBlock)savePhotoCompletionBlock;

/**
 *  保存视频
 *
 *  @param videoUrl             视频地址
 *  @param assetCollectionName  相册名字，不填默认为app名字
 */
+ (void)saveVideoWithVideoUrl:(NSURL *)videoUrl andAssetCollectionName:(NSString *)assetCollectionName withCompletion:(SaveVideoCompletionBlock)saveVideoCompletionBlock;

@end

NS_ASSUME_NONNULL_END
