#  总结
## 在 iOS 系统中，开发者可以通过 AVAudioSession 相关的 API 来处理 App 内部、App 之间以及设备级别的音频行为。
比如：你的 App 的声音是否应该受到手机的静音键的控制；当你的 App 的音频开始播放时，其他音乐播放器的声音是否应停止；用户拔掉耳麦、电话来了、带声音播放的系统通知响起等情况下，你的 App 的声音应该怎么处理等等。


```
@interface AVAudioSession : NSObject {
@private
    void *_impl;
}
```

```
+ (AVAudioSession *)sharedInstance API_AVAILABLE(ios(3.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);
```
### 提供了一个单例 session

```
/// Get the list of categories available on the device.  Certain categories may be unavailable on
/// particular devices.  For example, AVAudioSessionCategoryRecord will not be available on devices
/// that have no support for audio input.
@property (readonly, nonatomic) NSArray<AVAudioSessionCategory> *availableCategories API_AVAILABLE(ios(9.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);
```
### 获取当前设备支持的功能
```
/// Set session category.
- (BOOL)setCategory:(AVAudioSessionCategory)category error:(NSError **)outError API_AVAILABLE(ios(3.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);
```
### 为当前 session 指定需要提供的功能

```
/// Set session category with options.
- (BOOL)setCategory:(AVAudioSessionCategory)category
        withOptions:(AVAudioSessionCategoryOptions)options
              error:(NSError **)outError
    API_AVAILABLE(ios(6.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);
/// Set session category and mode with options.
- (BOOL)setCategory:(AVAudioSessionCategory)category
               mode:(AVAudioSessionMode)mode
            options:(AVAudioSessionCategoryOptions)options
              error:(NSError **)outError
    API_AVAILABLE(ios(10.0), watchos(3.0), tvos(10.0)) API_UNAVAILABLE(macos);
```
### 


```
/*! Use this category for background sounds such as rain, car engine noise, etc.
 Mixes with other music. */
OS_EXPORT AVAudioSessionCategory const AVAudioSessionCategoryAmbient            API_AVAILABLE(ios(3.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);

/*! Use this category for background sounds.  Other music will stop playing. */
OS_EXPORT AVAudioSessionCategory const AVAudioSessionCategorySoloAmbient        API_AVAILABLE(ios(3.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);

/*! Use this category for music tracks.*/
OS_EXPORT AVAudioSessionCategory const AVAudioSessionCategoryPlayback            API_AVAILABLE(ios(3.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);

/*! Use this category when recording audio. */
OS_EXPORT AVAudioSessionCategory const AVAudioSessionCategoryRecord                API_AVAILABLE(ios(3.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);

/*! Use this category when recording and playing back audio. */
OS_EXPORT AVAudioSessionCategory const AVAudioSessionCategoryPlayAndRecord        API_AVAILABLE(ios(3.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);

/*! Use this category when using a hardware codec or signal processor while
 not playing or recording audio. */
OS_EXPORT AVAudioSessionCategory const AVAudioSessionCategoryAudioProcessing API_DEPRECATED("No longer supported", ios(3.0, 10.0)) API_UNAVAILABLE(watchos, tvos) API_UNAVAILABLE(macos);
```
### AVAudioSessionCategory
AVAudioSessionCategoryAmbient : 使用这个category的应用会随着静音键和屏幕关闭而静音. 并且不会中止其它应用播放声音.  可以和其它自带应用如iPod,safari等同时播放声音. 注意: 该Category无法在后台播放声音, 所以开启应用打断音乐程序播放音乐应该使用这个Category.
AVAudioSessionCategorySoloAmbient :  类似于AVAudioSessionCategoryAmbient 不同之处在于它会中止其它应用播放声音. 这个category为默认category. 该Category无法在后台播放声音
AVAudioSessionCategoryPlayback : 使用这个category的应用不会随着静音键和屏幕关闭而静音. 可在后台播放声音
AVAudioSessionCategoryRecord : 录音时使用该功能
AVAudioSessionCategoryPlayAndRecord : 可以录音可以再后台播放
AVAudioSessionCategoryAudioProcessing : 不要使用!


