//
//  SchedulePage.m
//  gogo
//
//  Created by by.huang on 2017/10/24.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ScheduleView.h"
#import "NewsCell.h"
#import "ScheduleTitleCell.h"
#import "ScheduleContentCell.h"
#import "ScheduleModel.h"
#import "RespondModel.h"
#import "TimeUtil.h"
#import "ScheduleItemModel.h"

#define THeight [PUtil getActualHeight:86]
#define CHeight [PUtil getActualHeight:224]
@interface ScheduleView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIScrollView *scrollerView;

@end

@implementation ScheduleView{
    int index;
    NSMutableArray *datas;
}


-(instancetype)init{
    if(self == [super init]){
        index = 0;
        datas = [[NSMutableArray alloc]init];
        [self initView];
        [self requestList:NO];
    }
    return self;
}

-(void)initView{
    
    _scrollerView = [[UIScrollView alloc]init];
    _scrollerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:88]);
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(uploadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _scrollerView.mj_header = header;
    [self addSubview:_scrollerView];
    

    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:88]);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = c06_backgroud;
    _tableView.scrollEnabled = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [datas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScheduleItemModel *model = [datas objectAtIndex:indexPath.row];
    if(IS_NS_STRING_EMPTY(model.score_a)){
        return THeight;
    }
    return CHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScheduleItemModel *model = [datas objectAtIndex:indexPath.row];
    if(IS_NS_STRING_EMPTY(model.score_a)){
        ScheduleTitleCell *cell =  [tableView dequeueReusableCellWithIdentifier:[ScheduleTitleCell identify]];
        if(cell == nil){
            cell = [[ScheduleTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ScheduleTitleCell identify]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setData: model];
        return cell;
    }else{
        ScheduleContentCell *cell =  [tableView dequeueReusableCellWithIdentifier:[ScheduleContentCell identify]];
        if(cell == nil){
            cell = [[ScheduleContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ScheduleContentCell identify]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setDelegate:_handleDelegate];
        }
        [cell setData:model];
        return cell;
    }
}

-(void)uploadNew
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    index = 0;
    [self requestList : NO];
}

-(void)uploadMore
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    [self requestList : YES];

}


-(void)requestList : (Boolean)isReuqestMore{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"index"] = @(index);
    [ByNetUtil get:API_RACE parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            index = [[data objectForKey:@"index"] intValue];
            if(index == -1){
                [_scrollerView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            id items = [data objectForKey:@"items"];
            NSMutableArray *tempDatas = [ScheduleModel mj_objectArrayWithKeyValuesArray:items];
            NSMutableArray *addDatas = [[NSMutableArray alloc]init];
            for(ScheduleModel *model in tempDatas){
                if(model.dt != 0){
                    ScheduleItemModel *titleModel = [[ScheduleItemModel alloc]init];
                    titleModel.create_ts = [NSString stringWithFormat:@"%ld",model.dt];
                    [addDatas addObject:titleModel];
                    NSMutableArray *contentItems =model.items;
                    if(!IS_NS_COLLECTION_EMPTY(contentItems)){
                        for(int i = 0 ; i < [contentItems count];i++){
                            id contentItem = [contentItems objectAtIndex:i];
                            ScheduleItemModel *contentModel  = [ScheduleItemModel mj_objectWithKeyValues:contentItem];
                            if(i == [contentItems count]-1){
                                contentModel.hideLine = YES;
                            }
                            [addDatas addObject:contentModel];
                        }
                    }
                }
            }
            
            if(isReuqestMore){
                [datas addObjectsFromArray:addDatas];
            }else{
                datas = addDatas;
            }
            int height = 0;
            for(ScheduleItemModel *model in datas){
                if(IS_NS_STRING_EMPTY(model.score_a)){
                    height +=THeight;
                }else{
                    height +=CHeight;
                }
            }
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, height);
            _scrollerView.contentSize =CGSizeMake(ScreenWidth,height);
            [_tableView reloadData];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];

    }];
}




@end
