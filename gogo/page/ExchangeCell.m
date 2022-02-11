//
//  ExchangeCell.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ExchangeCell.h"
#import "TimeUtil.h"

@interface ExchangeCell()

@property (strong, nonatomic) UILabel *prizeLabel;
@property (strong, nonatomic) UILabel *coinLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statuLabel;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation ExchangeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.contentView.backgroundColor = c06_backgroud;
    
    _prizeLabel = [[UILabel alloc]init];
    _prizeLabel.textColor =c08_text;
    _prizeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
    _prizeLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30],[PUtil getActualWidth:500], [PUtil getActualHeight:42]);
    [self.contentView addSubview:_prizeLabel];
    
    _coinLabel = [[UILabel alloc]init];
    _coinLabel.textColor =c03_yellow;
    _coinLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _coinLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:72],[PUtil getActualWidth:500], [PUtil getActualHeight:33]);
    [self.contentView addSubview:_coinLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor =c08_text;
    _timeLabel.alpha = 0.5f;
    _timeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
    _timeLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:110],[PUtil getActualWidth:500], [PUtil getActualHeight:28]);
    [self.contentView addSubview:_timeLabel];
    
    _statuLabel = [[UILabel alloc]init];
    _statuLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:40]];
    _statuLabel.frame = CGRectMake([PUtil getActualWidth:600], [PUtil getActualHeight:56],[PUtil getActualWidth:150], [PUtil getActualHeight:56]);
    [self.contentView addSubview:_statuLabel];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c05_divider;
    _lineView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:168]-1, ScreenWidth - [PUtil getActualWidth:30], 1);
    [self.contentView addSubview:_lineView];
}

-(void)setData : (ExchangeModel *)model hideline : (Boolean)hideline{
    ExchangeOrderModel *orderModel = [ExchangeOrderModel mj_objectWithKeyValues:model.goods_order];
    ExchangeGoodsModel *goodsModel = [ExchangeGoodsModel mj_objectWithKeyValues:model.goods];
    _prizeLabel.text = goodsModel.title;
    _coinLabel.text = [NSString stringWithFormat:@"%ld竞猜币",goodsModel.coin];
    _timeLabel.text = [TimeUtil generateAll:orderModel.create_ts];
    if([orderModel.status isEqualToString:@"apply"]){
        _statuLabel.text = @"处理中";
        _statuLabel.textColor = c01_blue;
    }else if([orderModel.status isEqualToString:@"done"]){
        _statuLabel.text = @"已完成";
        _statuLabel.textColor = c08_text;
        _statuLabel.alpha = 0.5f;
    }
    _lineView.hidden = hideline;
}

+(NSString *)identify{
    return @"ExchangeCell";
}

@end
