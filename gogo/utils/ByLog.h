//
//  ByLog.h
//  gogo
//
//  Created by by.huang on 2018/3/22.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByLog : NSObject

+(void)print:(NSString *)content;
+(void)print:(NSString *)describe content:(NSString *)content;
+(void)printInt:(int)content;
+(void)printLong:(long)content;

@end
