//
//  TitleView.m
//  gogo
//
//  Created by by.huang on 2017/10/26.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "TitleView.h"


@interface TitleView()

@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation TitleView

-(instancetype)initWithTitle:(int)height title:(NSString *)title{
    if(self == [super init]){
        [self initView:height title:title];
    }
    return self;
}


-(void)initView:(int)height title:(NSString *)title{
    self.frame = CGRectMake(0, height, ScreenWidth, [PUtil getActualHeight:88]);
    self.backgroundColor = c07_bar;
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = c01_blue;
    leftView.frame = CGRectMake(0, [PUtil getActualHeight:27], [PUtil getActualWidth:6],[PUtil getActualHeight:34]);
    [self addSubview:leftView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = title;
    _titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _titleLabel.textColor = c08_text;
    _titleLabel.frame = CGRectMake([PUtil getActualWidth:22],[PUtil getActualHeight:20],[PUtil getActualWidth:400] , [PUtil getActualHeight:48]);
    [self addSubview:_titleLabel];
}

-(void)setTitle : (NSString *)title{
    _titleLabel.text = title;
}

@end
