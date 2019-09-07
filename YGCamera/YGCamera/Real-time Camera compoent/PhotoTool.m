//
//  PhotoTool.h
//  AEE
//
//  Created by AEE_ios on 2017/6/5.
//  Copyright © 2017年 AEE_iOS. All rights reserved.
//

#import "PhotoTool.h"

NSString * const PHOTONAME = @"YGCamera";
@implementation PhotoTool

//当前相机访问权限

+(PHAuthorizationStatus)getPhotoLibraryAuthorizationStatus{
    
    return [PHPhotoLibrary authorizationStatus];
}

//// 判断是否创建   PHOTONAME
+ (void)checkPhotoService{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) return;
    PHFetchResult *userFetch = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    for (int i = 0; i < userFetch.count; i++) {
        
        PHCollection *collect = userFetch[i];
        if ([collect.localizedTitle isEqualToString:PHOTONAME]) {
            return ;
        }
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:PHOTONAME];
    } completionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Error creating album: %@", error);
        }else{
            NSLog(@"Created");
        }
    }];
}

#pragma   mark  - PHPhotoLibrary Created

+ (void)saveAssetFileFormWritedPath:(NSString*_Nullable)fullFilePath{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) return;
    NSString *extenName = fullFilePath.pathExtension;
    BOOL isPhoto = ([extenName isEqualToString:@"mov"]||[extenName isEqualToString:@"MOV"]||[extenName isEqualToString:@"MP4"]||[extenName isEqualToString:@"mp4"])? NO:YES;
    //NSLog(@"isPhoto == %d",isPhoto);
    
    if([UIDevice currentDevice].systemVersion.floatValue < 9.0){
        
        NSData *data = [NSData dataWithContentsOfFile:fullFilePath];
        if (data == nil) return;
        if (isPhoto)
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], self, nil, NULL);
        else
            UISaveVideoAtPathToSavedPhotosAlbum(fullFilePath, self, nil, nil);
        
    }else{
        
        [self saveAssetFile:fullFilePath isPhoto:isPhoto];
    }
}

+(void)saveAssetFile:(NSString *_Nullable)fullFilePath isPhoto:(BOOL)isPhoto{
    //保存图片
    __block NSString *assetId = @"";
    // 1. 存储图片到"相机胶卷"
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 新建一个PHAssetCreationRequest对象
        // 返回PHAsset(图片)的字符串标识
        if (isPhoto)
            assetId = [PHAssetCreationRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:fullFilePath]].placeholderForCreatedAsset.localIdentifier;
        else
            assetId = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:fullFilePath]].placeholderForCreatedAsset.localIdentifier;
       // NSLog(@"assetID = %@",assetId);
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (!success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //后续完善
            });
            return ;
        }
        // 2. 获得相册对象
        PHAssetCollection *collection = [self getCollection];
        // 3. 将“相机胶卷”中的图片添加到新的相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            // 根据唯一标示获得相片对象
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
            //NSLog(@"%@---%@",asset.creationDate,fullFilePath);
            // 添加图片到相册中
            [request addAssets:@[asset]];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
          
            if (success) {
                NSLog(@"成功保存到相簿：%@----在沙盒中删除该文件", collection.localizedTitle);
                //在APP沙盒里面删除这个文件
                NSError *fileError = nil;
                [[NSFileManager  defaultManager] removeItemAtPath:fullFilePath error:&fileError];
                if (fileError) {
                    NSLog(@"沙盒文件删除异常 error == %@",error);
                }
            }
        }];
    }];
}

+ (PHAssetCollection *_Nullable)getCollection {
    
    // 先获得之前创建过的相册
    PHFetchResult *userFetch = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];;
    for (PHAssetCollection *collection in userFetch) {
        if ([collection.localizedTitle isEqualToString:PHOTONAME]) {
            return collection;
        }
    }
    
    // 如果相册不存在,就创建新的相册(文件夹)
    __block NSString *collectionId = nil; // __block修改block外部的变量的值
    // 这个方法会在相册创建完毕后才会返回
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 新建一个PHAssertCollectionChangeRequest对象, 用来创建一个新的相册
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:PHOTONAME].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
}

