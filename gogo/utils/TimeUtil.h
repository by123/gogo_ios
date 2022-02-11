//
//  TimeUtil.h
//  gogo
//
//  Created by by.huang on 2017/11/5.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject

+(NSString *)generateAll : (NSString *)timestamp;

+(NSString *)generateData : (NSString *)timestamp;

+(NSString *)generateTime : (NSString *)timestamp;

+(NSString *)getCommentTime : (NSString *)timestamp;

@end
