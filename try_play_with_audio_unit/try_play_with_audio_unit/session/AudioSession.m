//
//  AudioSession.m
//  try_play_with_audio_unit
//
//  Created by hanyang on 2020/12/14.
//

#import "AudioSession.h"
#import <AVFoundation/AVFoundation.h>
@implementation AudioSession
+ (void)setPlayAndRecord {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    BOOL result;
    result = [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                           withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker |
              AVAudioSessionCategoryOptionAllowBluetooth |
              AVAudioSessionCategoryOptionMixWithOthers
                                 error:&sessionError];

    if(![audioSession setActive:YES error:&sessionError]) {
        NSLog(@"%ld-----%@",sessionError.code, sessionError.domain);
    }
}
+ (void)setPlayback {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    
    if (![audioSession setCategory:AVAudioSessionCategoryPlayback
                       withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker |
          AVAudioSessionCategoryOptionMixWithOthers |
          AVAudioSessionCategoryOptionAllowBluetooth
                             error:&sessionError]) {
        NSLog(@"%ld-----%@",sessionError.code, sessionError.domain);
    }
    
    if(![audioSession setActive:YES error:&sessionError]) {
        NSLog(@"%ld-----%@",sessionError.code, sessionError.domain);
    }
}
@end
