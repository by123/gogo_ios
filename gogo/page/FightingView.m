//
//  FightingView.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "FightingView.h"

@interface FightingView()

@end

@implementation FightingView

-(instancetype)init{
    if(self == [super init]){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = c06_backgroud;
    UILabel *tipsLabel  = [[UILabel alloc]init];
    tipsLabel.text = @"暂无赛况";
    tipsLabel.textColor = c08_text;
    tipsLabel.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - [PUtil getActualHeight:539]);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
    [self addSubview:tipsLabel];
}


@end
