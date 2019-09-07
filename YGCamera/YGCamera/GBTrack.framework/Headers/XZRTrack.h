//
//  track.h
//  track
//
//  Created by gxapp01 on 2019/4/23.
//  Copyright © 2019年 hoeoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>
@protocol XZRTrackControlDategate <NSObject>
-(void)didTrackControlYaw:(int8_t)yaw AndPitch:(int8_t)pitch;
-(void)lostTarget;
@end

@interface XZRTrack : NSObject
@property (nonatomic) id<XZRTrackControlDategate> delegate;
@property (assign,atomic) int timeout; //超时时间
- (instancetype)initImageSize:(CGSize)imageSize WithParentView:(UIView *)view;
-(void)startTrack;
-(void)stopTrack;
-(void)processImage:(CMSampleBufferRef)sampleBuffer;
@end
