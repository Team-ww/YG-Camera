//
//  InfoView.m
//  YGCamera
//
//  Created by chen hua on 2019/4/11.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "InfoView.h"
#import "Utils.h"

@implementation InfoView

// 准备弹出(初始化弹层位置)
- (void)willPopupContainer:(DSHPopupContainer *)container {
    CGRect frame = self.frame;
    frame.size = CGSizeMake(300, 250);
    frame.origin.x = (container.frame.size.width - frame.size.width) * .5;
    frame.origin.y = (container.frame.size.height - frame.size.height) * .5;
    self.frame = frame;
}



// 已弹出(做弹出动画)
- (void)didPopupContainer:(DSHPopupContainer *)container duration:(NSTimeInterval)duration{
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(1.f, 1.f);
    }];
}

// 将要移除(做移除动画)
- (void)willDismissContainer:(DSHPopupContainer *)container duration:(NSTimeInterval)duration; {
    CGRect frame = self.frame;
    frame.origin.y = container.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.f;
    }];
}


- (UIView *)copyView{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)setVideoInfoWithAsset:(PHAsset *)asset mediaSize:(float)mediaSize fps:(float)fps{
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        self.videoOrImageType_Lab.text = @"Video";
    }else{
        self.videoOrImageType_Lab.text = @"Image";
    }
    
    NSString *fileName = [asset valueForKey:@"filename"];
    self.filenameLab_right.text =  fileName;
    self.timeLab_right.text =  [Utils getForamtDateStr:asset.creationDate];
    self.widthLab_right.text = [NSString stringWithFormat:@"%lu",(unsigned long)asset.pixelWidth];
    self.heightLab_right.text = [NSString stringWithFormat:@"%lu",(unsigned long)asset.pixelHeight];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        self.formatLab_right.text = @"mp4";
    }else{
        self.formatLab_right.text =  @"jpeg";
    }
    self.fileSizeLab_right.text = [NSString stringWithFormat:@"%.2fMB",mediaSize];
}

@end
