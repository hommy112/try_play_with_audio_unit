//
//  ViewController.m
//  try_play_with_audio_unit
//
//  Created by hanyang on 2020/12/14.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioUnitPlayer.h"
#import "AudioSession.h"
@interface ViewController ()<AudioUnitPlayerDataSourse>

@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic) AudioStreamBasicDescription inputFormat;
@property (nonatomic) AudioStreamBasicDescription outputFormat;
@property (nonatomic) ExtAudioFileRef audioFile;
@property (nonatomic, assign) int frames;
@property (nonatomic, strong) AudioUnitPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *button;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    [AudioSession setPlayback];
    _queue = dispatch_queue_create("zf.audioGenarator", DISPATCH_QUEUE_SERIAL);
    
    _outputFormat.mSampleRate = 16000;
    _outputFormat.mFormatID = kAudioFormatLinearPCM;
    _outputFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    _outputFormat.mBytesPerPacket = 2;
    _outputFormat.mFramesPerPacket = 1;
    _outputFormat.mBytesPerFrame = 2;
    _outputFormat.mChannelsPerFrame = 1;
    _outputFormat.mBitsPerChannel = 16;
    
    _frames = 0;
    [self loadFile];
    
    _audioPlayer = [[AudioUnitPlayer alloc] initWithASBD:_outputFormat];
    _audioPlayer.dataSource = self;
    
    
}

- (void)dealloc {
    ExtAudioFileDispose(_audioFile);
}

- (IBAction)onClick:(UIButton *)sender {
    if (!self.audioPlayer.playing) {
        [self.audioPlayer play];
        self.button.titleLabel.text = @"暂停";
    } else {
        self.button.titleLabel.text = @"播放";
        [self.audioPlayer stop];
    }
}



-(void)loadFile {
    NSString *sourceA = [[NSBundle mainBundle] pathForResource:@"DrumsMonoSTP" ofType:@"aif"];
    CFURLRef cfurl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)sourceA, kCFURLPOSIXPathStyle, false);
    
    // 打开文件
    OSStatus result = ExtAudioFileOpenURL(cfurl, &_audioFile);
    printf("ExtAudioFileOpenURL result %ld \n", (long)result);
    
    // 读取文件格式
    AudioStreamBasicDescription fileFormat;
    UInt32 propSize = sizeof(fileFormat);
    result = ExtAudioFileGetProperty(_audioFile, kExtAudioFileProperty_FileDataFormat, &propSize, &fileFormat);
    printf("get absd: %u \n", result);
    
    // 读取音频帧数
    UInt64 numFrames = 0;
    propSize = sizeof(numFrames);
    result = ExtAudioFileGetProperty(_audioFile, kExtAudioFileProperty_FileLengthFrames, &propSize, &numFrames);
    printf("get numFrames: %llu \n", numFrames);
    
    // 设置音频数据格式
    propSize = sizeof(_outputFormat);
    result = ExtAudioFileSetProperty(_audioFile, kExtAudioFileProperty_ClientDataFormat, propSize, &_outputFormat);
    printf("set absd: %u \n", result);
    
    // 计算格式转换后帧数
    double rateRatio = _outputFormat.mSampleRate / fileFormat.mSampleRate;
    _frames = (numFrames * rateRatio);
    printf("calculate numFrames: %llu \n", numFrames);
}
- (void)readDataToBuffer:(AudioBufferList *)ioData length:(UInt32)inNumberFrames {
    ExtAudioFileRead(self.audioFile, &inNumberFrames, ioData);
}



@end
