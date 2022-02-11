
//
//  PUtil.m
//  gogo
//
//  Created by by.huang on 2017/10/21.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "PUtil.h"

@implementation PUtil

+(int)getActualWidth : (int)width{
    return ScreenWidth * width / 750;
}

+(int)getActualHeight : (int)height{
    return ScreenHeight * height / 1334;
}

@end
