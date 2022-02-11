//
//  GuessHistoryCell.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GuessHistoryCell.h"
#import "ItemView.h"
#import "TimeUtil.h"

@interface GuessHistoryCell()

@property (strong, nonatomic) UILabel *statuLabel;
@property (strong, nonatomic) UILabel *coinLabel;
@property (strong, nonatomic) UILabel *resultLabel;
@property (strong, nonatomic) ItemView  *timeView;
@property (strong, nonatomic) ItemView  *teamView;
@property (strong, nonatomic) ItemView  *guessView;
@property (strong, nonatomic) ItemView  *cathecticView;
@property (strong, nonatomic) ItemView  *resultView;

@end

@implementation GuessHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.contentView.backgroundColor = c07_bar;
    
    UIView *separatorView = [[UIView alloc]init];
    separatorView.frame = CGRectMake(0, 0, ScreenWidth, [PUtil getActualHeight:20]);
    separatorView.backgroundColor = c06_backgroud;
    [self.contentView addSubview:separatorView];
    
    _statuLabel = [[UILabel alloc]init];
    _statuLabel.text = @"比赛未完成";
    _statuLabel.textColor = c08_text;
    _statuLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:48]];
    _statuLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:67],ScreenWidth - [PUtil getActualWidth:30],  [PUtil getActualHeight:67]);
    [self.contentView addSubview:_statuLabel];
    
    _coinLabel = [[UILabel alloc]init];
    _coinLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:48]];
    _coinLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:67],ScreenWidth -[PUtil getActualWidth:30],  [PUtil getActualHeight:67]);
    [self.contentView addSubview:_coinLabel];
    
    
    _resultLabel = [[UILabel alloc]init];
    _resultLabel.text = @"竞猜币";
    _resultLabel.textAlignment = NSTextAlignmentRight;
    _resultLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:60]];
    _resultLabel.frame = CGRectMake(ScreenWidth/2, [PUtil getActualHeight:20],ScreenWidth/2 - [PUtil getActualWidth:30],  [PUtil getActualHeight:160]);
    _resultLabel.alpha = 0.5f;
    [self.contentView addSubview:_resultLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = c05_divider;
    lineView.frame = CGRectMake(0, [PUtil getActualHeight:180]-1, ScreenWidth, 1);
    [self.contentView addSubview:lineView];
    
    _timeView = [[ItemView alloc]initWithItemView:@"时间"];
    _timeView.frame = CGRectMake(0, [PUtil getActualHeight:180], ScreenWidth, [PUtil getActualHeight:80]);
    [self.contentView addSubview:_timeView];
    
    _teamView = [[ItemView alloc]initWithItemView:@"比赛"];
    _teamView.frame = CGRectMake(0, [PUtil getActualHeight:260], ScreenWidth, [PUtil getActualHeight:80]);
    [self.contentView addSubview:_teamView];
    
    _guessView = [[ItemView alloc]initWithItemView:@"竞猜"];
    _guessView.frame = CGRectMake(0, [PUtil getActualHeight:340], ScreenWidth, [PUtil getActualHeight:80]);
    [self.contentView addSubview:_guessView];
    
    _cathecticView = [[ItemView alloc]initWithItemView:@"投注"];
    _cathecticView.frame = CGRectMake(0, [PUtil getActualHeight:420], ScreenWidth, [PUtil getActualHeight:80]);
    [self.contentView addSubview:_cathecticView];
    
    _resultView = [[ItemView alloc]initWithItemView:@"结果"];
    _resultView.frame = CGRectMake(0, [PUtil getActualHeight:500], ScreenWidth, [PUtil getActualHeight:80]);
    [_resultView setHideLine:YES];
    [self.contentView addSubview:_resultView];
    
}


-(void)setData : (GuessHistoryModel *)model{
    if([model.status isEqualToString:APPLY]){
        _coinLabel.hidden = YES;
        _resultLabel.text = @"-";
        _resultLabel.textColor = c08_text;
        [_resultView setContent:@"比赛未完成"];

    }else if([model.status isEqualToString:WIN]){
        _statuLabel.hidden = YES;
        _coinLabel.textColor = c01_blue;
        int result = [model.coin intValue] * [model.odds intValue];
        _coinLabel.text = [NSString stringWithFormat:@"+ %d",result];
        _resultLabel.text = @"WIN";
        _resultLabel.textColor = c01_blue;
        [_resultView setContent:@"赢"];

    }else if([model.status isEqualToString:LOSE]){
        _statuLabel.hidden = YES;
        _coinLabel.textColor = c02_red;
        _coinLabel.text = [NSString stringWithFormat:@"- %@",model.coin];
        _resultLabel.text = @"LOSE";
        _resultLabel.textColor = c02_red;
        [_resultView setContent:@"输"];

    }
    
    //时间
    NSString *time = [TimeUtil generateAll:model.create_ts];
    [_timeView setContent:time];
    
    //比赛
    RaceModel *raceModel = [RaceModel mj_objectWithKeyValues:model.race];
    TeamModel *aTeamModel =raceModel.team_a;
    TeamModel *bTeamModel =raceModel.team_b;
    NSString *raceStr = [NSString stringWithFormat:@"%@ vs %@",aTeamModel.team_name,bTeamModel.team_name];
    [_teamView setContent:raceStr];
    
    //竞猜
    NSMutableArray *bettingModels = [BettingModel mj_objectArrayWithKeyValuesArray:model.bettings];
    BettingModel *bettingModel = [bettingModels objectAtIndex:0];
    
    NSMutableArray *itemModels = [BettingItemModel mj_objectArrayWithKeyValuesArray:bettingModel.items];
    BettingItemModel *itemModel = [itemModels objectAtIndex:0];
    
    NSString *guessStr = [NSString stringWithFormat:@"%@ / %@",bettingModel.title,itemModel.title];
    [_guessView setContent:guessStr];
    
    //投注
    NSString *cathecticStr = [NSString stringWithFormat:@"%@竞猜币 / 赔率%@",model.coin,model.odds];
    [_cathecticView setContent:cathecticStr];
    

    //结果
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@竞猜币",_coinLabel.text]];
    NSRange redRangeTwo = NSMakeRange(noteStr.length - 3, 3);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[PUtil getActualHeight:24]] range:redRangeTwo];
    [_coinLabel setAttributedText:noteStr];
    [_coinLabel sizeToFit];
    

    
}

+(NSString *)identify{
    return @"GuessHistoryCell";
}

@end