Category                                                         是否会被静音键或锁屏键静音    是否打断不支持混音播放的应用    是否允许音频输入/输出
AVAudioSessionCategoryAmbient                 Yes                                             NO                                                 只输出
AVAudioSessionCategoryAudioProcessing   YES                                                                                                  无输入和输出
AVAudioSessionCategoryMultiRoute             NO                                             YES                                                支持输入和输出
AVAudioSessionCategoryPlayAndRecord      NO                                             默认 YES，可重写开关置为 NO   支持输入和输出
AVAudioSessionCategoryPlayback                NO                                             默认 YES，可重写开关置为 NO    只输出
AVAudioSessionCategoryRecord                    NO（锁屏时依然保持录制）    YES                                                只输入
AVAudioSessionCategorySoloAmbient          YES                                           YES                                                只输出          





```
/*!
    @enum        AVAudioSessionCategoryOptions
    @brief        Customization of various aspects of a category's behavior. Use with
                setCategory:mode:options:error:.

    Applications must be prepared for changing category options to fail as behavior may change
    in future releases. If an application changes its category, it should reassert the options,
    since they are not sticky across category changes. Introduced in iOS 6.0 / watchOS 2.0 /
    tvOS 9.0.

    @var AVAudioSessionCategoryOptionMixWithOthers
        Controls whether other active audio apps will be interrupted or mixed with when your app's
        audio session goes active. Details depend on the category.

        AVAudioSessionCategoryPlayAndRecord or AVAudioSessionCategoryMultiRoute:
             MixWithOthers defaults to false, but can be set to true, allowing other applications to
             play in the background while your app has both audio input and output enabled.

        AVAudioSessionCategoryPlayback:
             MixWithOthers defaults to false, but can be set to true, allowing other applications to
             play in the background. Your app will still be able to play regardless of the setting
             of the ringer switch.
 
        Other categories:
             MixWithOthers defaults to false and cannot be changed.

        MixWithOthers is only valid with AVAudioSessionCategoryPlayAndRecord,
        AVAudioSessionCategoryPlayback, and AVAudioSessionCategoryMultiRoute.

    @var AVAudioSessionCategoryOptionDuckOthers
        Controls whether or not other active audio apps will be ducked when when your app's audio
        session goes active. An example of this is a workout app, which provides periodic updates to
        the user. It reduces the volume of any music currently being played while it provides its
        status.

        Defaults to off. Note that the other audio will be ducked for as long as the current session
        is active. You will need to deactivate your audio session when you want to restore full
        volume playback (un-duck) other sessions.

        Setting this option will also make your session mixable with others
        (AVAudioSessionCategoryOptionMixWithOthers will be set).

        DuckOthers is only valid with AVAudioSessionCategoryAmbient,
        AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and
        AVAudioSessionCategoryMultiRoute.

    @var AVAudioSessionCategoryOptionAllowBluetooth
        Allows an application to change the default behavior of some audio session categories with
        regard to whether Bluetooth Hands-Free Profile (HFP) devices are available for routing. The
        exact behavior depends on the category.

        AVAudioSessionCategoryPlayAndRecord:
            AllowBluetooth defaults to false, but can be set to true, allowing a paired bluetooth
            HFP device to appear as an available route for input, while playing through the
            category-appropriate output.

        AVAudioSessionCategoryRecord:
            AllowBluetooth defaults to false, but can be set to true, allowing a paired Bluetooth
            HFP device to appear as an available route for input

        Other categories:
            AllowBluetooth defaults to false and cannot be changed. Enabling Bluetooth for input in
            these categories is not allowed.

    @var AVAudioSessionCategoryOptionDefaultToSpeaker
        Allows an application to change the default behavior of some audio session categories with
        regard to the audio route. The exact behavior depends on the category.

        AVAudioSessionCategoryPlayAndRecord:
            DefaultToSpeaker will default to false, but can be set to true, routing to Speaker
            (instead of Receiver) when no other audio route is connected.

        Other categories:
            DefaultToSpeaker is always false and cannot be changed.

    @var AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers
        When a session with InterruptSpokenAudioAndMixWithOthers set goes active, then if there is
        another playing app whose session mode is AVAudioSessionModeSpokenAudio (for podcast
        playback in the background, for example), then the spoken-audio session will be
        interrupted. A good use of this is for a navigation app that provides prompts to its user:
        it pauses any spoken audio currently being played while it plays the prompt.

        InterruptSpokenAudioAndMixWithOthers defaults to off. Note that the other app's audio will
        be paused for as long as the current session is active. You will need to deactivate your
        audio session to allow the other session to resume playback. Setting this option will also
        make your category mixable with others (AVAudioSessionCategoryOptionMixWithOthers will be
        set). If you want other non-spoken audio apps to duck their audio when your app's session
        goes active, also set AVAudioSessionCategoryOptionDuckOthers.

        Only valid with AVAudioSessionCategoryPlayAndRecord, AVAudioSessionCategoryPlayback, and
        AVAudioSessionCategoryMultiRoute. Introduced in iOS 9.0 / watchOS 2.0 / tvOS 9.0.
        
    @var AVAudioSessionCategoryOptionAllowBluetoothA2DP
        Allows an application to change the default behavior of some audio session categories with
        regard to whether Bluetooth Advanced Audio Distribution Profile (A2DP) devices are
        available for routing. The exact behavior depends on the category.

        AVAudioSessionCategoryPlayAndRecord:
            AllowBluetoothA2DP defaults to false, but can be set to true, allowing a paired
            Bluetooth A2DP device to appear as an available route for output, while recording
            through the category-appropriate input.

        AVAudioSessionCategoryMultiRoute and AVAudioSessionCategoryRecord:
            AllowBluetoothA2DP is false, and cannot be set to true.

        Other categories:
            AllowBluetoothA2DP is always implicitly true and cannot be changed; Bluetooth A2DP ports
            are always supported in output-only categories.

        Setting both AVAudioSessionCategoryOptionAllowBluetooth and
        AVAudioSessionCategoryOptionAllowBluetoothA2DP is allowed. In cases where a single
        Bluetooth device supports both HFP and A2DP, the HFP ports will be given a higher priority
        for routing. For HFP and A2DP ports on separate hardware devices, the last-in wins rule
        applies.

        Introduced in iOS 10.0 / watchOS 3.0 / tvOS 10.0.

    @var AVAudioSessionCategoryOptionAllowAirPlay
        Allows an application to change the default behavior of some audio session categories with
        with regard to showing AirPlay devices as available routes. This option applies to
        various categories in the same way as AVAudioSessionCategoryOptionAllowBluetoothA2DP;
        see above for details.

        Only valid with AVAudioSessionCategoryPlayAndRecord. Introduced in iOS 10.0 / tvOS 10.0.
*/
typedef NS_OPTIONS(NSUInteger, AVAudioSessionCategoryOptions) {
    AVAudioSessionCategoryOptionMixWithOthers            = 0x1,
    AVAudioSessionCategoryOptionDuckOthers               = 0x2,
    AVAudioSessionCategoryOptionAllowBluetooth API_UNAVAILABLE(tvos, watchos, macos) = 0x4,
    AVAudioSessionCategoryOptionDefaultToSpeaker API_UNAVAILABLE(tvos, watchos, macos) = 0x8,
    AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers API_AVAILABLE(ios(9.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos) = 0x11,
    AVAudioSessionCategoryOptionAllowBluetoothA2DP API_AVAILABLE(ios(10.0), watchos(3.0), tvos(10.0)) API_UNAVAILABLE(macos) = 0x20,
    AVAudioSessionCategoryOptionAllowAirPlay API_AVAILABLE(ios(10.0), tvos(10.0)) API_UNAVAILABLE(watchos, macos) = 0x40,
};
```
### AVAudioSessionCategoryOptions 当应用程序重新指定Category时这些选项也需要重新指定
AVAudioSessionCategoryOptionMixWithOthers : 当其他应用的音频被中断, 本应用是否应该被打断或者一混同播放,具体细节取决于你之前指定的 category
1. AVAudioSessionCategoryPlayAndRecord或AVAudioSessionCategoryMultiRoute: 当你的应用程序都启用了音频输入和输出时, MixWithOthers默认为false, 但可以设置为true, 允许其他应用程序在后台播放.
2. AVAudioSessionCategoryPlayback: MixWithOthers默认为false,  但也可以设置为true, 允许其他应用程序在后台播放. 无论铃声开关的设置如何, 你的应用程序仍然可以播放。

