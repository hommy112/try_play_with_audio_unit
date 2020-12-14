//
//  AudioSession.h
//  try_play_with_audio_unit
//
//  Created by hanyang on 2020/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioSession : NSObject
+ (void)setPlayAndRecord;
+ (void)setPlayback;
@end

NS_ASSUME_NONNULL_END
