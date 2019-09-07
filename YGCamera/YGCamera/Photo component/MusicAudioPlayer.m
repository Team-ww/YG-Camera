//
//  Music_AudioPlayer.m
//  YGCamera
//
//  Created by chen hua on 2019/5/4.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "MusicAudioPlayer.h"

@implementation MusicAudioPlayer

- (void)playWithMusic:(NSString *)url{
    
    NSURL *soundUrl = [NSURL fileURLWithPath:url];
    self.audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
    //设置声音的大小
    self.audioPlay.volume = 0.5;//范围为（0到1）；
    //设置循环次数，如果为负数，就是无限循环
    self.audioPlay.numberOfLoops =-1;
    //设置播放进度
    self.audioPlay.currentTime = 0;
    //准备播放
    [self.audioPlay prepareToPlay];
    [self.audioPlay play];
}

@end
