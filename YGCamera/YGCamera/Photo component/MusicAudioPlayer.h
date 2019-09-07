//
//  Music_AudioPlayer.h
//  YGCamera
//
//  Created by chen hua on 2019/5/4.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>



@interface MusicAudioPlayer : NSObject

@property (nonatomic,strong)AVAudioPlayer *audioPlay;

- (void)playWithMusic:(NSString *)url;




@end


