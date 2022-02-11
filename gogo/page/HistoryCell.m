//
//  HistoryCell.m
//  gogo
//
//  Created by by.huang on 2017/10/27.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "HistoryCell.h"

@interface HistoryCell()

@property (strong, nonatomic) UILabel *resultLabel;
@property (strong, nonatomic) UILabel *aTeamLabel;
@property (strong, nonatomic) UILabel *bTeamLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation HistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.contentView.backgroundColor = c06_backgroud;

    _resultLabel = [[UILabel alloc]init];
    _resultLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30],[PUtil getActualWidth:50], [PUtil getActualHeight:28]);
    _resultLabel.textColor =c04_green;
    _resultLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
    [self.contentView addSubview:_resultLabel];
    
    _aTeamLabel = [[UILabel alloc]init];
    _aTeamLabel.frame = CGRectMake([PUtil getActualWidth:99], [PUtil getActualHeight:78],[PUtil getActualWidth:141], [PUtil getActualHeight:45]);
    _aTeamLabel.textColor =c08_text;
    _aTeamLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:32]];
    [self.contentView addSubview:_aTeamLabel];
    
    _bTeamLabel = [[UILabel alloc]init];
    _bTeamLabel.frame = CGRectMake([PUtil getActualWidth:555], [PUtil getActualHeight:78],[PUtil getActualWidth:47], [PUtil getActualHeight:45]);
    _bTeamLabel.textColor =c08_text;
    _bTeamLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:32]];
    [self.contentView addSubview:_bTeamLabel];
    
    _scoreLabel = [[UILabel alloc]init];
    _scoreLabel.frame = CGRectMake([PUtil getActualWidth:339], [PUtil getActualHeight:78],[PUtil getActualWidth:69], [PUtil getActualHeight:45]);
    _scoreLabel.textColor =c08_text;
    _scoreLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:32]];
    [self.contentView addSubview:_scoreLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.frame = CGRectMake([PUtil getActualWidth:472], [PUtil getActualHeight:30],[PUtil getActualWidth:260], [PUtil getActualHeight:28]);
    _timeLabel.textColor =c08_text;
    _timeLabel.alpha = 0.5f;
    _timeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
    [self.contentView addSubview:_timeLabel];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c05_divider;
    _lineView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:153]-1, ScreenWidth - [PUtil getActualWidth:30], 1);
    [self.contentView addSubview:_lineView];
    
}

-(void)setData : (HistoryModel *)model hideLine:(Boolean)hideLine{
    _resultLabel.text = model.result;
    _aTeamLabel.text = model.aTeam;
    _bTeamLabel.text = model.bTeam;
    _timeLabel.text = model.time;
    _scoreLabel.text = model.score;
    _lineView.hidden = hideLine;
}

+(NSString *)identify{
    return @"HistoryCell";
}

@end
