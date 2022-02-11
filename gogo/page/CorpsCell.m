//
//  CorpsCell.m
//  gogo
//
//  Created by by.huang on 2017/10/25.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "CorpsCell.h"

@interface CorpsCell()

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *mTitleLabel;

@property (strong, nonatomic) UIImageView *arrowView;

@property (strong, nonatomic) UIView *lineView;


@end

@implementation CorpsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.contentView.backgroundColor = c06_backgroud;
    
    _iconView = [[UIImageView alloc]init];
    _iconView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:26], [PUtil getActualWidth:58], [PUtil getActualWidth:58]);
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconView];
    
    _mTitleLabel = [[UILabel alloc]init];
    _mTitleLabel.frame = CGRectMake([PUtil getActualWidth:108], [PUtil getActualHeight:31], ScreenWidth, [PUtil getActualHeight:48]);
    _mTitleLabel.textColor = c09_tips;
    _mTitleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    [self.contentView addSubview:_mTitleLabel];
    
    _arrowView = [[UIImageView alloc]init];
    _arrowView.frame = CGRectMake([PUtil getActualWidth:688], [PUtil getActualHeight:39], [PUtil getActualHeight:32], [PUtil getActualHeight:32]);
    _arrowView.image = [UIImage imageNamed:@"ic_go_12"];
    [self.contentView addSubview:_arrowView];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c05_divider;
    _lineView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:110]-1, ScreenWidth - [PUtil getActualWidth:30], 1);
    [self.contentView addSubview:_lineView];
    
}


-(void)setData : (CorpsModel *)model{
    _mTitleLabel.text = model.team_name;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    
}

+(NSString *)identify{
    return @"CorpsCell";
}

@end