//获取系统创建的图库资源
+(NSMutableArray *_Nullable)fetchResultWithType:(CameraSource_HandleType)handleType{

    
    NSMutableArray *dateArr = [NSMutableArray array];//用于存放日期
    NSMutableArray *thumgImageArr = [NSMutableArray array];//用于存放日期对应下的图片资源
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    NSMutableArray *tempArr = [NSMutableArray array];//临时图片资源
    PHFetchResult *fetchResults =  [PHAsset fetchAssetsInAssetCollection:[self getCollection] options:options];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    formatDate.dateFormat = @"MMMM' 'dd', 'yyyy";
    NSString *currentDateString = [formatDate stringFromDate:currentDate];
    
    [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        
        
        
        PHAsset *asset = obj;
        if (handleType == CameraSource_HandleType_Image) {

            if (asset.mediaType == PHAssetMediaTypeImage) {
                NSString *creationStr = [self getCurrentDayInfo:asset.creationDate todayStr:currentDateString];
                if (![dateArr containsObject:creationStr]) {
                    [dateArr addObject:creationStr];
                    
                    if (tempArr.count>0) {
                        [thumgImageArr addObject:[tempArr mutableCopy]];
                        [tempArr removeAllObjects];
                    }
                    
                }
                [tempArr addObject:asset];
                
            }
            if (idx == fetchResults.count -1) {
                [thumgImageArr addObject:[tempArr mutableCopy]];
            }

        }else if (handleType == CameraSource_HandleType_Video){

            if (asset.mediaType == PHAssetMediaTypeVideo) {
                NSString *creationStr = [self getCurrentDayInfo:asset.creationDate todayStr:currentDateString];
                
                if (![dateArr containsObject:creationStr]) {
                    [dateArr addObject:creationStr];
                    
                    if (tempArr.count>0) {
                        [thumgImageArr addObject:[tempArr mutableCopy]];
                        [tempArr removeAllObjects];
                    }
                }
                [tempArr addObject:asset];
                
            }
            if (idx == fetchResults.count -1) {
                [thumgImageArr addObject:[tempArr mutableCopy]];
            }

        }else if (handleType == CameraSource_HandleType_Collection){

            NSString *creationStr = [self getCurrentDayInfo:asset.creationDate todayStr:currentDateString];
            
            if (![dateArr containsObject:creationStr]) {
                [dateArr addObject:creationStr];
                
                if (tempArr.count>0) {
                    [thumgImageArr addObject:[tempArr mutableCopy]];
                    [tempArr removeAllObjects];
                }
                
            }
            [tempArr addObject:asset];
            
            if (idx == fetchResults.count -1) {
                [thumgImageArr addObject:[tempArr mutableCopy]];
            }
        }
       
        
    }];
    //    });
    
    NSMutableArray  *dateAndThumArr =  [NSMutableArray array];
    [dateAndThumArr addObject:dateArr];
    [dateAndThumArr addObject:thumgImageArr];
    
    return dateAndThumArr;
    
    
//    PHFetchOptions *options = [PHFetchOptions new];
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
//    PHFetchResult *fetchResults =  [PHAsset fetchAssetsInAssetCollection:[self getCollection] options:options];
//    NSMutableArray  *sourceArr =  [NSMutableArray array];
//    [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//
//        PHAsset *asset = obj;
//        if (handleType == CameraSource_HandleType_Image) {
//
//            if (asset.mediaType == PHAssetMediaTypeImage) {
//                [sourceArr addObject:asset];
//            }
//
//        }else if (handleType == CameraSource_HandleType_Video){
//
//            if (asset.mediaType == PHAssetMediaTypeVideo) {
//                 [sourceArr addObject:asset];
//            }
//
//        }else if (handleType == CameraSource_HandleType_Collection){
//
//            if (asset.isFavorite) {
//                [sourceArr addObject:asset];
//            }
//        }
//    }];
//    return sourceArr;
}

