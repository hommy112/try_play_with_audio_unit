//
//  autestAudioUnit.h
//  autest
//
//  Created by hanyang on 2020/12/15.
//

#import <AudioToolbox/AudioToolbox.h>
#import "autestDSPKernelAdapter.h"

// Define parameter addresses.
extern const AudioUnitParameterID myParam1;

@interface autestAudioUnit : AUAudioUnit

@property (nonatomic, readonly) autestDSPKernelAdapter *kernelAdapter;
- (void)setupAudioBuses;
- (void)setupParameterTree;
- (void)setupParameterCallbacks;
@end
