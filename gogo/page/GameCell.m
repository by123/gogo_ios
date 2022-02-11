//
//  GameCell.m
//  gogo
//
//  Created by by.huang on 2018/1/31.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "GameCell.h"
#import "TimeUtil.h"
#define GameCellHeight [PUtil getActualHeight:222]
#define BodyHeight [PUtil getActualHeight:202]

@interface GameCell()

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *aLabel;
@property (strong, nonatomic) UILabel *bLabel;
@property (strong, nonatomic) UIImageView *aImageView;
@property (strong, nonatomic) UIImageView *bImageView;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *guessLabel;

@end

@implementation GameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.contentView.backgroundColor = c06_backgroud;
    
    UIView *bodyView = [[UIView alloc]init];
    bodyView.frame = CGRectMake([PUtil getActualWidth:60], 0, ScreenWidth - [PUtil getActualWidth:80], BodyHeight);
    bodyView.backgroundColor = c07_bar;
    bodyView.layer.masksToBounds = YES;
    bodyView.layer.cornerRadius = 5;
    
    [self.contentView addSubview:bodyView];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.alpha = 0.5f;
    _timeLabel.textColor = c08_text;
    _timeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _timeLabel.frame = CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:20],[PUtil getActualWidth:670], [PUtil getActualHeight:33]);
    [bodyView addSubview:_timeLabel];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = c08_text;
    _nameLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _nameLabel.frame = CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:53],[PUtil getActualWidth:670], [PUtil getActualHeight:40]);
    [bodyView addSubview:_nameLabel];
    
    _guessLabel = [[UILabel alloc]init];
    _guessLabel.text = @"去竞猜";
    _guessLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _guessLabel.textColor = c09_tips;
    _guessLabel.frame = CGRectMake(bodyView.mj_w - [PUtil getActualWidth:36] - _guessLabel.contentSize.width,0, _guessLabel.contentSize.width, [PUtil getActualHeight:113]);
    [bodyView addSubview:_guessLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]init];
    arrowImageView.frame = CGRectMake(bodyView.mj_w  - [PUtil getActualWidth:31], [PUtil getActualHeight:93]/2, [PUtil getActualWidth:11], [PUtil getActualWidth:20]);
    arrowImageView.image = [UIImage imageNamed:@"ic_enter_12"];
    [bodyView addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = c05_divider;
    lineView.frame = CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:113], ScreenWidth - [PUtil getActualWidth:120], 1);
    [bodyView addSubview:lineView];
    
    int imageWidth = [PUtil getActualWidth:48];
    _aImageView = [[UIImageView alloc]init];
    _aImageView.frame = CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:134], imageWidth, imageWidth);
    _aImageView.layer.masksToBounds = YES;
    _aImageView.layer.cornerRadius = imageWidth/2;
    [bodyView addSubview:_aImageView];
    
    _aLabel = [[UILabel alloc]init];
    _aLabel.textColor = c08_text;
    _aLabel.textAlignment = NSTextAlignmentCenter;
    _aLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    [bodyView addSubview:_aLabel];
    
    
    _bImageView = [[UIImageView alloc]init];
    _bImageView.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:100]-imageWidth, [PUtil getActualHeight:134], imageWidth, imageWidth);
    _bImageView.layer.masksToBounds = YES;
    _bImageView.layer.cornerRadius = imageWidth/2;
    [bodyView addSubview:_bImageView];
    
    _bLabel = [[UILabel alloc]init];
    _bLabel.textColor = c08_text;
    _bLabel.textAlignment = NSTextAlignmentCenter;
    _bLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    [bodyView addSubview:_bLabel];
    
    _scoreLabel = [[UILabel alloc]init];
    _scoreLabel.textColor = c08_text;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _scoreLabel.frame = CGRectMake(0, [PUtil getActualHeight:114], ScreenWidth - [PUtil getActualWidth:80], [PUtil getActualHeight:88]);
    [bodyView addSubview:_scoreLabel];
    
    
}

-(void)setData : (ScheduleItemModel *)model{
    
    _timeLabel.text = [TimeUtil generateAll:model.race_ts];
    _nameLabel.text = model.race_name;
    
    TeamModel *aTeamModel = [TeamModel mj_objectWithKeyValues:model.team_a];
    [_aImageView sd_setImageWithURL:[NSURL URLWithString:aTeamModel.logo]];
    _aLabel.text = aTeamModel.team_name;
    CGSize aSize = [_aLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[PUtil getActualHeight:28]]} context:nil].size;
    _aLabel.frame = CGRectMake([PUtil getActualWidth:78], [PUtil getActualHeight:114],aSize.width, [PUtil getActualHeight:88]);
    
    
    TeamModel *bTeamModel = [TeamModel mj_objectWithKeyValues:model.team_b];
    [_bImageView sd_setImageWithURL:[NSURL URLWithString:bTeamModel.logo]];
    _bLabel.text = bTeamModel.team_name;
    CGSize bSize = [_bLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[PUtil getActualHeight:28]]} context:nil].size;
    
    _bLabel.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:158] - bSize.width, [PUtil getActualHeight:114],bSize.width, [PUtil getActualHeight:88]);
    
    _scoreLabel.text = [NSString stringWithFormat:@"%@ : %@",model.score_a,model.score_b];
    
    if([model.status isEqualToString:Statu_End]){
        _guessLabel.text = @"看结果";
    }else{
        _guessLabel.text = @"去竞猜";
    }
    
    
}

+(NSString *)identify{
    return @"GameCell";
}

@end