+ (NSString *)getCurrentDayInfo:(NSDate *)data todayStr:(NSString *)todayStr{
    
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    formatDate.dateFormat = @"MMMM' 'dd', 'yyyy";
    NSString *currentDateString = [formatDate stringFromDate:data];
    if ([currentDateString isEqualToString:todayStr]) {
        return @"Today";
    }else{
        return currentDateString;
    }
}


//展示系统图片或者视频
+ (void)requestPhotoLabraryImageforAssert:(PHAsset *_Nullable)assert  targetSize:(CGSize)targetSize  contentMode:(PHImageContentMode)contentMode resultHandler:(void(^_Nullable)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler
{
    
    if ( assert.mediaType == PHAssetMediaTypeImage) {
        
        PHImageManager *manager = [PHImageManager defaultManager];
        PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
//      options.synchronous = YES;
        [manager requestImageForAsset:assert
                           targetSize:targetSize
                          contentMode:contentMode
                              options:options
                        resultHandler:^(UIImage *result, NSDictionary *info) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                resultHandler(result,info);
                            });
                        }];
        
    } else if ( assert.mediaType == PHAssetMediaTypeVideo) {
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:assert options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
            generator.appliesPreferredTrackTransform = YES;
            CMTime time = CMTimeMake(0.1, 30);
            AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                UIImage *thumbImg = [UIImage imageWithCGImage:image];
                if (result == AVAssetImageGeneratorSucceeded) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        resultHandler(thumbImg, info);
                    });
                }
            };
            
//          generator.maximumSize = CGSizeMake(200, 200);
            generator.maximumSize = targetSize;
            [generator generateCGImagesAsynchronouslyForTimes:
            [NSArray arrayWithObject:[NSValue valueWithCMTime:time]] completionHandler:handler];
        }];
    }
}

//删除指定图片和视频
+ (void)deleteLocalLibrarySource:( NSArray <PHAsset *> * _Nullable)assets resultHandle:(void(^_Nullable)(BOOL isSuccess, NSError *_Nullable error))resultHandle{
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:assets];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultHandle(success,error);
        });
    }];
}

+ (void)shareImagesOrVideos:(NSArray<PHAsset *>*_Nullable)items presentVC:(UIViewController *_Nullable)presentVC resultHandle:(void(^_Nullable)(BOOL isSuccess, NSError *_Nullable error))resultHandle{
    
    PHAssetResourceManager *manager = [PHAssetResourceManager defaultManager];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *urlArr = [NSMutableArray array];
    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    for (int i = 0; i < items.count; i++) {
        
        PHAsset *asset = items[i];
        PHAssetResource *source = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
        NSString *fileName;
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            fileName = [NSString stringWithFormat:@"FILERova%d.MOV",i+1];
        }else if (asset.mediaType == PHAssetMediaTypeImage){
            fileName = [NSString stringWithFormat:@"FILERova%d.JPG",i+1];
        }
        NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:filePath]) {
            [fileManager removeItemAtPath:filePath error:nil];
        }
        NSURL  *fileURL = [NSURL fileURLWithPath:filePath];
        [manager writeDataForAssetResource:source toFile:fileURL options:nil completionHandler:^(NSError * _Nullable error) {
            if (!error) [urlArr addObject:fileURL];
        }];
    }
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:urlArr applicationActivities:nil];
    //不显示哪些分享平台
    if ([[UIDevice currentDevice]systemVersion].floatValue >= 9.0) {
        avc.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAddToReadingList,UIActivityTypeAirDrop,UIActivityTypeSaveToCameraRoll,UIActivityTypeAssignToContact,UIActivityTypeOpenInIBooks];
    }
    [presentVC presentViewController:avc animated:YES completion:nil];
    //分享结果回调方法
    UIActivityViewControllerCompletionWithItemsHandler myblock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        
        for (int i = 0; i <urlArr.count; i++) {
            
            NSURL *tempUrl = urlArr[i];
            NSMutableString *temUrlStr = [tempUrl.description mutableCopy];
            if ([temUrlStr containsString:@"file://"]) {
                [temUrlStr deleteCharactersInRange:NSMakeRange(0, 7)];
                if ([fileManager fileExistsAtPath:temUrlStr]) {
                    NSError *error = nil;
                    [fileManager removeItemAtPath:temUrlStr error:&error];
                }
            }
        }
        resultHandle(completed,activityError);
    };
    avc.completionWithItemsHandler = myblock;
}

