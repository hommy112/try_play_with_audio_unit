//
//  AudioUnitPlayer.h
//  try_play_with_audio_unit
//
//  Created by hanyang on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
NS_ASSUME_NONNULL_BEGIN

@protocol AudioUnitPlayerDataSourse <NSObject>

- (void)readDataToBuffer:(AudioBufferList *)ioData length:(UInt32)inNumberFrames;

@end


@interface AudioUnitPlayer : NSObject

@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@property (nonatomic, weak) id<AudioUnitPlayerDataSourse> dataSource;
@property (nonatomic, retain) dispatch_queue_t queue;

- (instancetype)initWithASBD:(AudioStreamBasicDescription) asbd;
- (void)play;
- (void)stop;



@end

NS_ASSUME_NONNULL_END
