//
//  PhotosDetailCell.m
//  YGCamera
//
//  Created by chen hua on 2019/4/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "PhotosDetailCell.h"
#import "PhotoTool.h"

@interface PhotosDetailCell ()


@end

@implementation PhotosDetailCell


- (void)setDataWithAssert:(PHAsset *)fileMode
{
    
    
    if (fileMode.mediaType == PHAssetMediaTypeImage) {
        [self.imageScrollview setMaximumZoomScale:1.5];
    }else{
        [self.imageScrollview setMaximumZoomScale:1];
    }
    [self.imageScrollview setZoomScale:1];
    if (fileMode.mediaType == PHAssetMediaTypeVideo ) self.videoTypeImageview.hidden = NO;
    else if (fileMode.mediaType == PHAssetMediaTypeImage) self.videoTypeImageview.hidden = YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _assetImageview;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    //当scrollView自身的宽度或者高度大于其contentSize的时候, 增量为:自身宽度或者高度减去contentSize宽度或者高度除以2,或者为0
    //当scrollView自身的宽度或者高度大于其contentSize的时候, 增量为:自身宽度或者高度减去contentSize宽度或者高度除以2,或者为0
    //条件运算符
    CGFloat delta_x= scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
    CGFloat delta_y= scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
    //让imageView一直居中
    //实时修改imageView的center属性 保持其居中
    _assetImageview.center=CGPointMake(scrollView.contentSize.width/2 + delta_x, scrollView.contentSize.height/2 + delta_y);
}

@end