+(void)requestColloectionPhotoLibraryForAssets:( NSArray <PHAsset *> *_Nullable)assets isCollection:(BOOL)isCollection resultHandle:(void(^_Nullable)(BOOL isSuccess, NSError * _Nullable error))resultHandle{
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        for (PHAsset *asset in assets) {
            PHAssetChangeRequest *request = [PHAssetChangeRequest changeRequestForAsset:asset];
                request.favorite = isCollection;
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            resultHandle(success,error);
        });
    }];
}

+(void)requestDetailInfoWithAsset:(PHAsset *_Nullable)asset resultHandle:(void(^_Nullable)(float mediaSize, float fps))resultHandle{
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            //NSLog(@"NSDictionary:%@",info);
            dispatch_async(dispatch_get_main_queue(), ^{
                resultHandle(imageData.length/(1024.0 *1024.0),0);
            });
        }];
        
    }else if (asset.mediaType == PHAssetMediaTypeVideo){
        
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                NSNumber *size;
                [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                float fps = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
                //NSLog(@"fps >>>>%f",fps);
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultHandle([size floatValue]/(1024.0 *1024.0),fps);
                });
            }
        }];
    }
}

//获取播放所用到的AVAsset
+(void)requestAVAssetForVideo:(PHAsset *_Nullable)asset resultHandle:(void(^_Nullable)(AVAsset * _Nullable asset))resultHandle{
    
    PHCachingImageManager * imageManager = [[PHCachingImageManager alloc] init];
    [imageManager requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            return resultHandle(asset);
        });
        
    }];
}

//图库图片 --->存储到沙盒
+ (void)savePhotoImageToSanboxWithAsset:(PHAsset *_Nullable)asset  resultHandle:(void(^_Nullable)(BOOL isSuccess,NSString *_Nullable fileString))resultHandle{
    
    PHAssetResourceManager *manager = [PHAssetResourceManager defaultManager];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    PHAssetResource *source = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    NSString *fileName = [NSString stringWithFormat:@"FILEVR%d.JPG",1];
    NSString *filePath = [fullPath stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
        NSURL  *fileURL = [NSURL fileURLWithPath:filePath];
    [manager writeDataForAssetResource:source toFile:fileURL options:nil completionHandler:^(NSError * _Nullable error) {
        
          if (!error) {
              return resultHandle(YES,filePath);
          }else{
              return resultHandle(NO,nil);
          }
    }];
}

//获取指定 资源文件（最新的）
+(PHAsset *_Nullable)requestNewAssetWithType:(CameraSource_HandleType)handleType{
    
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    if (handleType == CameraSource_HandleType_Image) {
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    }else{
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];
    }
    options.fetchLimit = 1;
    PHFetchResult *fetchResults =  [PHAsset fetchAssetsInAssetCollection:[self getCollection] options:options];
    if (fetchResults.count == 1) {
        return [fetchResults objectAtIndex:0];
    }else{
        return nil;
    }
}

+(void)saveImageGallery:(UIImage *)image {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    formatDate.dateFormat = @"MMMM''dd''yyyy";
    //系统的时间
    NSString *currentDateString = [formatDate stringFromDate:currentDate];
    //拿到图片
    UIImage *imagesave = image;
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",currentDateString]];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES];
    [self saveAssetFileFormWritedPath:imagePath];
}

@end
