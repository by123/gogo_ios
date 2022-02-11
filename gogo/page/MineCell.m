//
//  MineCell.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "MineCell.h"

@interface MineCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation MineCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.contentView.backgroundColor = c07_bar;
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor =c08_text;
    _titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    if(IS_IPHONE_X){
           _titleLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:31],[PUtil getActualWidth:200], [PUtil getActualHeight:48]);
    }else{
         _titleLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:31],[PUtil getActualWidth:150], [PUtil getActualHeight:48]);
    }
    [self.contentView addSubview:_titleLabel];
    
    UIImageView *arrowView = [[UIImageView alloc]init];
    arrowView.frame = CGRectMake([PUtil getActualWidth:696], [PUtil getActualHeight:30],[PUtil getActualWidth:24], [PUtil getActualWidth:24]);
    arrowView.image = [UIImage imageNamed:@"ic_go_12"];
    [self.contentView addSubview:arrowView];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c05_divider;
    _lineView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:110]-1, ScreenWidth - [PUtil getActualWidth:30], 1);
    [self.contentView addSubview:_lineView];
    
}

-(void)setData : (NSString *)title hideline : (Boolean)hideline{
    _titleLabel.text = title;
    _lineView.hidden = hideline;
}

+(NSString *)identify{
    return @"MineCell";
}

@end
