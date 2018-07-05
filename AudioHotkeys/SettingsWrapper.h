//
//  SettingsWrapper.h
//  AudioHotkeys
//
//  Created by Emanuel Mairoll on 04.07.18.
//  Copyright © 2018 Emanuel Mairoll. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LR_BALANCE_MINVALUE 0.0F
#define LR_BALANCE_CENTERVALUE 0.5F
#define LR_BALANCE_MAXVALUE 1.0F

@interface SettingsWrapper : NSObject{
    
}

+ (BOOL)isMonoAudio;
+ (void)setMonoAudio:(BOOL)value;

+ (float)getLRBalance;
+ (void)setLRBalance:(float)value;

+ (void)addHardwareListener:(SEL)handler withTarget:(id)target;
+ (void)addMonoListener:(SEL)handler withTarget:(id)target;
+ (void)addBalanceListener:(SEL)handler withTarget:(id)target;

+ (NSString*)currentDeviceName;

@end
