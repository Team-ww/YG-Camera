//
//  PhotoTool.h
//  AEE
//
//  Created by AEE_ios on 2017/6/5.
//  Copyright © 2017年 AEE_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger,CameraSource_HandleType){
    
    //当前操作的数据源类型
    CameraSource_HandleType_Collection = 0,
    CameraSource_HandleType_Image =1,
    CameraSource_HandleType_Video = 2,
   
};

@class PHAsset;

@interface PhotoTool : NSObject

//相机访问权限
+(PHAuthorizationStatus)getPhotoLibraryAuthorizationStatus;


//将远程文件保存至本地
+ (void)saveAssetFileFormWritedPath:(NSString*_Nullable)fullFilePath;


+ (void)checkPhotoService;


//获取对应图库资源集合
+(NSMutableArray *_Nullable)fetchResultWithType:(CameraSource_HandleType)handleType;


//展示系统图片或者视频，这个是可以拿到缩略图的
+ (void)requestPhotoLabraryImageforAssert:(PHAsset *_Nullable)asset  targetSize:(CGSize)targetSize  contentMode:(PHImageContentMode)contentMode resultHandler:(void(^_Nullable)(UIImage * _Nullable result, NSDictionary * _Nullable info))resultHandler;


//删除指定图片和视频
+ (void)deleteLocalLibrarySource:( NSArray <PHAsset *> *_Nullable)assets resultHandle:(void(^_Nullable)(BOOL isSuccess, NSError * _Nullable error))resultHandle;


////分享 视频或者图片（可多个）
+ (void)shareImagesOrVideos:(NSArray<PHAsset *>*_Nullable)items presentVC:(UIViewController *_Nullable)presentVC resultHandle:(void(^_Nullable)(BOOL isSuccess, NSError * _Nullable error))resultHandle;


//收藏  --- 取消收藏
+(void)requestColloectionPhotoLibraryForAssets:( NSArray <PHAsset *> *_Nullable)assets isCollection:(BOOL)isCollection resultHandle:(void(^_Nullable)(BOOL isSuccess, NSError * _Nullable error))resultHandle;


//获取当前 图片/视频 相关资源信息
+(void)requestDetailInfoWithAsset:(PHAsset *_Nullable)asset resultHandle:(void(^_Nullable)(float mediaSize, float fps))resultHandle;


//获取播放所用到的AVAsset
+(void)requestAVAssetForVideo:(PHAsset *_Nullable)asset resultHandle:(void(^_Nullable)(AVAsset * _Nullable asset))resultHandle;


//图库图片 --->存储到沙盒

+ (void)savePhotoImageToSanboxWithAsset:(PHAsset *_Nullable)asset  resultHandle:(void(^_Nullable)(BOOL isSuccess,NSString *_Nullable fileString))resultHandle;


//获取指定 资源文件（最新的）
+(PHAsset *)requestNewAssetWithType:(CameraSource_HandleType)handleType  ;

//保存图片到相册
+(void)saveImageGallery:(UIImage *)image;
@end
