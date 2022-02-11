//
//  SignView2.m
//  gogo
//
//  Created by by.huang on 2018/2/12.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "SignView2.h"

#define SignViewW [PUtil getActualWidth:690]
#define SignViewH [PUtil getActualHeight:763]


@implementation SignView2{
    long mCoins;
    int mDays;
}

-(instancetype)initWithCoin:(long)coins withDay:(int)days{
    if(self == [super init]){
        mCoins = coins;
        mDays = days;
        [self initView];
    }
    return self;
}

-(void)initView{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.75f];

    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake((ScreenWidth - SignViewW)/2, (ScreenHeight - SignViewH)/2, SignViewW, SignViewH);
    contentView.backgroundColor = c06_backgroud;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = [PUtil getActualHeight:44];
    [self addSubview:contentView];
    
    UILabel *signLabel = [[UILabel alloc]init];
    signLabel.text = @"签到成功";
    signLabel.textColor = c08_text;
    signLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:60]];
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.frame = CGRectMake(0, [PUtil getActualHeight:40], SignViewW, [PUtil getActualHeight:84]);
    [contentView addSubview:signLabel];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"ic_close_12"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(SignViewW -[PUtil getActualWidth:80], [PUtil getActualHeight:40], [PUtil getActualWidth:40], [PUtil getActualWidth:40]);
    [closeBtn addTarget:self action:@selector(OnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    
    UIImageView *coinImageView = [[UIImageView alloc]init];
    coinImageView.image = [UIImage imageNamed:@"etc_coin"];
    coinImageView.frame = CGRectMake([PUtil getActualWidth:242], [PUtil getActualHeight:184], [PUtil getActualWidth:204], [PUtil getActualHeight:200]);
    [contentView addSubview:coinImageView];
    
    UILabel *coinLabel = [[UILabel alloc]init];
    coinLabel.text = @"竞猜币";
    coinLabel.textColor = c08_text;
    coinLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    coinLabel.textAlignment = NSTextAlignmentCenter;
    coinLabel.frame = CGRectMake([PUtil getActualHeight:248], [PUtil getActualHeight:418], coinLabel.contentSize.width, coinLabel.contentSize.height);
    [contentView addSubview:coinLabel];
    
    UILabel *coinNumLabel = [[UILabel alloc]init];
    coinNumLabel.text = [NSString stringWithFormat:@"+%ld",mCoins];
    coinNumLabel.textColor = [ColorUtil colorWithHexString:@"#F1B74C"];
    coinNumLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    coinNumLabel.textAlignment = NSTextAlignmentCenter;
    coinNumLabel.frame = CGRectMake([PUtil getActualHeight:268] + coinLabel.contentSize.width, [PUtil getActualHeight:418], coinNumLabel.contentSize.width, coinNumLabel.contentSize.height);
    [contentView addSubview:coinNumLabel];
    
    UIButton *guessBtn = [[UIButton alloc]init];
    [guessBtn setTitle:@"去竞猜" forState:UIControlStateNormal];
    [guessBtn setTitleColor:c08_text forState:UIControlStateNormal];
    guessBtn.layer.masksToBounds = YES;
    guessBtn.layer.cornerRadius = [PUtil getActualHeight:50];
    guessBtn.frame = CGRectMake((SignViewW -[PUtil getActualWidth:440])/2, [PUtil getActualHeight:560], [PUtil getActualWidth:440], [PUtil getActualHeight:100]);
    [guessBtn addTarget:self action:@selector(OnGuessClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:guessBtn];
    
    [ColorUtil setGradientColor:guessBtn startColor:c01_blue endColor:c02_red director:Left];

    
    UILabel *dayLabel = [[UILabel alloc]init];
    dayLabel.text = [NSString stringWithFormat:@"已成功签到 %d 天",mDays];
    dayLabel.textColor = c09_tips;
    dayLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.frame = CGRectMake(0, [PUtil getActualHeight:690], SignViewW, dayLabel.contentSize.height);
    [contentView addSubview:dayLabel];
}

-(void)OnCloseClicked{
    [self removeFromSuperview];
}

-(void)OnGuessClicked{
    if(_delegate){
        [_delegate OnGuessClicked];
    }
    [self removeFromSuperview];
}

@end
