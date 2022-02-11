//
//  BySegmentView.m
//  gogo
//
//  Created by by.huang on 2017/9/19.
//  Copyright © 2017年 by.huang. All rights reserved.
//


#define LabelNormalColor c10_icon //未选中字体颜色
#define LabelSelectedColor c01_blue//选中字体颜色

#import "BySegmentView.h"

@implementation BySegmentView
{
    UIView *_showContentLabelView;//用于展示当前label
    
    UIScrollView *_normalBgView;//正常状态下label的背景
    UIScrollView *_selectedBgView;//选中状态label的背景
    UIView *_btnBgView;//button层的背景
    
    UIScrollView *_scrollViewMain;//展示数据的scrollView
    
    NSInteger _countItem; //item总数
    int ItemWidth;
    int TabHeight;
    UIView *_lineView;
}

- (void)initializeData{
    _animation = YES;//过度动画
}

-(instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray andShowControllerNameArray:(NSMutableArray *)showControllerArray
{
 
    TabHeight = [PUtil getActualHeight:88];
    ItemWidth = ([titleArray count] > 5) ? ScreenWidth / 5 : ScreenWidth / [titleArray count];
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeData];
        
        _countItem = [titleArray count];
        
        _normalBgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TabHeight)];
        _normalBgView.delegate = self;
        [_normalBgView setBackgroundColor:c07_bar];
        [self createLabelWith:LabelNormalColor andTitle:titleArray addToView:_normalBgView];
        [self addSubview:_normalBgView];
        
        _btnBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _normalBgView.contentSize.width, CGRectGetHeight(_normalBgView.frame))];
        [_btnBgView setBackgroundColor:[UIColor clearColor]];
        [_normalBgView addSubview:_btnBgView];

        
        for (int i = 0; i < [titleArray count]; i++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i*ItemWidth, 0, ItemWidth, TabHeight)];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:i];
            [_btnBgView addSubview:btn];
        }

        
        _showContentLabelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ItemWidth, TabHeight)];
        [_showContentLabelView setClipsToBounds:YES];
        [_normalBgView addSubview:_showContentLabelView];
        
        _selectedBgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TabHeight)];
        [_selectedBgView setUserInteractionEnabled:NO];
        [_showContentLabelView addSubview:_selectedBgView];
        [self createLabelWith:LabelSelectedColor andTitle:titleArray addToView:_selectedBgView];
        
        _scrollViewMain = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TabHeight, ScreenWidth, frame.size.height-TabHeight)];
        _scrollViewMain.showsVerticalScrollIndicator = NO;
        _scrollViewMain.showsHorizontalScrollIndicator = NO;
        [_scrollViewMain setBackgroundColor:[UIColor clearColor]];
        _scrollViewMain.contentSize = CGSizeMake(ScreenWidth * [titleArray count], CGRectGetHeight(_scrollViewMain.frame));
        _scrollViewMain.pagingEnabled = YES;
        _scrollViewMain.delegate = self;
        [_scrollViewMain setBounces:NO];
        [self addSubview:_scrollViewMain];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake((ItemWidth - [PUtil getActualWidth:120])/2, [PUtil getActualHeight:82], [PUtil getActualWidth:120], [PUtil getActualHeight:6])];
        _lineView.backgroundColor = c01_blue;
        [_showContentLabelView addSubview:_lineView];
        
        for (int i = 0; i < [showControllerArray count]; i++) {
            
            UIView * obj = [showControllerArray objectAtIndex:i];
            [obj setFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, CGRectGetHeight(_scrollViewMain.frame))];
            [_scrollViewMain addSubview:obj];
            
        }
        
    }
    
    return self;
}

- (void)createLabelWith:(UIColor *)color andTitle:(NSArray *)titleArray addToView:(UIScrollView *)view{
    
    [view setShowsVerticalScrollIndicator:NO];
    [view setShowsHorizontalScrollIndicator:NO];
    [view setBounces:NO];
    //更改scrollView的大小
    [view setContentSize:CGSizeMake(ItemWidth * [titleArray count], CGRectGetHeight(view.frame))];

    //添加label
    for (int i = 0; i < [titleArray count]; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i*ItemWidth, 0, ItemWidth, TabHeight)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:titleArray[i]];
        [label setTextColor:color];
        [view addSubview:label];
    }
    
}

- (void)btnClick:(UIButton *)sender{
    
    [_scrollViewMain setContentOffset:CGPointMake(ScreenWidth * sender.tag, 0) animated:_animation];
    [self.delegate didSelectIndex:sender.tag];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == _scrollViewMain){
        [_showContentLabelView setFrame:CGRectMake(scrollView.contentOffset.x*(ItemWidth/ScreenWidth), _showContentLabelView.frame.origin.y, _showContentLabelView.frame.size.width, _showContentLabelView.frame.size.height)];
        [_selectedBgView setContentOffset:CGPointMake(scrollView.contentOffset.x*(ItemWidth/ScreenWidth), 0)];
        [self.delegate didSelectIndex:scrollView.contentOffset.x/ScreenWidth];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView == _scrollViewMain){
        if (CGRectGetMaxX(_showContentLabelView.frame) - _normalBgView.contentOffset.x > ScreenWidth) {
            [_normalBgView setContentOffset:CGPointMake(_normalBgView.contentOffset.x + CGRectGetMaxX(_showContentLabelView.frame) - _normalBgView.contentOffset.x - ScreenWidth, 0) animated:YES];
        }else if (_normalBgView.contentOffset.x - CGRectGetMinX(_showContentLabelView.frame) > 0){
            [_normalBgView setContentOffset:CGPointMake(_normalBgView.contentOffset.x - _normalBgView.contentOffset.x + CGRectGetMinX(_showContentLabelView.frame), 0) animated:YES];
        }
    }
    
}


@end
