//
//  ContentModel.m
//  gogo
//
//  Created by by.huang on 2017/10/25.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "TeamModel.h"

@implementation TeamModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"introduce": @"description"};
}

@end
