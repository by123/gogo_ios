//
//  GoodsCell.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GoodsCell.h"

@interface GoodsCell()

@property (strong, nonatomic) UIImageView *showImg;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *coinLabel;
@property (strong, nonatomic) UILabel *countLabel;

@end

@implementation GoodsCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}


-(void)initView{
    
    _showImg = [[UIImageView alloc]initWithFrame:self.bounds];
    _showImg.layer.masksToBounds = YES;
    _showImg.layer.cornerRadius = [PUtil getActualWidth:10];
    _showImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_showImg];
    
    UIView *view = [[UIView alloc]init];
    view.alpha = 0.75;
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(0, [PUtil getActualHeight:230], self.bounds.size.width, self.bounds.size.height - [PUtil getActualHeight:230]);
    [self.contentView addSubview:view];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.frame =  CGRectMake([PUtil getActualWidth:15], [PUtil getActualHeight:15], self.bounds.size.width -[PUtil getActualWidth:30] *2, [PUtil getActualHeight:30]);
    _titleLabel.textColor = c08_text;
    _titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    [view addSubview:_titleLabel];
    
    _coinLabel = [[UILabel alloc]init];
    _coinLabel.frame =  CGRectMake([PUtil getActualWidth:15], [PUtil getActualHeight:55], self.bounds.size.width -[PUtil getActualWidth:30] , [PUtil getActualHeight:30]);
    _coinLabel.textColor = c03_yellow;
    _coinLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [view addSubview:_coinLabel];

    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = c08_text;
    _countLabel.alpha = 0.5f;
    _countLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [view addSubview:_countLabel];

    
}

-(void)setData : (GoodsModel *)goodsModel{
    [_showImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.cover]];
    _titleLabel.text  = goodsModel.title;
    _coinLabel.text = [NSString stringWithFormat:@"%ld竞猜币",goodsModel.coin];
    _countLabel.text = [NSString stringWithFormat:@"剩余%ld件",goodsModel.total];
    
    _countLabel.frame =  CGRectMake(self.bounds.size.width - [PUtil getActualWidth:15] - _countLabel.contentSize.width, [PUtil getActualHeight:55], _countLabel.contentSize.width , _countLabel.contentSize.height);

}

+(NSString *)identify{
    return @"GoodsCell";
}

@end

