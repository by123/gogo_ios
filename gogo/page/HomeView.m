//
//  OnePage.m
//  gogo
//
//  Created by by.huang on 2017/9/19.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "HomeView.h"
#import "NewsCell.h"
#import "RespondModel.h"
#import "RHPlayerView.h"
#import "VideoCell.h"
#import "CompetitionView.h"

#define AdViewHeight [PUtil getActualHeight:300]
#define AdInterval 3.0f

@interface HomeView ()<VideoCellDelegate,CompetitionViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) CompetitionView *competitionView;

@end

@implementation HomeView{
    NSString *index;
    long size;
    NSMutableArray *datas;
}



-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        datas = [[NSMutableArray alloc]init];
        index = @"0";
        size = 10;
        [self initView];
    }
    return self;
}


-(void)initView{
   
    _scrollerView = [[UIScrollView alloc]init];
    _scrollerView.frame = CGRectMake(0, 0, ScreenWidth, self.frame.size.height);
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMore)];
    
    _scrollerView.contentSize = CGSizeMake(ScreenWidth, [PUtil getActualHeight:172] * [datas count] + AdViewHeight);
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _scrollerView.mj_header = header;
    [self addSubview:_scrollerView];
    
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, AdViewHeight)];
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScrollTimeInterval = AdInterval;
    [_scrollerView addSubview:_cycleScrollView];
    
    _competitionView = [[CompetitionView alloc]initWithFrame:CGRectMake(0, AdViewHeight, ScreenWidth, [PUtil getActualHeight:232])];
    _competitionView.delegate = self;
    [_scrollerView addSubview:_competitionView];
    
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, AdViewHeight+[PUtil getActualHeight:232], ScreenWidth, [PUtil getActualHeight:172] * [datas count]);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = c06_backgroud;
    _tableView.scrollEnabled = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_tableView];
    
    [self requestBanner];
    [self requestNew];
}




#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if(_handleDelegate){
        NewsModel *model = [datas objectAtIndex:index];
        [_handleDelegate goNewsDetailPage:model];
        [UMUtil clickEvent:EVENT_AD];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [datas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *model = [datas objectAtIndex:indexPath.row];
    if(IS_NS_STRING_EMPTY(model.video)){
        return [PUtil getActualHeight:172];
    }else{
        return [PUtil getActualHeight:600];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self restore];
    if(_handleDelegate){
        NewsModel *model = [datas objectAtIndex:indexPath.row];
        [_handleDelegate goNewsDetailPage:model];
        [UMUtil clickEvent:EVENT_DETAIL];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsModel *model = [datas objectAtIndex:indexPath.row];
    if(IS_NS_STRING_EMPTY(model.video)){
        NewsCell *cell =  [tableView dequeueReusableCellWithIdentifier:[NewsCell identify]];
        if(cell == nil){
            cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewsCell identify]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setData:model];
        return cell;
    }else{
        VideoCell *cell =  [tableView dequeueReusableCellWithIdentifier:[VideoCell identify]];
        if(cell == nil){
            cell = [[VideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[VideoCell identify] controller:_vc delegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setData:model];
        return cell;
    }

}


-(void)requestNew
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    index = @"0";
    size = 10;
    [self requestList : NO];
}

-(void)requestMore
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    [self requestList : YES];
}

-(void)requestList : (Boolean) isRequestMore{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:index forKey:@"index"];
    [dic setObject:[NSString stringWithFormat:@"%ld",size] forKey:@"size"];
    [ByNetUtil get:API_NEWS_LIST parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id items = [respondModel.data objectForKey:@"items"];
            self->index =[respondModel.data objectForKey:@"index"] ;
            NSArray *temps = [NewsModel mj_objectArrayWithKeyValuesArray:items];
            if([temps count] == 0){
                [self->_scrollerView.mj_footer endRefreshingWithNoMoreData];
            }
            [self->datas addObjectsFromArray:temps];
            int height = 0;
            for(NewsModel *model in self->datas){
                if(IS_NS_STRING_EMPTY(model.video)){
                    height += [PUtil getActualHeight:172];
                }else{
                    height += [PUtil getActualHeight:600];
                }
            }
            self->_tableView.frame = CGRectMake(0, AdViewHeight+[PUtil getActualHeight:232], ScreenWidth, height);
            self->_scrollerView.contentSize = CGSizeMake(ScreenWidth, height +[PUtil getActualHeight:232]+ AdViewHeight);
            [self->_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"获取列表失败！"];
    }];
    
}

-(void)requestBanner{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [ByNetUtil get:API_BANNER parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            NSMutableArray *datas = [NewsModel mj_objectArrayWithKeyValuesArray:data];
            NSMutableArray *titles = [[NSMutableArray alloc]init];
            NSMutableArray *images = [[NSMutableArray alloc]init];
            if(!IS_NS_COLLECTION_EMPTY(datas)){
                for(NewsModel *model in datas){
                    [titles addObject:model.title];
                    [images addObject:model.cover];
                }
                [self->_cycleScrollView setImagesGroup:images titles:titles];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)requestType{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [ByNetUtil get:API_GETTYPE parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            NSMutableArray *datas = [NewsModel mj_objectArrayWithKeyValuesArray:data];
            NSMutableArray *titles = [[NSMutableArray alloc]init];
            NSMutableArray *images = [[NSMutableArray alloc]init];
            if(!IS_NS_COLLECTION_EMPTY(datas)){
                for(NewsModel *model in datas){
                    [titles addObject:model.title];
                    [images addObject:model.cover];
                }
                [self->_cycleScrollView setImagesGroup:images titles:titles];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)OnPlayClick:(NSInteger)tag{
    for(NewsModel *model in datas){
        model.isPlay = NO;
    }
    for(NewsModel *model in datas){
        if(model.news_id == tag){
            model.isPlay = YES;
        }
    }
    [_tableView reloadData];
}

-(void)appWillResignActive{
    [self restore];
}


-(void)videoPlayEnd{
    [self restore];
}

-(void)restore{
    for(NewsModel *model in datas){
        model.isPlay = NO;
    }
    [_tableView reloadData];
}

-(void)goGuessPage:(long)race_id end:(Boolean)isEnd{
    if(_handleDelegate){
        [_handleDelegate goGuessPage:race_id end:isEnd];
    }
}

-(void)goSchedulePage{
    if(_handleDelegate){
        [_handleDelegate goGamePage];
    }
}
@end
