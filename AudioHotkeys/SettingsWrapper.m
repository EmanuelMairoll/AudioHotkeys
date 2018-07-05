//
//  SettingsWrapper.m
//  AudioHotkeys
//
//  Created by Emanuel Mairoll on 04.07.18.
//  Copyright © 2018 Emanuel Mairoll. All rights reserved.
//

#import "SettingsWrapper.h"
#import "LibraryHeader.h"

@implementation SettingsWrapper

AppleSound_AudioDeviceMgr* mgr;

+ (void) initialize {
    if (self == [SettingsWrapper class]) {
        NSString* fullPath = @"/System/Library/PreferencePanes/Sound.prefPane";
        NSBundle* bundle = [NSBundle bundleWithPath:fullPath];
        [bundle load];
        
        mgr = [[bundle classNamed:@"AppleSound_AudioDeviceMgr"] sharedAudioDeviceManager];
    }
}

+ (BOOL)isMonoAudio{
    return UAPlayStereoAsMonoIsEnabled() == 0 ? false : true;
}
+ (void)setMonoAudio:(BOOL)value{
    UAPlayStereoAsMonoSetEnabled(value ? 1 : 0);
}

+ (float)getLRBalance{
    AppleSound_AudioDevice* device = [mgr defaultOutputDevice];
    return [device balance];
}

+ (void)setLRBalance:(float)value{
    AppleSound_AudioDevice* device = [mgr defaultOutputDevice];
    [device setBalance:value];
}

+ (void)addHardwareListener:(SEL)handler withTarget:(id)target{
    [[NSNotificationCenter defaultCenter] addObserver:target selector:handler name:@"com.apple.sound.hardwareChanged" object:mgr];
    [[NSNotificationCenter defaultCenter] addObserver:target selector:handler name:@"com.apple.sound.outputDeviceChanged" object:mgr];
}

+ (void)addMonoListener:(SEL)handler withTarget:(id)target{
    [[NSDistributedNotificationCenter defaultCenter] addObserver:target selector:handler name:@"UniversalAccessDomainSoundSettingsDidChangeNotification" object:0x0 suspensionBehavior:0x4];
}

+ (void)addBalanceListener:(SEL)handler withTarget:(id)target{
    [[NSNotificationCenter defaultCenter] addObserver:target selector:handler name:@"com.apple.sound.outputBalanceChanged" object:mgr];
}

+ (NSString*)currentDeviceName{
    return [[mgr defaultOutputDevice] name];
}

@end


