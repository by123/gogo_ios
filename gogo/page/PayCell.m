//
//  PayCell.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "PayCell.h"



@interface PayCell()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *arrowView;

@end

@implementation PayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.contentView.backgroundColor = c07_bar;
    
    
    _iconView = [[UIImageView alloc]init];
    _iconView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:26], [PUtil getActualWidth:58], [PUtil getActualWidth:58]);
    [self.contentView addSubview:_iconView];
    
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor =c08_text;
    _titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _titleLabel.frame = CGRectMake([PUtil getActualWidth:108], [PUtil getActualHeight:31],[PUtil getActualWidth:300], [PUtil getActualHeight:48]);
    [self.contentView addSubview:_titleLabel];
    
    _arrowView = [[UIImageView alloc]init];
    _arrowView.frame = CGRectMake([PUtil getActualWidth:696], [PUtil getActualHeight:30],[PUtil getActualWidth:24], [PUtil getActualWidth:24]);
    [_arrowView setImage:[UIImage imageNamed:@"ic_select_16"]];
    [self.contentView addSubview:_arrowView];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c05_divider;
    _lineView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:110]-1, ScreenWidth - [PUtil getActualWidth:30], 1);
    [self.contentView addSubview:_lineView];
    
}

-(void)setData : (NSString *)title hideline : (Boolean)hideline image:(NSString *)image{
    _titleLabel.text = title;
    _lineView.hidden = hideline;
    [_iconView setImage:[UIImage imageNamed:image]];
}

-(void)setSelect : (Boolean)select{
    _arrowView.hidden = !select;
}

+(NSString *)identify{
    return @"PayCell";
}

@end
