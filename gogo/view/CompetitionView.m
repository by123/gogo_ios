//
//  CompetitionView.m
//  gogo
//
//  Created by by.huang on 2018/1/26.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "CompetitionView.h"
#import "ScheduleModel.h"
#import "RespondModel.h"
#import "TimeUtil.h"

@interface CompetitionView()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *moreBtn;
@property (strong, nonatomic) UIView *lineVerView;
@property (strong, nonatomic) UIView *lineHorView;

@end

@implementation CompetitionView{
    NSMutableArray *datas;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.backgroundColor = c07_bar;
        [self requestList];
    }
    return self;
}

-(void)initView{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"共21场竞猜";
    _titleLabel.textColor = c09_tips;
    _titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _titleLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:19], _titleLabel.contentSize.width, _titleLabel.contentSize.height);
    [self addSubview:_titleLabel];
    
    _moreBtn = [[UIButton alloc]init];
    [_moreBtn setTitle:@"更多比赛 >" forState:UIControlStateNormal];
    [_moreBtn setTitleColor:c09_tips forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _moreBtn.backgroundColor = [UIColor clearColor];
    _moreBtn.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:30] - _moreBtn.titleLabel.contentSize.width, [PUtil getActualHeight:19], _moreBtn.titleLabel.contentSize.width, _moreBtn.titleLabel.contentSize.height);
    [_moreBtn addTarget:self action:@selector(OnClickMore) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    
    _lineVerView = [[UIView alloc]init];
    _lineVerView.backgroundColor = c05_divider;
    _lineVerView.frame = CGRectMake(0,  [PUtil getActualHeight:70], ScreenWidth, 1);
    [self addSubview:_lineVerView];
    
    _lineHorView = [[UIView alloc]init];
    _lineHorView.backgroundColor = c05_divider;
    _lineHorView.frame = CGRectMake(ScreenWidth/2-1,  [PUtil getActualHeight:70], 1, [PUtil getActualHeight:162]);
    [self addSubview:_lineHorView];
    
    int imageWidth = [PUtil getActualWidth:48];
    if([datas count] > 1){
        for(int i = 0; i< 2 ; i++){
            UIButton *raceBtn = [[UIButton alloc]init];
            raceBtn.frame = CGRectMake(i*ScreenWidth/2, [PUtil getActualHeight:70], ScreenWidth/2, [PUtil getActualHeight:162]);
            raceBtn.tag = i;
            [raceBtn addTarget:self action:@selector(OnClickRace:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:raceBtn];
            //ui
            UIImageView *aImageView = [[UIImageView alloc]init];
            aImageView.frame = CGRectMake([PUtil getActualWidth:24], [PUtil getActualHeight:23], imageWidth, imageWidth);
            aImageView.layer.masksToBounds = YES;
            aImageView.layer.cornerRadius = imageWidth/2;
            [raceBtn addSubview:aImageView];
            
            UIImageView *bImageView = [[UIImageView alloc]init];
            bImageView.frame = CGRectMake([PUtil getActualWidth:24], [PUtil getActualHeight:91], imageWidth, imageWidth);
            bImageView.layer.masksToBounds = YES;
            bImageView.layer.cornerRadius = imageWidth/2;
            [raceBtn addSubview:bImageView];
            
            UILabel *aLabel = [[UILabel alloc]init];
            aLabel.textColor =c08_text;
            aLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
            aLabel.frame = CGRectMake([PUtil getActualWidth:92], [PUtil getActualHeight:23], 100, imageWidth);
            [raceBtn addSubview:aLabel];
            
            UILabel *bLabel = [[UILabel alloc]init];
            bLabel.textColor =c08_text;
            bLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
            bLabel.frame = CGRectMake([PUtil getActualWidth:92], [PUtil getActualHeight:91], 100, imageWidth);
            [raceBtn addSubview:bLabel];
            
            UILabel *raceLabel = [[UILabel alloc]init];
            raceLabel.textColor =c02_red;
            raceLabel.text = @"KPL";
            raceLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
            raceLabel.frame = CGRectMake(ScreenWidth/2 - [PUtil getActualWidth:24] -raceLabel.contentSize.width, [PUtil getActualHeight:31], raceLabel.contentSize.width, raceLabel.contentSize.height);
            [raceBtn addSubview:raceLabel];
            
            UILabel *dataLabel = [[UILabel alloc]init];
            dataLabel.textColor =c01_blue;
            if(IS_IPHONE_X){
                dataLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:18]];
            }else{
                dataLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
            }
            [raceBtn addSubview:dataLabel];
            
            //data
            ScheduleModel *model = [datas objectAtIndex:i];
            NSMutableArray *contentItems =model.items;
            
            if(!IS_NS_COLLECTION_EMPTY(contentItems)){
                for(id contentItem in contentItems){
                    ScheduleItemModel *contentModel  = [ScheduleItemModel mj_objectWithKeyValues:contentItem];
                    TeamModel *aTeam = [TeamModel mj_objectWithKeyValues:contentModel.team_a];
                    [aImageView sd_setImageWithURL:[NSURL URLWithString:aTeam.logo]];
                    aLabel.text = aTeam.team_name;
                    
                    TeamModel *bTeam = [TeamModel mj_objectWithKeyValues:contentModel.team_b];
                    [bImageView sd_setImageWithURL:[NSURL URLWithString:bTeam.logo]];
                    bLabel.text = bTeam.team_name;
                    
                    dataLabel.text = [NSString stringWithFormat:@"%@ %@",[TimeUtil generateData:contentModel.race_ts],[TimeUtil generateTime:contentModel.race_ts]];
                    dataLabel.frame = CGRectMake(ScreenWidth/2 - [PUtil getActualWidth:24] -dataLabel.contentSize.width, [PUtil getActualHeight:101], dataLabel.contentSize.width, dataLabel.contentSize.height);
                    
                }
            }
        }
    }
    
}

-(void)OnClickMore{
    if(_delegate){
        [_delegate goSchedulePage];
        [UMUtil clickEvent:EVENT_HOME_MORE];
    }
}

-(void)OnClickRace : (id)sender{
    UIButton *button = sender;
    NSInteger i = button.tag;
    ScheduleModel *model = [datas objectAtIndex:i];
    NSMutableArray *contentItems =model.items;
    
    if(_delegate){
        if(!IS_NS_COLLECTION_EMPTY(contentItems)){
            for(id contentItem in contentItems){
                ScheduleItemModel *model  = [ScheduleItemModel mj_objectWithKeyValues:contentItem];
                if([model.status isEqualToString:Statu_End]){
                    [_delegate goGuessPage:model.race_id end:YES];
                }else{
                    [_delegate goGuessPage:model.race_id end:NO];
                }
                [UMUtil clickEvent:EVENT_HOME_GAME];
            }
        }
    }
}

-(void)requestList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"index"] = @"0";
    [ByNetUtil get:API_RACE parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            id items = [data objectForKey:@"items"];
            datas = [ScheduleModel mj_objectArrayWithKeyValuesArray:items];
            [self initView];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
        
    }];
}

@end
