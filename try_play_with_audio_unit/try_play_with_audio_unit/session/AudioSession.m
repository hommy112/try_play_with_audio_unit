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
    
    printf("setCategory %d \n", result);
    // Activate the audio session
    result = [audioSession setActive:YES error:&sessionError];
    printf("setActive %d \n", result);
}
+ (void)setPlayback {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    BOOL result;
    result = [audioSession setCategory:AVAudioSessionCategoryPlayback
                           withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth
                                 error:&sessionError];
    
    printf("setCategory %d \n", result);
    // Activate the audio session
    result = [audioSession setActive:YES error:&sessionError];
    printf("setActive %d \n", result);
}
@end
