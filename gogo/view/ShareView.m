//
//  ShareView.m
//  gogo
//
//  Created by by.huang on 2018/2/1.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

-(instancetype)init{
    if(self == [super init]){
        [self initView];
    }
    return self;
}

-(void)initView{
    int height = [PUtil getActualHeight:300];
    self.frame = CGRectMake(0, ScreenHeight - height, ScreenWidth, height);
    self.backgroundColor = c07_bar;
    
}

-(void)show{
    
}
@end
