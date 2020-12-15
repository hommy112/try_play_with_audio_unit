//
//  AudioUnitPlayer.m
//  try_play_with_audio_unit
//
//  Created by hanyang on 2020/12/14.
//

#import "AudioUnitPlayer.h"
#import <AVFoundation/AVFoundation.h>

static void CheckError(OSStatus error, const char *operation)
{
    if (error == noErr) return;
    char errorString[20];
    // See if it appears to be a 4-char-code
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else {
        // No, format it as an integer
        sprintf(errorString, "%d", (int)error);
        fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    }
}

static const double kSampleTime = 0.01;


@interface AudioUnitPlayer ()



@property (nonatomic, assign) AUGraph graph;
@property (nonatomic, assign) AUNode ioNode;
@property (nonatomic, assign) AudioUnit ioUnit;
@property (nonatomic, assign) AudioStreamBasicDescription asbd;
@property (nonatomic, assign) AudioComponentDescription ioDesc;


@end

@implementation AudioUnitPlayer


- (instancetype)initWithASBD:(AudioStreamBasicDescription)asbd {
    if (self = [super init]) {
        _asbd = asbd;
        _queue = dispatch_queue_create("audioPlayer", DISPATCH_QUEUE_SERIAL);
        [self setupASBD];
        [self getAudioUnits];
        [self setupAudioUnits];
    }
    return self;
}


- (void)setupASBD {
    _ioDesc.componentType = kAudioUnitType_Output;
    _ioDesc.componentSubType = kAudioUnitSubType_RemoteIO;
    _ioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    _ioDesc.componentFlags = 0;
    _ioDesc.componentFlagsMask = 0;
}

- (void)getAudioUnits {
    OSStatus status = NewAUGraph(&_graph);
    CheckError(status, "create graph");
    status = AUGraphAddNode(_graph, &_ioDesc, &_ioNode);
    CheckError(status, "create ioNote");
    
    status = AUGraphOpen(_graph);
    CheckError(status, "open graph");
    
    status = AUGraphNodeInfo(_graph, _ioNode, NULL, &_ioUnit);
    CheckError(status, "get ioNode reference");
}


- (void)setupAudioUnits {
    OSStatus status;
    status = AudioUnitSetProperty(_ioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  0,
                                  &_asbd,
                                  sizeof(_asbd));
    CheckError(status, "set ioUnit StreamFormat");
    
    NSTimeInterval bufferDuration = kSampleTime;
    NSError *error;
    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:bufferDuration error:&error];
    
    AURenderCallbackStruct rcbs;
    rcbs.inputProc = &InputRenderCallback;
    rcbs.inputProcRefCon = (__bridge void *_Nullable)(self);
    status =  AudioUnitSetProperty(_ioUnit,
                                   kAudioUnitProperty_SetRenderCallback,
                                   kAudioUnitScope_Input,
                                   0,
                                   &rcbs,
                                   sizeof(rcbs));
    CheckError(status, "set render callback");
}


- (void)play {
    dispatch_async(_queue, ^{
        OSStatus status;
        status = AUGraphInitialize(self.graph);
        CheckError(status, "AUGraphInitialize");
        status = AUGraphStart(self.graph);
        CheckError(status, "AUGraphStart");
        if (status) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.playing = YES;
            });
        }
        
    });
}
- (void)stop {
    dispatch_async(_queue, ^{
        OSStatus status;
        status = AUGraphStop(self.graph);
        CheckError(status, "AUGraphStop");
        status = AUGraphUninitialize(self.graph);
        CheckError(status, "AUGraphUninitialize");
        
        if (status) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.playing = YES;
            });
        }
    });
}
static OSStatus InputRenderCallback(void *inRefCon,
                                    AudioUnitRenderActionFlags *ioActionFlags,
                                    const AudioTimeStamp *inTimeStamp,
                                    UInt32 inBusNumber,
                                    UInt32 inNumberFrames,
                                    AudioBufferList *ioData) {
    AudioUnitPlayer *player = (__bridge AudioUnitPlayer *)inRefCon;

    [player.dataSource readDataToBuffer:ioData length:inNumberFrames];

    return noErr;
}

- (void)dealloc {
    DisposeAUGraph(_graph);
}

@end
