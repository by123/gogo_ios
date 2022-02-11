//
//  GamePage.m
//  gogo
//
//  Created by by.huang on 2017/10/22.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GamePage.h"
#import "BySegmentView.h"
#import "ScheduleView.h"
#import "CorpsView.h"
#import "ScheduleView.h"
#import "NewsCell.h"
#import "GameCell.h"
#import "ScheduleContentCell.h"
#import "ScheduleModel.h"
#import "RespondModel.h"
#import "TimeUtil.h"
#import "ScheduleItemModel.h"
#import "TouchScrollView.h"
#import "GameScrollView.h"

#define GameCellHeight [PUtil getActualHeight:222]

@interface GamePage  ()<UITableViewDelegate,UITableViewDataSource,GameScrollViewDelegate>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TouchScrollView *scrollerView;
@property (strong, nonatomic) UIView *timelineView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIView *selectPointView;
@property (strong, nonatomic) GameScrollView *gameScrollView;


@end

@implementation GamePage{
    NSString *index;
    NSMutableArray *datas;
    NSInteger itemPosition;
    NSMutableArray *hotDatas;
    int TopHeight;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        index = @"0";
        TopHeight =  [PUtil getActualHeight:418];
        datas = [[NSMutableArray alloc]init];
        hotDatas = [[NSMutableArray alloc]init];
        [self initView];
        [self requestHotRaces];
    }
    return self;
}

-(void)initView{
    _scrollerView = [[TouchScrollView alloc]initWithParentView:self];
    _scrollerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:88]);
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(uploadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _scrollerView.mj_header = header;
    [self addSubview:_scrollerView];
    
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, TopHeight+[PUtil getActualHeight:46], ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:88]);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = c06_backgroud;
    _tableView.scrollEnabled = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_tableView];
    
    _timelineView = [[UIView alloc]init];
    [_tableView addSubview:_timelineView];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c08_text;
    _lineView.alpha = 0.25f;
    [_timelineView addSubview:_lineView];
}

-(void)initTopView{
    
    UILabel *hotLabel = [[UILabel alloc]init];
    hotLabel.text = @"热门比赛";
    hotLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30],hotLabel.contentSize.width, hotLabel.contentSize.height);
    hotLabel.textColor = c09_tips;
    hotLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    [self addSubview:hotLabel];
    
    _topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, [PUtil getActualHeight:86], ScreenWidth, TopHeight);
    [self addSubview:_topView];
    
    _gameScrollView = [[GameScrollView alloc]init];
    _gameScrollView.gameScrollViewDelegate = self;
    [_topView addSubview:_gameScrollView];
    
}

-(void)initRaceLabel{
    UILabel *raceLabel = [[UILabel alloc]init];
    raceLabel.text = @"最近比赛";
    raceLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:10]+TopHeight,raceLabel.contentSize.width, raceLabel.contentSize.height);
    raceLabel.textColor = c09_tips;
    raceLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    [self addSubview:raceLabel];
}

