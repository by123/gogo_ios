//
//  CorpsPage.m
//  gogo
//
//  Created by by.huang on 2017/10/24.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "CorpsView.h"
#import "CorpsModel.h"
#import "CorpsCell.h"
#import "RespondModel.h"

@interface CorpsView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scrollerView;

@end

@implementation CorpsView{
    NSMutableArray *models;
    int index;
}

- (instancetype)init {
    if(self == [super init]){
        index = 0;
        [self initView];
        [self requestList : NO];
    }
    return self;
}

-(void)initView{
    _scrollerView = [[UIScrollView alloc]init];
    _scrollerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - [PUtil getActualHeight:316]);
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    _scrollerView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(uploadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _scrollerView.mj_header = header;
    [self addSubview:_scrollerView];
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = _scrollerView.frame;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = c06_backgroud;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_tableView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [models count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PUtil getActualHeight:110];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_handleDelegate){
        CorpsModel *model = [models objectAtIndex:indexPath.row];
        [_handleDelegate goCorpsDetailPage:model.team_id];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CorpsCell *cell =  [tableView dequeueReusableCellWithIdentifier:[CorpsCell identify]];
    if(cell == nil){
        cell = [[CorpsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CorpsCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CorpsModel *model = [models objectAtIndex:indexPath.row];
    [cell setData:model];
    return cell;
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

-(void)requestList : (Boolean) isRequestMore{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"index"] = @(index);
    dic[@"size"] = @(20);
    [ByNetUtil get:API_TEAMLIST parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            index = [[data objectForKey:@"index"] intValue];
            id items = [data objectForKey:@"items"];
            NSMutableArray * tempModels = [CorpsModel mj_objectArrayWithKeyValuesArray:items];
            if(isRequestMore){
                [models addObjectsFromArray:tempModels];
            }else{
                models = tempModels;
            }
            [_tableView reloadData];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, [models count] * [PUtil getActualHeight:110]);
        _scrollerView.contentSize = CGSizeMake(ScreenWidth, [models count] * [PUtil getActualHeight:110]);
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
    }];
}



@end
