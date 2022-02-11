
//
//  ScheduleDetailPage.m
//  gogo
//
//  Created by by.huang on 2017/10/26.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ScheduleDetailPage.h"
#import "BarView.h"
#import "BySegmentView.h"
#import "SCDCommentView.h"
#import "SCDHistoryView.h"
#import "SCDIntroduceView.h"
#import "SCDTeamView.h"
@interface ScheduleDetailPage ()

@property (strong, nonatomic) BarView *barView;
@property (strong, nonatomic) SCDCommentView *commentView;


@end

@implementation ScheduleDetailPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    
    _barView = [[BarView alloc]initWithTitle:@"赛事详情" page:self];
    [self.view addSubview:_barView];
    
    NSMutableArray *views = [[NSMutableArray alloc]init];
    
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:278]);
    
    SCDIntroduceView *introduceView = [[SCDIntroduceView alloc]init];
    [views addObject:introduceView];
    
    SCDTeamView *teamView = [[SCDTeamView alloc]init];
    [views addObject:teamView];
    
    SCDHistoryView *historyView = [[SCDHistoryView alloc]init];
    [views addObject:historyView];
    
    _commentView = [[SCDCommentView alloc]initWithFrame:rect];
    [views addObject:_commentView];
    
    BySegmentView *segmentView = [[BySegmentView alloc]initWithFrame:CGRectMake(0, StatuBarHeight + _barView.mj_h, ScreenWidth, ScreenHeight - (StatuBarHeight + _barView.mj_h)) andTitleArray:@[@"比赛简介", @"队伍详情",@"历史交战",@"评论(251)"] andShowControllerNameArray:views];
    [self.view addSubview:segmentView];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    if(_commentView){
        [_commentView keyboardWillChangeFrame:notification];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(_commentView){
        [_commentView touchesBegan:touches withEvent:event];
    }
}



@end
