//
//  UMUtil.m
//  gogo
//
//  Created by by.huang on 2018/3/5.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "UMUtil.h"

@implementation UMUtil

+(void)clickEvent : (int)eventId{
    [MobClick event:[NSString stringWithFormat:@"%d",eventId]];
}
@end
