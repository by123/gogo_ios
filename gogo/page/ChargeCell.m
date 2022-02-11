//
//  ChargeCell.m
//  gogo
//
//  Created by by.huang on 2018/3/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ChargeCell.h"


@interface ChargeCell()

@property (strong, nonatomic) UIImageView *showImg;
@property (strong, nonatomic) UILabel *giftNameLabel;
@property (strong, nonatomic) UILabel *coinLabel;
@property (strong, nonatomic) UILabel *moneyLabel;

@end

@implementation ChargeCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

-(void)initView{
    _showImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 ,self.bounds.size.width,[PUtil getActualWidth:300])];
    _showImg.layer.masksToBounds = YES;
    _showImg.layer.cornerRadius = [PUtil getActualWidth:10];
    _showImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_showImg];
    
    UIView *view = [[UIView alloc]init];
    view.alpha = 0.75;
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(0, [PUtil getActualWidth:300], self.bounds.size.width, self.bounds.size.height - [PUtil getActualWidth:300]);
    [self.contentView addSubview:view];
    
    _giftNameLabel = [[UILabel alloc]init];
    _giftNameLabel.textColor = c08_text;
    _giftNameLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [view addSubview:_giftNameLabel];
    
    _coinLabel = [[UILabel alloc]init];
    _coinLabel.textColor = c03_yellow;
    _coinLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [view addSubview:_coinLabel];
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.textColor = c08_text;
    _moneyLabel.backgroundColor = c01_blue;
    _moneyLabel.layer.masksToBounds = YES;
    _moneyLabel.layer.cornerRadius = 4;
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.frame = CGRectMake(self.bounds.size.width - [PUtil getActualWidth:115], [PUtil getActualWidth:15], [PUtil getActualWidth:100], [PUtil getActualWidth:70]);
    _moneyLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    [view addSubview:_moneyLabel];
}

-(void)setData : (PayModel *)payModel{
    
    [_showImg sd_setImageWithURL:[NSURL URLWithString:payModel.gift_icon]];
    _giftNameLabel.text = [NSString stringWithFormat:@"%@ x%ld",payModel.gift_name,payModel.gift_count];
    _giftNameLabel.frame = CGRectMake([PUtil getActualWidth:15], [PUtil getActualWidth:15],_giftNameLabel.contentSize.width,_giftNameLabel.contentSize.height);
    
    _coinLabel.text = [NSString stringWithFormat:@"赠送%ld竞猜币",payModel.coin_count];
    _coinLabel.frame = CGRectMake([PUtil getActualWidth:15], [PUtil getActualWidth:50],_coinLabel.contentSize.width,_coinLabel.contentSize.height);

    _moneyLabel.text = [NSString stringWithFormat:@"¥ %ld",payModel.fee/100];

}

+(NSString *)identify{
    return @"ChargeCell";
}

@end
