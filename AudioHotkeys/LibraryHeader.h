//
//  LibraryHeader.h
//  AudioHotkeys
//
//  Created by Emanuel Mairoll on 05.07.18.
//  Copyright © 2018 Emanuel Mairoll. All rights reserved.
//

@interface AppleSound_AudioDeviceMgr : NSObject
+ (id)sharedAudioDeviceManager;
- (id)defaultOutputDevice;
@end

@interface AppleSound_AudioDevice : NSObject
- (void)setBalance:(float)arg1;
- (float)balance;

- (id)name;
@end

int UAPlayStereoAsMonoIsEnabled(void);
int UAPlayStereoAsMonoIsSupported(void);
int UAPlayStereoAsMonoSetEnabled(int);