AVAudioSessionCategoryOptionDuckOthers : 控制当你的应用程序的音频播放时, 其他活跃的音频应用程序是否会调低音量, 这方面的一个例子是一个健身应用程序,它为用户提供定期更新. 它在提供状态的同时降低了当前正在播放的音乐的音量.

默认设置为关闭. 注意, 只要当前会话处于活动状态, 其他音频将被隐藏. 当您想恢复其他会话的全音量播放时, 您将需要停用您的音频会话.
设置此选项也将使您的会话可与其他会话混合(AVAudioSessionCategoryOptionMixWithOthers将被设置), 
DuckOthers仅对AVAudioSessionCategoryAmbient, AVAudioSessionCategoryPlayAndRecord,  AVAudioSessionCategoryPlayback，和AVAudioSessionCategoryMultiRoute有效.

AVAudioSessionCategoryOptionAllowBluetooth : 允许应用程序更改某些音频会话类别的默认行为, 以确定蓝牙免提配置文件(HFP)设备是否可用于路由. 具体的行为取决于类别.
AVAudioSessionCategoryPlayAndRecord : 默认不开启蓝牙, 但是可以启用该选项在使用外部设备播放音频时使用蓝牙设备进行录音
AVAudioSessionCategoryRecord: 类似上面
其他 category 都不允许改变该模式来使用蓝牙输入

