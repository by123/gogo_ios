//
//  ByLog.m
//  gogo
//
//  Created by by.huang on 2018/3/22.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ByLog.h"

@implementation ByLog

+(void)print:(NSString *)content{
    if([content isKindOfClass:[NSString class]]){
        NSLog(@"gogo print:%@",content);
        return;
    }
    NSLog(@"gogo print:输出格式有误");
}
    
+(void)print:(NSString *)describe content:(NSString *)content{
    [self print:[NSString stringWithFormat:@"%@->%@",describe,content]];
}
    
+(void)printInt:(int)content{
    NSLog(@"gogo print:%d",content);
}
    
+(void)printLong:(long)content{
    NSLog(@"gogo print:%ld",content);
}

@end
