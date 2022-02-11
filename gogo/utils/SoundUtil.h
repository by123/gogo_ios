//
//  SoundUtil.h
//  签到动画
//
//  Created by 蒙奇D路飞 on 16/9/18.
//  Copyright © 2016年 com.smh.pcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@interface SoundUtil : NSObject

+(SystemSoundID)creatSoundIDWithSoundName:(NSString *)soundName;
+(void)playSoundWithSoundID:(SystemSoundID)soundID;
+(void)stopSoundWithSoundID:(SystemSoundID)soundID;
@end