AVAudioSessionCategoryOptionDefaultToSpeaker : 允许应用程序改变有关音频路由的一些音频会话类别的默认行为(允许使用非默认输出设备). 具体的行为取决于类别.
AVAudioSessionCategoryPlayAndRecord: DefaultToSpeaker将默认为false. 但可以设置为true, 路由到扬声器(而不是接收器)时, 没有其他音频路由被连接.  其他类别:DefaultToSpeaker总是false且不能更改. 

AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers : 当一个会话的InterruptSpokenAudioAndMixWithOthers设置激活，然后如果有另一个播放应用程序的会话模式是AVAudioSessionModeSpokenAudio(播客播放在后台，例如)，那么语音音频会话将被中断。一个很好的用法是在导航应用程序中为用户提供提示:它在播放提示时暂停当前正在播放的语音。只要当前会话处于活动状态，就会暂停。您将需要停用您的音频会话，以允许其他会话恢复回放。设置此选项也将使您的类别可与其他类别混合(AVAudioSessionCategoryOptionMixWithOthers将被设置)。如果你想让其他非语音的音频应用在你的应用会话激活时隐藏它们的音频，也设置AVAudioSessionCategoryOptionDuckOthers。

AVAudioSessionCategoryOptionAllowBluetoothA2DP : 允许一个应用程序改变一些音频会话类别的默认行为，关于蓝牙高级音频分布配置文件(A2DP)设备是否可用于路由。具体的行为取决于类别。
AVAudioSessionCategoryPlayAndRecord:允许蓝牙tha2dp默认为false，但可以设置为true，允许一个配对的蓝牙A2DP设备作为一个可用的输出路径出现，同时通过分类适当的输入进行记录。
AVAudioSessionCategoryMultiRoute和AVAudioSessionCategoryRecord: 允许一个应用程序改变一些音频会话类别的默认行为，关于蓝牙高级音频分布配置文件(A2DP)设备是否可用于路由。具体的行为取决于类别。
AVAudioSessionCategoryPlayAndRecord:允许蓝牙A2DP默认为false，但可以设置为true，允许一个配对的蓝牙A2DP设备作为可用的输出路径出现，同时通过适合分类的输入进行记录。
AVAudioSessionCategoryMultiRoute和AVAudioSessionCategoryRecord: AllowBluetooth A2DP为假，不能设置为真。
其他类:
允许蓝牙A2DP总是隐式true并且不能被改变;
蓝牙A2DP端口总是只支持输出类别。
允许设置AVAudioSessionCategoryOptionAllowBluetooth和AVAudioSessionCategoryOptionAllowBluetooth A2DP。在单一蓝牙设备同时支持HFP和A2DP的情况下，HFP端口将被赋予更高的路由优先级。对于HFP和A2DP端口在单独的硬件设备上，最后打开的应用获得使用权。

AVAudioSessionCategoryOptionAllowAirPlay : 允许一个应用程序改变一些音频会话类别的默认行为，以显示作为可用路由的AirPlay设备。这个选项适用于各种类别在相同的方式avaudiosessioncategoryoptionallow蓝牙tha2dp;
仅对AVAudioSessionCategoryPlayAndRecord有效。在iOS 10.0 / tvOS 10.0中引入。
