//
//  CHMovieWriter.h
//  Potensic
//
//  Created by chen hua on 2019/3/28.
//  Copyright © 2019 chen hua. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CHMovieWriterDelegate <NSObject>

- (void)didWriteMovieAtURL:(NSURL *)outputURL;

@end

@interface CHMovieWriter : NSObject


- (id)initWithVideoSettings:(NSDictionary *)videoSettings audioSettings:(NSDictionary *)audioSettings dispatchQueue:(dispatch_queue_t)dispatchQueue;

- (void)startWriting;
- (void)stopWriting;

@property (nonatomic)BOOL isWriting;
@property (weak,nonatomic)id<CHMovieWriterDelegate>delegate;

@property (strong,nonatomic)CIFilter *activeFilter;

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer;




@end

NS_ASSUME_NONNULL_END