-(void)OnItemClick:(ScheduleItemModel *)model{
    if(_handleDelegate){
        if([model.status isEqualToString:Statu_End]){
            [_handleDelegate goGuessPage:model.race_id end:YES];
        }else{
            [_handleDelegate goGuessPage:model.race_id end:NO];
        }
        [UMUtil clickEvent:EVENT_GAME_HOT];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [datas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PUtil getActualHeight:222];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    itemPosition = indexPath.row;
    [self updateSelectPoint];
    ScheduleItemModel *model = [datas objectAtIndex:indexPath.row];
    if(!IS_NS_STRING_EMPTY(model.score_a)){
        if(_handleDelegate){
            if([model.status isEqualToString:Statu_End]){
                [_handleDelegate goGuessPage:model.race_id end:YES];
            }else{
                [_handleDelegate goGuessPage:model.race_id end:NO];
            }
        }
    }
    [UMUtil clickEvent:EVENT_GAME_LASTEST];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScheduleItemModel *model = [datas objectAtIndex:indexPath.row];
    GameCell *cell =  [tableView dequeueReusableCellWithIdentifier:[GameCell identify]];
    if(cell == nil){
        cell = [[GameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[GameCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData: model];
    return cell;
}

-(void)uploadNew
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    //    index = 0;
    [self requestList2 : NO];
}

-(void)uploadMore
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    [self requestList2 : YES];
    
}

-(void)requestList2 : (Boolean)isRequestMore{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"index"] = index;
    NSString *sort = @"desc";
    if(isRequestMore){
        sort = @"asc";
    }
    dic[@"sort"] = sort;
    [ByNetUtil get:API_RACE2 parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            index = [data objectForKey:@"index"];
            id items = [data objectForKey:@"items"];
            NSMutableArray *tempDatas = [ScheduleItemModel mj_objectArrayWithKeyValuesArray:items];
            if(isRequestMore){
                if([tempDatas count] == 0){
                    [_scrollerView.mj_footer endRefreshingWithNoMoreData];
                }
                [datas addObjectsFromArray:tempDatas];
            }else{
                if([tempDatas count] == 0){
                    [_scrollerView.mj_header endRefreshing];
                    [DialogHelper showWarnTips:@"已是最新数据"];
                }
                [tempDatas addObjectsFromArray:datas];
                datas = tempDatas;
            }
            
            long height = GameCellHeight * [datas count];
            _scrollerView.frame = CGRectMake(0, TopHeight+[PUtil getActualHeight:56], ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:88]-( TopHeight+[PUtil getActualHeight:56]));
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, height);
            _scrollerView.contentSize =CGSizeMake(ScreenWidth,height);
            [_tableView reloadData];
            [self updateTimelineView];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
    }];
    
}

//-(void)requestList : (Boolean)isReuqestMore{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    dic[@"index"] = @(index);
//    [ByNetUtil get:API_RACE2 parameters:dic success:^(RespondModel *respondModel) {
//        if(respondModel.code == 200){
//            id data = respondModel.data;
//            index = [data objectForKey:@"index"];
//            if(index == -1){
//                [_scrollerView.mj_footer endRefreshingWithNoMoreData];
//                return ;
//            }
//            id items = [data objectForKey:@"items"];
//            NSMutableArray *tempDatas = [ScheduleModel mj_objectArrayWithKeyValuesArray:items];
//            NSMutableArray *addDatas = [[NSMutableArray alloc]init];
//            for(ScheduleModel *model in tempDatas){
//                if(model.dt != 0){
////                    ScheduleItemModel *titleModel = [[ScheduleItemModel alloc]init];
////                    titleModel.create_ts = [NSString stringWithFormat:@"%ld",model.dt];
////                    [addDatas addObject:titleModel];
//                    NSMutableArray *contentItems =model.items;
//                    if(!IS_NS_COLLECTION_EMPTY(contentItems)){
//                        for(int i = 0 ; i < [contentItems count];i++){
//                            id contentItem = [contentItems objectAtIndex:i];
//                            ScheduleItemModel *contentModel  = [ScheduleItemModel mj_objectWithKeyValues:contentItem];
//                            if(i == [contentItems count]-1){
//                                contentModel.hideLine = YES;
//                            }
//                            [addDatas addObject:contentModel];
//                        }
//                    }
//                }
//            }
//
//            if(isReuqestMore){
//                [datas addObjectsFromArray:addDatas];
//            }else{
//                datas = addDatas;
//            }
//
//            long height = GameCellHeight * [datas count];
//            _scrollerView.frame = CGRectMake(0, TopHeight+[PUtil getActualHeight:56], ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:88]-( TopHeight+[PUtil getActualHeight:56]));
//            _tableView.frame = CGRectMake(0, 0, ScreenWidth, height);
//            _scrollerView.contentSize =CGSizeMake(ScreenWidth,height);
//            [_tableView reloadData];
//            [self updateTimelineView];
////            [self test];
//        }else{
//            [DialogHelper showFailureAlertSheet:respondModel.msg];
//        }
//    } failure:^(NSError *error) {
//        [DialogHelper showFailureAlertSheet:@"请求失败"];
//
//    }];
//}

