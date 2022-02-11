//
//  SCDTeamView.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "SCDTeamView.h"
#import "MemberCell.h"
#import "MemberModel.h"

@interface SCDTeamView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UILabel *aTeamLabel;
@property (strong, nonatomic) UITableView *aTeamTableView;
@property (strong, nonatomic) UILabel *bTeamLabel;
@property (strong, nonatomic) UITableView *bTeamTableView;

@end

@implementation SCDTeamView{
    NSMutableArray *models;
}

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
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,[PUtil getActualHeight:2172]);
    [self addSubview:_scrollerView];
    
    _aTeamLabel =[[UILabel alloc]init];
    _aTeamLabel.text = @"AG超会玩";
    _aTeamLabel.textColor = c09_tips;
    _aTeamLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _aTeamLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30], ScreenWidth - [PUtil getActualWidth:30], [PUtil getActualHeight:40]);
    [_scrollerView addSubview:_aTeamLabel];
    
    _aTeamTableView = [[UITableView alloc]init];
    _aTeamTableView.frame = CGRectMake(0,  [PUtil getActualHeight:86], ScreenWidth, 5*[PUtil getActualHeight:200]);
    _aTeamTableView.delegate = self;
    _aTeamTableView.dataSource = self;
    _aTeamTableView.scrollEnabled = NO;
    [_aTeamTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_aTeamTableView];
    
    _bTeamLabel =[[UILabel alloc]init];
    _bTeamLabel.text = @"GK";
    _bTeamLabel.textColor = c09_tips;
    _bTeamLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _bTeamLabel.frame = CGRectMake([PUtil getActualWidth:30], _aTeamTableView.mj_h+_aTeamTableView.mj_y+[PUtil getActualHeight:30], ScreenWidth - [PUtil getActualWidth:30], [PUtil getActualHeight:40]);
    [_scrollerView addSubview:_bTeamLabel];
    
    _bTeamTableView = [[UITableView alloc]init];
    _bTeamTableView.frame = CGRectMake(0,  _aTeamTableView.mj_h+_aTeamTableView.mj_y+[PUtil getActualHeight:86], ScreenWidth, 5*[PUtil getActualHeight:200]);
    _bTeamTableView.delegate = self;
    _bTeamTableView.dataSource = self;
    _bTeamTableView.scrollEnabled = NO;
    [_bTeamTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_bTeamTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [models count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PUtil getActualHeight:200];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberCell *cell =  [tableView dequeueReusableCellWithIdentifier:[MemberCell identify]];
    if(cell == nil){
        cell = [[MemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MemberCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = c07_bar;
    }
    MemberModel *model = [models objectAtIndex:indexPath.row];
    if([models count] -1 == indexPath.row ){
        [cell setData:model hideline:YES];
    }else{
        [cell setData:model hideline:NO];
    }
    return cell;
}

@end
