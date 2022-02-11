//
//  ScheduleContentCell.m
//  gogo
//
//  Created by by.huang on 2017/10/25.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ScheduleContentCell.h"
#import "TimeUtil.h"
#import "BettingItemModel.h"
@interface ScheduleContentCell()

@property (strong, nonatomic) UILabel *raceLabel;
@property (strong, nonatomic) UIImageView *aView;
@property (strong, nonatomic) UILabel *aLabel;
@property (strong, nonatomic) UILabel *bLabel;
@property (strong, nonatomic) UIImageView *bView;
@property (strong, nonatomic) UIView *timeView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *guessBtn;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *countLabel;

@end

@implementation ScheduleContentCell{
    id <MainHandleDelegate> handleDelegate;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    
    self.contentView.backgroundColor = c07_bar;
    
    _raceLabel = [[UILabel alloc]init];
    _raceLabel.textColor = c08_text;
    _raceLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _raceLabel.textAlignment = NSTextAlignmentCenter;
    _raceLabel.frame = CGRectMake(0, [PUtil getActualHeight:20], ScreenWidth, [PUtil getActualHeight:32]);
    [self.contentView addSubview:_raceLabel];

    
    _aView = [[UIImageView alloc]init];
    _aView.frame = CGRectMake([PUtil getActualWidth:110], [PUtil getActualHeight:77], [PUtil getActualHeight:80], [PUtil getActualHeight:80]);
    _aView.layer.masksToBounds = YES;
    _aView.layer.cornerRadius = [PUtil getActualHeight:80]/2;
    _aView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goDetail)];
    [_aView addGestureRecognizer:recognizer];
    [self.contentView addSubview:_aView];
    
    _aLabel = [[UILabel alloc]init];
    _aLabel.textColor = c08_text;
    _aLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [self.contentView addSubview:_aLabel];

    _timeView = [[UIView alloc]init];
    _timeView.frame = CGRectMake([PUtil getActualWidth:240],  [PUtil getActualHeight:100], [PUtil getActualWidth:116], [PUtil getActualHeight:40]);
    _timeView.layer.masksToBounds = YES;
    _timeView.layer.cornerRadius = [PUtil getActualHeight:40]/2;
    [self.contentView addSubview:_timeView];
    [ColorUtil setGradientColor:_timeView startColor:c01_blue endColor:c02_red director:Left];

    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.frame = CGRectMake([PUtil getActualWidth:240],  [PUtil getActualHeight:100], [PUtil getActualWidth:116], [PUtil getActualHeight:40]);
    _timeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _timeLabel.textColor = c08_text;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _countLabel.textColor = c08_text;
    _countLabel.alpha = 0.5;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_countLabel];
    
    
    _bView = [[UIImageView alloc]init];
    _bView.frame = CGRectMake([PUtil getActualWidth:406], [PUtil getActualHeight:77], [PUtil getActualHeight:80], [PUtil getActualHeight:80]);
    _bView.layer.masksToBounds = YES;
    _bView.layer.cornerRadius = [PUtil getActualHeight:80]/2;
    _bView.contentMode = UIViewContentModeScaleAspectFit;
    [_bView addGestureRecognizer:recognizer];
    [self.contentView addSubview:_bView];
    
    _bLabel = [[UILabel alloc]init];
    _bLabel.textColor = c08_text;
    _bLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [self.contentView addSubview:_bLabel];
    
    _guessBtn = [[UIButton alloc]init];
    _guessBtn.frame = CGRectMake([PUtil getActualWidth:576], [PUtil getActualHeight:90], [PUtil getActualWidth:144], [PUtil getActualHeight:64]);
    [_guessBtn setTitle:@"竞猜" forState:UIControlStateNormal];
    [_guessBtn setTitleColor:c08_text forState:UIControlStateNormal];
    _guessBtn.backgroundColor = c01_blue;
    _guessBtn.layer.masksToBounds = YES;
    _guessBtn.enabled = NO;
    _guessBtn.layer.cornerRadius = [PUtil getActualHeight:6];
    _guessBtn.titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
//    [_guessBtn addTarget:self action:@selector(goGuessPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_guessBtn];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c05_divider;
    _lineView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:224]-1, ScreenWidth - [PUtil getActualWidth:30], 1);
    [self.contentView addSubview:_lineView];
    
}

-(void)setData : (ScheduleItemModel *)model{
    _timeLabel.text = [NSString stringWithFormat:@"%@ : %@",model.score_a,model.score_b];
    TeamModel *aTeamModel = [TeamModel mj_objectWithKeyValues:model.team_a];
    [_aView sd_setImageWithURL:[NSURL URLWithString:aTeamModel.logo]];
    TeamModel *bTeamModel = [TeamModel mj_objectWithKeyValues:model.team_b];
    [_bView sd_setImageWithURL:[NSURL URLWithString:bTeamModel.logo]];
    _aLabel.text = aTeamModel.team_name;
    _aLabel.frame = CGRectMake([PUtil getActualWidth:152]- _aLabel.contentSize.width/2, [PUtil getActualHeight:165], _aLabel.contentSize.width, _aLabel.contentSize.height);

    _bLabel.text = bTeamModel.team_name;
    _bLabel.frame = CGRectMake([PUtil getActualWidth:448]- _bLabel.contentSize.width/2, [PUtil getActualHeight:165], _bLabel.contentSize.width, _bLabel.contentSize.height);
    
    if([model.status isEqualToString:Statu_End]){
        _raceLabel.text = [NSString stringWithFormat:@"%@ - 已结束",model.race_name];
    }else{
        _raceLabel.text = [NSString stringWithFormat:@"%@ - 未开始",model.race_name];
    }

    
    if(model.hideLine){
        [_lineView setHidden:YES];
    }
    
    if([model.status isEqualToString:Statu_Ready]){
        [_guessBtn setTitle:@"竞猜" forState:UIControlStateNormal];
        _guessBtn.backgroundColor = c02_red;
    }else{
        [_guessBtn setTitle:@"结果" forState:UIControlStateNormal];
        _guessBtn.backgroundColor = c01_blue;
    }
    
    _countLabel.text = [TimeUtil generateTime:model.race_ts];
    _countLabel.frame = CGRectMake(_timeView.mj_x - (_countLabel.contentSize.width-_timeView.mj_w)/2, [PUtil getActualHeight:165], _countLabel.contentSize.width, _countLabel.contentSize.height);
}

-(void)setDelegate : (id<MainHandleDelegate>)delegate{
    handleDelegate = delegate;
}

-(void)goGuessPage{
    if(handleDelegate){
        [handleDelegate goGuessPage:1L end:NO];
    }
}

-(void)goDetail{
    if(handleDelegate){
        [handleDelegate goCorpsDetailPage:1L];
    }
}

+(NSString *)identify{
    return @"ScheduleContentCell";
}

@end
