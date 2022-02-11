//
//  SCDIntroduceView.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "SCDIntroduceView.h"

@interface SCDIntroduceView()

@property (strong, nonatomic) UIScrollView *scrollerView;

@end
@implementation SCDIntroduceView

-(instancetype)init{
    if(self == [super init]){
        [self initView];
    }
    return self;
}

-(void)initView{
    _scrollerView = [[UIScrollView alloc]init];
    _scrollerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:168]);
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,1000);
    [self addSubview:_scrollerView];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字";
    label.textColor = c08_text;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    label.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30], [PUtil getActualWidth:690], [PUtil getActualHeight:432]);
    [_scrollerView addSubview:label];
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:478], [PUtil getActualWidth:690], [PUtil getActualHeight:276]);
    view.backgroundColor = c01_blue;
    [_scrollerView addSubview:view];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字";
    label2.textColor = c08_text;
    label2.numberOfLines = 0;
    label2.lineBreakMode = NSLineBreakByCharWrapping;
    label2.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    label2.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:764], [PUtil getActualWidth:690], [PUtil getActualHeight:432]);
    [_scrollerView addSubview:label2];
    
    
}

@end
