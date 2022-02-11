//
//  GoodDetailModel.m
//  gogo
//
//  Created by by.huang on 2017/11/9.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GoodDetailModel.h"

@implementation GoodDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"introduce": @"description"};
}
@end
