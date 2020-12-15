//
//  AppDelegate.m
//  try_play_with_audio_unit
//
//  Created by hanyang on 2020/12/14.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()
@end


@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    
//    NSExtensionContext *myExtensionContext = UIApplication sharedApplication.extensionContext;
    return YES;
}





@end
