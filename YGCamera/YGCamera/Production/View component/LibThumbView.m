//
//  LibThumbView.m
//  YGCamera
//
//  Created by chen hua on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "LibThumbView.h"
#import "PhotoTool.h"
#import "PhotoLibraryManager.h"
#import "PHAsset+YGAsset.h"

@interface LibThumbView ()

@property (strong, nonatomic)  UIImageView *realImageview;

@end

@implementation LibThumbView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.realImageview = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"playIcon"];
    self.realImageview.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.realImageview.center = self.thumbImageview.center;
    [self addSubview:self.realImageview];
    self.realImageview.backgroundColor = [UIColor clearColor];
    self.realImageview.contentMode = UIViewContentModeScaleAspectFill;
    self.realImageview.layer.masksToBounds = YES;
    self.realImageview.layer.cornerRadius = 5;
    [self insertSubview:self.realImageview aboveSubview:self.thumbImageview];
    [self insertSubview:self.videoIndictImageview aboveSubview:self.realImageview];
    
    
//    UIImage *image = [UIImage imageNamed:@"playIcon"];
//
//    self.thumbImageview.frame = CGRectMake(self.thumbImageview.frame.origin.x, self.thumbImageview.frame.origin.y, image.size.width, image.size.height);
    
//    UIImage *image = [UIImage imageNamed:@"playIcon"];
//    self.h.constant = image.size.height;
//    self.w.constant = image.size.width;
//    self.thumbImageview.frame = CGRectMake(self.thumbImageview.frame.origin.x, self.thumbImageview.frame.origin.y, <#CGFloat width#>, <#CGFloat height#>)
    
}

- (void)updateCapturePhoto:(NSData *)processedPNG{
    
    UIImage *image = [UIImage imageWithData:processedPNG];
    [PhotoLibraryManager savePhotoWithImage:image andAssetCollectionName:@"YGCamera" withCompletion:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue() , ^{
            //self.realImageview.center = self.thumbImageview.center;
            self.realImageview.image = image;
            self.videoIndictImageview.hidden = YES;
            
        });
    }];
//    [PhotoLibraryManager savePhotoWithImage:[UIImage imageWithData:processedPNG] andAssetCollectionName:@"YGCamera" withCompletion:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
//        dispatch_async(dispatch_get_main_queue() , ^{
//            //self.realImageview.center = self.thumbImageview.center;
//            self.realImageview.image = image;
//            self.videoIndictImageview.hidden = YES;
//
//        });
//    }];
}

- (void)updateThumImage{
    
    PHAsset *latest = [PHAsset latestAsset];
    [PhotoTool requestPhotoLabraryImageforAssert:[PHAsset latestAsset] targetSize:self.thumbImageview.image.size contentMode:PHImageContentModeDefault resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if (!result) {
            
            UIImage *image = [UIImage imageNamed:@"playIcon"];
            self.realImageview.image = image;
             self.videoIndictImageview.hidden = NO;
            return ;
        }
        //self.realImageview.center = self.thumbImageview.center;
        [self.realImageview setImage:result];
        if (latest.mediaType == PHAssetResourceTypeVideo) {
            self.videoIndictImageview.hidden = NO;
        }else{
            self.videoIndictImageview.hidden = YES;
        }
    }];
}


@end