-(void)updateTimelineView{
    long height = GameCellHeight * [datas count] - [PUtil getActualHeight:20];
    _timelineView.frame = CGRectMake(0,  0, [PUtil getActualWidth:60], height);
    _lineView.frame =  CGRectMake([PUtil getActualWidth:30],  0, 1,height);
    
    
    for(int i = 0 ; i< [datas count] ; i++){
        UIView *normalPoint = [[UIView alloc]init];
        normalPoint.backgroundColor = [ColorUtil colorWithHexString:@"#5B5D73"];
        normalPoint.frame = CGRectMake([PUtil getActualWidth:23], ([PUtil getActualHeight:202] - [PUtil getActualWidth:18])/2 + i * GameCellHeight, [PUtil getActualWidth:18], [PUtil getActualWidth:18]);
        normalPoint.layer.masksToBounds = YES;
        normalPoint.layer.cornerRadius = [PUtil getActualWidth:9];
        normalPoint.layer.borderWidth = [PUtil getActualWidth:3];
        normalPoint.layer.borderColor = [c06_backgroud CGColor];
        [_timelineView addSubview:normalPoint];
    }
    [self updateSelectPoint];
}

-(void)updateSelectPoint{
    if(_selectPointView){
        [_selectPointView removeFromSuperview];
    }
    _selectPointView = [[UIView alloc]init];
    _selectPointView.backgroundColor = c01_blue;
    _selectPointView.frame = CGRectMake([PUtil getActualWidth:19], ([PUtil getActualHeight:202] - [PUtil getActualWidth:24])/2 + itemPosition * GameCellHeight, [PUtil getActualWidth:24], [PUtil getActualWidth:24]);
    _selectPointView.layer.masksToBounds = YES;
    _selectPointView.layer.cornerRadius = [PUtil getActualWidth:12];
    _selectPointView.layer.borderWidth = [PUtil getActualWidth:2];
    _selectPointView.layer.borderColor = [c08_text CGColor];
    [_timelineView addSubview:_selectPointView];
    
}


-(void)requestHotRaces{
    [ByNetUtil get:API_HOT_RACES parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            hotDatas = [ScheduleItemModel mj_objectArrayWithKeyValuesArray:data];
            if(IS_NS_COLLECTION_EMPTY(hotDatas)){
                TopHeight = 0;
            }else{
                [self initTopView];
                [_gameScrollView updateDatas:hotDatas];
            }
            [self initRaceLabel];
            [self requestList2:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//删除战队详情模块
//-(void)initTab{
//    NSMutableArray *views = [[NSMutableArray alloc]init];
//    ScheduleView *scheduleView = [[ScheduleView alloc]init];
//    scheduleView.handleDelegate = _handleDelegate;
//
//    CorpsView *corpsView = [[CorpsView alloc]init];
//    corpsView.handleDelegate = _handleDelegate;
//
//    [views addObject:scheduleView];
//    [views addObject:corpsView];
//
//    BySegmentView *segmentView = [[BySegmentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (StatuBarHeight + [PUtil getActualHeight:188])) andTitleArray:@[@"赛事安排", @"战队介绍"] andShowControllerNameArray:views];
//    [self.view addSubview:segmentView];
//}


-(void)test{
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    for(int i =0 ; i< [datas count]; i++){
        ScheduleItemModel *model = [datas objectAtIndex:i];
        if(!IS_NS_STRING_EMPTY(model.score_a)){
            [arrays addObject:[datas objectAtIndex:i]];
        }
    }
    
    [self initTopView];
    [_gameScrollView updateDatas:arrays];
}


@end
