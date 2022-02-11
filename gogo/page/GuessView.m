//
//  GuessView.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GuessView.h"
#import "TouchTableView.h"
#import "TouchScrollView.h"
#import "GuessCell.h"
#import "BettingModel.h"
#import "BettingTpModel.h"
#import "RespondModel.h"
#import "BettingModel.h"
@interface GuessView()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) TouchTableView *tableView;
@property (strong, nonatomic) TouchScrollView *scrollerView;

@end

@implementation GuessView{
    NSMutableArray *bettingModels;
    NSMutableArray *models;
    Boolean end;
    long raceID;
    UIButton *selectBtn;
}

-(instancetype)initWithDatas : (NSMutableArray *)datas raceid:(long)raceid end:(Boolean)isEnd{
    if(self == [super init]){
        models = datas;
        raceID = raceid;
        end = isEnd;
        [self initTpView];
    }
    return self;
}

-(void)initTpView{
    float width = (ScreenWidth - ([models count] + 1) *  [PUtil getActualWidth:10]) / [models count];
    for(int i=0; i< [models count]; i++){
        BettingTpModel *model = [models objectAtIndex:i];
        UIButton *button = [[UIButton alloc]init];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:model.tp_name forState:UIControlStateNormal];
        [button setTitleColor:c08_text forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.tag = [model.tp integerValue];
        button.layer.borderWidth = 1;
        button.layer.borderColor = c01_blue.CGColor;
        if(i == 0){
            selectBtn = button;
            button.backgroundColor = c01_blue;
        }else{
            button.backgroundColor = c06_backgroud;
        }
        button.layer.cornerRadius = 4;
        button.frame = CGRectMake([PUtil getActualWidth:10] + ([PUtil getActualWidth:10] + width)*i, [PUtil getActualHeight:20],width, [PUtil getActualHeight:50]);
        [button addTarget:self action:@selector(OnSelectTp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    if(!IS_NS_COLLECTION_EMPTY(models)){
        BettingTpModel *model = [models objectAtIndex:0];
        [self requestData : model.tp];
    }
}



-(void)initView{
    int height = 0;
    for(BettingModel *bettingModel in bettingModels){
        NSMutableArray *datas = bettingModel.items;
        NSInteger rows = ([datas count]-1) / 3;
        int per = [PUtil getActualHeight:117];
        height += [PUtil getActualHeight:206] + per * rows;
    }

    self.backgroundColor = c06_backgroud;
    _scrollerView = [[TouchScrollView alloc]initWithParentView:self];
    _scrollerView.userInteractionEnabled =YES;
    _scrollerView.frame = CGRectMake(0, [PUtil getActualHeight:80], ScreenWidth, ScreenHeight - [PUtil getActualHeight:400]-StatuBarHeight - [PUtil getActualHeight:80]-[PUtil getActualHeight:88]);
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
//    _scrollerView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,  height);
    [self addSubview:_scrollerView];
    
    _tableView = [[TouchTableView alloc]initWithParentView:_scrollerView];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, height);
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
    return [bettingModels count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BettingModel *bettingModel = [bettingModels objectAtIndex:indexPath.row];
    NSMutableArray *datas = [BettingItemModel mj_objectArrayWithKeyValuesArray:bettingModel.items];
    if([datas count]>0){
        NSInteger rows = ([datas count] -1) / 3;
        int per = [PUtil getActualHeight:117];
        return [PUtil getActualHeight:206] + per * rows;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuessCell *cell =  [tableView dequeueReusableCellWithIdentifier:[GuessCell identify]];
    if(cell == nil){
        cell = [[GuessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[GuessCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BettingModel *bettingModel = [bettingModels objectAtIndex:indexPath.row];
    if(end){
        bettingModel.betting_status = Statu_AlreadyBet;
    }else{
        bettingModel.betting_status = Statu_NotBet;
    }
    [cell setData:bettingModel deleaget:self];
    return cell;
}

-(void)uploadNew
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
}

-(void)uploadMore
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
}


-(void)onClick:(BettingItemModel *)model{
    if(_delegate){
        [_delegate OpenGuessOrderView:model guessView:self];
        [UMUtil clickEvent:EVENT_GAME_GUESS_SELECT];
    }
}

-(void)restoreItems{
    for(BettingModel *bettingModel in bettingModels){
        NSMutableArray *datas = [BettingItemModel mj_objectArrayWithKeyValuesArray:bettingModel.items];
        for(BettingItemModel *itemModel in datas){
            itemModel.isSelect = NO;
        }
    }
    [_tableView reloadData];
}


-(void)requestData : (NSString *)type{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%ld/%@",API_GUESS_DETAIL,raceID,type];
    [ByNetUtil get:requestUrl parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            bettingModels = [BettingModel mj_objectArrayWithKeyValuesArray:data];
            [self initView];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
    }];
}

-(void)OnSelectTp:(id)sender{
    [_scrollerView removeFromSuperview];
    UIButton *button = sender;
    button.backgroundColor = c01_blue;
    selectBtn.backgroundColor = c06_backgroud;
    selectBtn = button;
    [self requestData:[NSString stringWithFormat:@"%d",button.tag]];
}

@end
