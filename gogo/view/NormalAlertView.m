//
//  NormalAlertView.m
//  gogo
//
//  Created by by.huang on 2018/3/1.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "NormalAlertView.h"

@implementation NormalAlertView{
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
    titleLabel.backgroundColor = c05_divider;
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
    
    int width = (ScreenWidth - [PUtil getActualWidth:160])/2;
    UIButton *cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(0, [PUtil getActualHeight:220], width, [PUtil getActualHeight:100]);
    cancelBtn.backgroundColor = c05_divider;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(OnCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:c08_text forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    
    UIButton *okBtn = [[UIButton alloc]init];
    okBtn.frame = CGRectMake(width, [PUtil getActualHeight:220], width, [PUtil getActualHeight:100]);
    okBtn.backgroundColor = c01_blue;
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(OnOkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitleColor:c08_text forState:UIControlStateNormal];
    [self addSubview:okBtn];
    
}

-(void)OnCancelBtnClick{
    [self removeFromSuperview];
    [UMUtil clickEvent:EVENT_GAME_CLOSE_NOMONEY];
}

-(void)OnOkBtnClick{
    if(_delegate && [_delegate respondsToSelector:@selector(OnOkBtnClick)]){
        [_delegate OnOkBtnClick];
    }
    [self removeFromSuperview];
}
@end
