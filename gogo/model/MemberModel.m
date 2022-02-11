//
//  MemberModel.m
//  gogo
//
//  Created by by.huang on 2017/10/27.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "MemberModel.h"

@implementation MemberModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"introduce": @"description"};
}
@end
