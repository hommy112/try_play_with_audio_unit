//
//  AudioUnitViewController.m
//  autest
//
//  Created by hanyang on 2020/12/15.
//

#import "AudioUnitViewController.h"
#import "autestAudioUnit.h"

@interface AudioUnitViewController ()

@end

@implementation AudioUnitViewController {
    AUAudioUnit *audioUnit;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (!audioUnit) {
        return;
    }
    
    // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
}

- (AUAudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription)desc error:(NSError **)error {
    audioUnit = [[autestAudioUnit alloc] initWithComponentDescription:desc error:error];
 
    // Check if the UI has been loaded
    if(self.isViewLoaded) {
        [self connectUIToAudioUnit];
    }
 
    return audioUnit;
}

- (void)connectUIToAudioUnit {
    // Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the Audio Unit
}





//- (AUAudioUnit *)createAudioUnitWithComponentDescription:(AudioComponentDescription)desc error:(NSError **)error {
//    audioUnit = [[autestAudioUnit alloc] initWithComponentDescription:desc error:error];
//    
//    return audioUnit;
//}

@end
