
//
//  ItemView.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ItemView.h"

@interface ItemView()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation ItemView

-(instancetype)initWithItemView : (NSString *)title{
    if(self == [super init]){
        [self initView:title];
    }
    return self;
}

-(void)initView : (NSString *)title{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, [PUtil getActualHeight:80]);
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = title;
    _titleLabel.textColor = c08_text;
    _titleLabel.alpha = 0.5;
    _titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _titleLabel.frame = CGRectMake([PUtil getActualWidth:30], 0, [PUtil getActualWidth:100], self.frame.size.height);
    [self addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textColor = c08_text;
    _contentLabel.alpha = 0.5;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _contentLabel.frame = CGRectMake([PUtil getActualWidth:130], 0, ScreenWidth - [PUtil getActualWidth:160], self.frame.size.height);
    [self addSubview:_contentLabel];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c05_divider;
    _lineView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:80]-1, ScreenWidth - [PUtil getActualWidth:30], 1);
    [self addSubview:_lineView];
}

-(void)setContent : (NSString *)content{
    _contentLabel.text = content;
}

-(void)setHideLine : (Boolean)hideLine{
    _lineView.hidden = hideLine;
}


@end
