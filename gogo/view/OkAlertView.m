//
//  OkAlertView.m
//  gogo
//
//  Created by by.huang on 2018/2/3.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "OkAlertView.h"

@implementation OkAlertView{
    NSString *mTitle;
    NSString *mContent;
}

-(instancetype)initWithTitle:(NSString *)title content:(NSString *)content{
    if(self == [super init]){
        mTitle = title;
        mContent = content;
        [self initView];
    }
    return self;
}

-(void)initView{
    self.frame = CGRectMake([PUtil getActualWidth:80], (ScreenHeight - [PUtil getActualHeight:320])/2, ScreenWidth - [PUtil getActualWidth:160], [PUtil getActualHeight:320]);
    self.backgroundColor = c07_bar;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [c06_backgroud CGColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = mTitle;
    titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:32]];
    titleLabel.textColor = c08_text;
    titleLabel.frame = CGRectMake(0, 0, ScreenWidth - [PUtil getActualWidth:160], [PUtil getActualHeight:100]);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = c06_backgroud;
    lineView.frame = CGRectMake(0, [PUtil getActualHeight:99], ScreenWidth - [PUtil getActualWidth:160], 1);
    [self addSubview:lineView];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = mContent;
    contentLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    contentLabel.textColor = c08_text;
    contentLabel.frame = CGRectMake(0,  [PUtil getActualHeight:100], ScreenWidth - [PUtil getActualWidth:160], [PUtil getActualHeight:100]);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLabel];
    
    UIButton *okBtn = [[UIButton alloc]init];
    okBtn.frame = CGRectMake(0, [PUtil getActualHeight:220], ScreenWidth - [PUtil getActualWidth:160], [PUtil getActualHeight:100]);
    okBtn.backgroundColor = c01_blue;
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(OnOkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitleColor:c08_text forState:UIControlStateNormal];
    [self addSubview:okBtn];
    
}

-(void)OnOkBtnClick{
    [self removeFromSuperview];
}

@end
