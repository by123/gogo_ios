//
//  TouchScrollView.m
//  gogo
//
//  Created by by.huang on 2017/10/26.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "TouchScrollView.h"



@implementation TouchScrollView{
    UIView *parentView;
}

-(instancetype)initWithParentView : (UIView *)view{
    if(self == [super init]){
        parentView = view;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [parentView touchesBegan:touches withEvent:event];
}

@end
