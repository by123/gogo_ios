//
//  GameScrollView.m
//  gogo
//
//  Created by by.huang on 2018/1/31.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "GameScrollView.h"
#import "TouchScrollView.h"
#import "ScheduleItemModel.h"
#import "TimeUtil.h"
#import "TeamModel.h"
#define GameScrollViewHeight [PUtil getActualHeight:332]
#define ScrollViewHeight [PUtil getActualHeight:302]

@interface GameScrollView()<UIScrollViewDelegate>

@property (strong, nonatomic) TouchScrollView *scrollView;
@property (strong, nonatomic) UIView *positionView;

@end

@implementation GameScrollView{
    NSMutableArray *mDatas;
    NSMutableArray *mPointViews;
    UIView *mCurrentPointView;
}

-(instancetype)init{
    if(self == [super init]){
        [self initView];
    }
    return self;
}

-(void)updateDatas:(NSMutableArray *)datas{
    mDatas = datas;
    _scrollView.contentSize = CGSizeMake(ScreenWidth * [mDatas count], ScrollViewHeight);
    for(int i=0 ; i< [mDatas count] ; i++){
        ScheduleItemModel *model = [mDatas objectAtIndex:i];
        UIButton *button = [self buildView:model index:i];
        button.tag = i;
        [button addTarget:self action:@selector(OnClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }
    
    int pointWidth = [PUtil getActualWidth:10];
    long positonWidth = pointWidth*[mDatas count]+pointWidth *([mDatas count]-1);
    _positionView = [[UIView alloc]init];
    _positionView.frame = CGRectMake((ScreenWidth -positonWidth)/2 , [PUtil getActualHeight:322],positonWidth, pointWidth);
    [self addSubview:_positionView];
    
    mPointViews = [[NSMutableArray alloc]init];
    for(int m=0; m < [mDatas count];m++){
        UIView *pointView = [[UIView alloc]init];
        if(m != 0){
            pointView.alpha = 0.5f;
        }
        pointView.backgroundColor = c08_text;
        pointView.layer.masksToBounds = YES;
        pointView.layer.cornerRadius =pointWidth/2;
        pointView.tag = m;
        pointView.frame = CGRectMake(m* pointWidth *2, 0, pointWidth, pointWidth);
        [_positionView addSubview:pointView];
        [mPointViews addObject:pointView];
        if(m == 0){
            mCurrentPointView = pointView;
        }
    }
}
-(void)initView{
    self.frame = CGRectMake(0, 0, ScreenWidth, GameScrollViewHeight);
    _scrollView = [[TouchScrollView alloc]initWithParentView:self];
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScrollViewHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScrollViewHeight);
    [self addSubview:_scrollView];
    
}

-(UIButton *)buildView : (ScheduleItemModel *)model index:(int)i{
    UIButton *view = [[UIButton alloc]init];
    view.backgroundColor = c07_bar;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.frame = CGRectMake([PUtil getActualWidth:20]+ScreenWidth * i, 0, ScreenWidth-[PUtil getActualWidth:40], ScrollViewHeight);
    
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, view.mj_w, [PUtil getActualHeight:140]);
    [ColorUtil setGradientColor:topView startColor:c01_blue endColor:c02_red director:Left];
    [view addSubview:topView];
    
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.textColor = c08_text;
    topLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    topLabel.text = model.race_name;
    topLabel.frame = CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:25], topLabel.contentSize.width, topLabel.contentSize.height);
    [topView addSubview:topLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = c08_text;
    timeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    timeLabel.alpha = 0.5f;
    timeLabel.text = [TimeUtil generateAll:model.race_ts];
    timeLabel.frame = CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:83], topLabel.contentSize.width, topLabel.contentSize.height);
    [topView addSubview:timeLabel];
    
    TeamModel *aTeamModel = [TeamModel mj_objectWithKeyValues:model.team_a];
    UIImageView *aImageView =[[UIImageView alloc]init];
    aImageView.frame = CGRectMake([PUtil getActualWidth:80], [PUtil getActualHeight:161], [PUtil getActualHeight:80], [PUtil getActualHeight:80]);
    aImageView.layer.masksToBounds = YES;
    aImageView.layer.cornerRadius = [PUtil getActualHeight:40];
    [aImageView sd_setImageWithURL:[NSURL URLWithString:aTeamModel.logo]];
    [topView addSubview:aImageView];
    
    UILabel *aLabel = [[UILabel alloc]init];
    aLabel.textColor = c08_text;
    aLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    aLabel.text = aTeamModel.team_name;
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.frame = CGRectMake(0, [PUtil getActualHeight:251], [PUtil getActualWidth:240], aLabel.contentSize.height);
    [topView addSubview:aLabel];
    
    UILabel *scoreLabel = [[UILabel alloc]init];
    scoreLabel.textColor = c08_text;
    scoreLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:48]];
    scoreLabel.text = [NSString stringWithFormat:@"%@ : %@",model.score_a,model.score_b];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.frame = CGRectMake([PUtil getActualWidth:240], [PUtil getActualHeight:140], scoreLabel.contentSize.width, [PUtil getActualHeight:162]);
    [topView addSubview:scoreLabel];
    
    TeamModel *bTeamModel = [TeamModel mj_objectWithKeyValues:model.team_b];
    UIImageView *bImageView =[[UIImageView alloc]init];
    bImageView.frame = CGRectMake([PUtil getActualWidth:400], [PUtil getActualHeight:161], [PUtil getActualHeight:80], [PUtil getActualHeight:80]);
    bImageView.layer.masksToBounds = YES;
    bImageView.layer.cornerRadius = [PUtil getActualHeight:40];
    [bImageView sd_setImageWithURL:[NSURL URLWithString:bTeamModel.logo]];
    [topView addSubview:bImageView];
    
    UILabel *bLabel = [[UILabel alloc]init];
    bLabel.textColor = c08_text;
    bLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    bLabel.text = bTeamModel.team_name;
    bLabel.textAlignment = NSTextAlignmentCenter;
    bLabel.frame = CGRectMake([PUtil getActualWidth:360], [PUtil getActualHeight:251], [PUtil getActualWidth:160], bLabel.contentSize.height);
    [topView addSubview:bLabel];
    
    UIButton *guessBtn = [[UIButton alloc]init];
    guessBtn.frame = CGRectMake([PUtil getActualWidth:540], [PUtil getActualHeight:189], [PUtil getActualWidth:144], [PUtil getActualHeight:64]);
    [guessBtn setTitle:@"竞猜" forState:UIControlStateNormal];
    [guessBtn setTitleColor:c08_text forState:UIControlStateNormal];
    guessBtn.backgroundColor = c01_blue;
    guessBtn.layer.masksToBounds = YES;
    guessBtn.enabled = NO;
    guessBtn.layer.cornerRadius = [PUtil getActualHeight:6];
    guessBtn.titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    [topView addSubview:guessBtn];
    
    if([model.status isEqualToString:Statu_Ready]){
        [guessBtn setTitle:@"竞猜" forState:UIControlStateNormal];
        guessBtn.backgroundColor = c02_red;
    }else{
        [guessBtn setTitle:@"结果" forState:UIControlStateNormal];
        guessBtn.backgroundColor = c01_blue;
    }
    
    return view;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    int postion = x / ScreenWidth;
    if(!IS_NS_COLLECTION_EMPTY(mPointViews)){
        if(postion != mCurrentPointView.tag){
            mCurrentPointView.alpha = 0.5f;
            UIView *view = [mPointViews objectAtIndex:postion];
            view.alpha = 1.0f;
            mCurrentPointView = view;
        }
    }
}

-(void)OnClickItem:(id)sender{
    UIButton *button = sender;
    NSInteger click = button.tag;
    if(_gameScrollViewDelegate){
        [_gameScrollViewDelegate OnItemClick:[mDatas objectAtIndex:click]];
    }
}


@end
