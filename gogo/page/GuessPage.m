//
//  GuessPage.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GuessPage.h"
#import "GuessView.h"
#import "FightingView.h"
#import "BySegmentView.h"
#import "LivePage.h"
#import "RespondModel.h"
#import "RaceModel.h"
#import "TimeUtil.h"
#import "BettingModel.h"
#import "InsetTextField.h"
#import "UserModel.h"
#import "AccountManager.h"
#import "BettingTpModel.h"
#import "ChatView.h"
#import "ImageBuuton.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "NormalAlertView.h"
#import "ChargePage2.h"
#import "GiftView.h"
#import "GiftModel.h"
#import "BySocket.h"
#import "MessageRespondModel.h"

#define TopHeight [PUtil getActualHeight:400]

@interface GuessPage ()<BySegmentViewDelegate,NormalAlertViewDelegate,GiftViewDelegate,BySocketDelegate>

@property (strong, nonatomic) UIImageView *aTeamImageView;
@property (strong, nonatomic) UILabel *aTeamLabel;
@property (strong, nonatomic) UIImageView *bTeamImageView;
@property (strong, nonatomic) UILabel *bTeamLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *gameLabel;
@property (strong, nonatomic) ImageBuuton *aTeamSupportBtn;
@property (strong, nonatomic) ImageBuuton *bTeamSupportBtn;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIView *guessOrderView;
@property (strong, nonatomic) UILabel *guessTitleLabel;
@property (strong, nonatomic) UILabel *coinLabel;
@property (strong, nonatomic) UIButton *guessBtn;
@property (strong, nonatomic) UIButton *liveBtn;
@property (strong, nonatomic) ChatView *chatView;
@property (strong, nonatomic) InsetTextField *coinTextField;
@property (strong, nonatomic) UIView *guessContentView;
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) UIButton *reduceBtn;
@property (strong, nonatomic) NormalAlertView *normalAlertView;
@property (strong, nonatomic) GiftView *giftView;

@end

@implementation GuessPage{
    RaceModel *raceModel;
    NSMutableArray *bettingTypeArray;
    NSMutableArray *buttons;
    BettingItemModel *selectModel;
    GuessView *selectGuessView;
    NSInteger mCurrentIndex;
    Boolean hasLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    raceModel = [[RaceModel alloc]init];
    bettingTypeArray = [[NSMutableArray alloc]init];
    buttons = [[NSMutableArray alloc]init];
    [self initView];
    [self requestDetail];
}

-(void)initView{
    [self initTopView];
    
}

-(void)initTopView{
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth,TopHeight);
    [self.view addSubview:topView];
    [ColorUtil setGradientColor:topView startColor:c01_blue endColor:c02_red director:Left];
    
    UIButton *backView = [[UIButton alloc]init];
    backView.frame = CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:20], [PUtil getActualHeight:48], [PUtil getActualHeight:48]);
    [backView setImage:[UIImage imageNamed:@"ic_back_24"] forState:UIControlStateNormal];
    [backView addTarget:self action:@selector(onBackPage) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backView];
    
    _aTeamImageView =[[UIImageView alloc]init];
    _aTeamImageView.layer.masksToBounds = YES;
    _aTeamImageView.contentMode = UIViewContentModeScaleAspectFit;
    _aTeamImageView.layer.cornerRadius = [PUtil getActualHeight:20];
    _aTeamImageView.frame = CGRectMake([PUtil getActualWidth:101], [PUtil getActualHeight:110], [PUtil getActualWidth:140], [PUtil getActualHeight:140]);
    [topView addSubview:_aTeamImageView];
    
    _aTeamLabel = [[UILabel alloc]init];
    _aTeamLabel.textColor = c08_text;
    _aTeamLabel.textAlignment = NSTextAlignmentCenter;
    _aTeamLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:32]];
    _aTeamLabel.frame = CGRectMake([PUtil getActualWidth:101], [PUtil getActualHeight:260], [PUtil getActualWidth:140], [PUtil getActualHeight:45]);
    [topView addSubview:_aTeamLabel];
    
    _bTeamImageView =[[UIImageView alloc]init];
    _bTeamImageView.layer.masksToBounds = YES;
    _bTeamImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bTeamImageView.layer.cornerRadius = [PUtil getActualHeight:20];
    _bTeamImageView.frame = CGRectMake([PUtil getActualWidth:509], [PUtil getActualHeight:110], [PUtil getActualWidth:140], [PUtil getActualHeight:140]);
    [topView addSubview:_bTeamImageView];
    
    _bTeamLabel = [[UILabel alloc]init];
    _bTeamLabel.textColor = c08_text;
    _bTeamLabel.textAlignment = NSTextAlignmentCenter;
    _bTeamLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:32]];
    _bTeamLabel.frame = CGRectMake([PUtil getActualWidth:509],  [PUtil getActualHeight:260], [PUtil getActualWidth:140], [PUtil getActualHeight:45]);
    [topView addSubview:_bTeamLabel];
    
    UILabel *vsLabel = [[UILabel alloc]init];
    vsLabel.textColor = c08_text;
    vsLabel.text = @"VS";
    vsLabel.textAlignment = NSTextAlignmentCenter;
    vsLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:72]];
    vsLabel.frame = CGRectMake(0 ,[PUtil getActualHeight:120], ScreenWidth, [PUtil getActualHeight:100]);
    [topView addSubview:vsLabel];
    
    _scoreLabel = [[UILabel alloc]init];
    _scoreLabel.textColor = c09_tips;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _scoreLabel.frame = CGRectMake(0 ,[PUtil getActualHeight:230], ScreenWidth, [PUtil getActualWidth:48]);
    [topView addSubview:_scoreLabel];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = c09_tips;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:22]];
    _timeLabel.frame = CGRectMake(0 ,[PUtil getActualHeight:60], ScreenWidth, [PUtil getActualHeight:33]);
    [topView addSubview:_timeLabel];
    
    _gameLabel = [[UILabel alloc]init];
    _gameLabel.textColor = c08_text;
    _gameLabel.textAlignment = NSTextAlignmentCenter;
    _gameLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
    _gameLabel.frame = CGRectMake(0 ,[PUtil getActualHeight:20], ScreenWidth, [PUtil getActualHeight:33]);
    [topView addSubview:_gameLabel];
    
    
    _aTeamSupportBtn = [[ImageBuuton alloc]initWithDirect:Direct_Left];
    [_aTeamSupportBtn setImage:[UIImage imageNamed:@"ic_support"] forState:UIControlStateNormal];
    _aTeamSupportBtn.frame = CGRectMake([PUtil getActualWidth:60], [PUtil getActualHeight:330], (ScreenWidth - [PUtil getActualWidth:120])/2, [PUtil getActualHeight:50]);
    _aTeamSupportBtn.backgroundColor = c01_blue;
    _aTeamSupportBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    UIBezierPath *leftMaskPath = [UIBezierPath bezierPathWithRoundedRect:_aTeamSupportBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake([PUtil getActualHeight:50]/2, [PUtil getActualHeight:50]/2)];
    CAShapeLayer *leftMaskLayer = [[CAShapeLayer alloc] init];
    leftMaskLayer.frame = _aTeamSupportBtn.bounds;
    leftMaskLayer.path = leftMaskPath.CGPath;
    _aTeamSupportBtn.layer.mask = leftMaskLayer;
    [_aTeamSupportBtn addTarget:self action:@selector(OnSupportA) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_aTeamSupportBtn];
    
    
    _bTeamSupportBtn = [[ImageBuuton alloc]initWithDirect:Direct_Right];
    [_bTeamSupportBtn setImage:[UIImage imageNamed:@"ic_support"] forState:UIControlStateNormal];
    _bTeamSupportBtn.frame = CGRectMake([PUtil getActualWidth:60] + (ScreenWidth - [PUtil getActualWidth:120])/2, [PUtil getActualHeight:330], (ScreenWidth - [PUtil getActualWidth:120])/2, [PUtil getActualHeight:50]);
    _bTeamSupportBtn.backgroundColor = c02_red;
    _bTeamSupportBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    UIBezierPath *rightMaskPath = [UIBezierPath bezierPathWithRoundedRect:_bTeamSupportBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake([PUtil getActualHeight:50]/2, [PUtil getActualHeight:50]/2)];
    CAShapeLayer *rightMaskLayer = [[CAShapeLayer alloc] init];
    rightMaskLayer.frame = _bTeamSupportBtn.bounds;
    rightMaskLayer.path = rightMaskPath.CGPath;
    _bTeamSupportBtn.layer.mask = rightMaskLayer;
    [_bTeamSupportBtn addTarget:self action:@selector(OnSupportB) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_bTeamSupportBtn];
    
}

-(void)initBodyView{
    
    _liveBtn = [[UIButton alloc]init];
    _liveBtn.frame = CGRectMake([PUtil getActualWidth:590], StatuBarHeight + [PUtil getActualHeight:30],[PUtil getActualWidth:140] , [PUtil getActualHeight:60]);
    [_liveBtn setTitle:@"分享" forState:UIControlStateNormal];
    _liveBtn.layer.masksToBounds = YES;
    _liveBtn.backgroundColor = c01_blue;
    _liveBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _liveBtn.layer.cornerRadius = [PUtil getActualHeight:60]/2;
    [_liveBtn addTarget:self action:@selector(goLivePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_liveBtn];
    
    NSMutableArray *viewArray = [[NSMutableArray alloc]init];
    GuessView *guessView = [[GuessView alloc]initWithDatas:bettingTypeArray raceid:raceModel.race_id end:_isEnd];
    guessView.delegate = self;
    [viewArray addObject:guessView];
    
    _chatView = [[ChatView alloc]initWithRoomId:[NSString stringWithFormat:@"%ld",_race_id]];
    [viewArray addObject:_chatView];
    NSArray *titleArray = @[@"竞猜",@"聊天"];
    BySegmentView *segmentView = [[BySegmentView alloc]initWithFrame:CGRectMake(0, TopHeight+StatuBarHeight, ScreenWidth, ScreenHeight - TopHeight-StatuBarHeight) andTitleArray:titleArray andShowControllerNameArray:viewArray];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    
    [self initSocket];
    [self initGuessOrderView];
    
    
}


-(void)initGuessOrderView{
    _guessOrderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _guessOrderView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.75];
    _guessOrderView.hidden = YES;
    UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CloseGuessOrderView)];
    [_guessOrderView addGestureRecognizer:recongnizer];
    [self.view addSubview:_guessOrderView];
    
    _guessContentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, [PUtil getActualHeight:440])];
    _guessContentView.backgroundColor = c07_bar;
    [_guessOrderView addSubview:_guessContentView];
    
    //    UIButton *closeBtn = [[UIButton alloc]init];
    //    [closeBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    //    closeBtn.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:70], [PUtil getActualHeight:30], [PUtil getActualWidth:40], [PUtil getActualWidth:40]);
    //    [closeBtn addTarget:self action:@selector(CloseGuessOrderView) forControlEvents:UIControlEventTouchUpInside];
    //    [_guessContentView addSubview:closeBtn];
    
    _guessTitleLabel = [[UILabel alloc]init];
    _guessTitleLabel.text = @"竞猜0，猜中可得0竞猜币";
    _guessTitleLabel.textColor = c08_text;
    _guessTitleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _guessTitleLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30], [PUtil getActualWidth:500],  [PUtil getActualHeight:28]);
    [_guessContentView addSubview:_guessTitleLabel];
    
    _coinLabel = [[UILabel alloc]init];
    _coinLabel.text = @"余额：123123";
    _coinLabel.textColor = c03_yellow;
    _coinLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _coinLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:80], [PUtil getActualWidth:500],  [PUtil getActualHeight:28]);
    [_guessContentView addSubview:_coinLabel];
    
    int controlBtnWidth = [PUtil getActualWidth:115];
    _reduceBtn = [[UIButton alloc]init];
    _reduceBtn.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:140], controlBtnWidth,  [PUtil getActualHeight:60]);
    _reduceBtn.backgroundColor = c01_blue;
    [_reduceBtn setTitle:@"-10" forState:UIControlStateNormal];
    [_reduceBtn setTitleColor:c08_text forState:UIControlStateNormal];
    _reduceBtn.layer.cornerRadius = [PUtil getActualHeight:10];
    [_reduceBtn addTarget:self action:@selector(onClickReduceBtn) forControlEvents:UIControlEventTouchUpInside];
    [_guessContentView addSubview:_reduceBtn];
    
    _addBtn = [[UIButton alloc]init];
    _addBtn.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:30] - controlBtnWidth,[PUtil getActualHeight:140] , controlBtnWidth,  [PUtil getActualHeight:60]);
    _addBtn.backgroundColor = c01_blue;
    _addBtn.layer.cornerRadius = [PUtil getActualHeight:10];
    [_addBtn setTitle:@"+10" forState:UIControlStateNormal];
    [_addBtn setTitleColor:c08_text forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(onClickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    [_guessContentView addSubview:_addBtn];
    
    _coinTextField = [[InsetTextField alloc]initWithFrame: CGRectMake([PUtil getActualWidth:160], [PUtil getActualHeight:140], ScreenWidth - [PUtil getActualWidth:320], [PUtil getActualHeight:60]) andInsets:UIEdgeInsetsMake(0, [PUtil getActualWidth:16], 0, [PUtil getActualWidth:16]) hint:@""];
    _coinTextField.text = @"10";
    _coinTextField.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _coinTextField.textColor = c08_text;
    _coinTextField.returnKeyType = UIReturnKeyDone;
    _coinTextField.keyboardType = UIKeyboardTypeNumberPad;
    _coinTextField.layer.masksToBounds = YES;
    _coinTextField.layer.borderColor = c01_blue.CGColor;
    _coinTextField.layer.borderWidth = 1;
    _coinTextField.layer.cornerRadius = [PUtil getActualHeight:10];
    [_guessContentView addSubview:_coinTextField];
    [_coinTextField check];
    
    int width = (ScreenWidth - [PUtil getActualWidth:120])/4;
    for(int i = 0 ; i < 4 ;i ++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake([PUtil getActualWidth:30] +( width + [PUtil getActualWidth:20])*i, [PUtil getActualHeight:220], width, [PUtil getActualHeight:60])];
        button.tag = i;
        NSString *title;
        switch (i) {
            case 0:
                title = @"100";
                break;
            case 1:
                title = @"500";
                break;
            case 2:
                title = @"1000";
                break;
            case 3:
                title = @"5000";
                break;
            default:
                break;
        }
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:c08_text forState:UIControlStateNormal];
        button.layer.cornerRadius = [PUtil getActualHeight:10];
        button.layer.borderWidth = 1;
        button.layer.borderColor = c01_blue.CGColor;
        [button addTarget:self action:@selector(OnGuessBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
        [_guessContentView addSubview:button];
    }
    
    _guessBtn  = [[UIButton alloc]init];
    _guessBtn.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:310],ScreenWidth - [PUtil getActualWidth:30]*2 , [PUtil getActualHeight:110]);
    [_guessBtn setTitle:@"立即竞猜" forState:UIControlStateNormal];
    _guessBtn.layer.masksToBounds = YES;
    _guessBtn.layer.cornerRadius = [PUtil getActualHeight:10];
    [_guessBtn addTarget:self action:@selector(requestGuess) forControlEvents:UIControlEventTouchUpInside];
    [_guessContentView addSubview:_guessBtn];
    [ColorUtil setGradientColor:_guessBtn startColor:c01_blue endColor:c02_red director:Left];
    
}
    


-(void)didSelectIndex:(NSInteger)index{
    mCurrentIndex = index;
    if(index == 0){
        [_liveBtn setTitle:@"分享" forState:UIControlStateNormal];
        [UMUtil clickEvent:EVENT_GAME_TAB_GUESS];
    }else{
        [_liveBtn setTitle:@"直播" forState:UIControlStateNormal];
        [UMUtil clickEvent:EVENT_GAME_TAB_CHAT];
    }
}
-(void)OpenGuessOrderView:(BettingItemModel *)model guessView:(GuessView *)guessView{
    selectModel = model;
    selectGuessView = guessView;
    _guessOrderView.hidden = NO;
    UserModel *userModel = [[AccountManager sharedAccountManager]getUserInfo];
    _coinLabel.text = [NSString stringWithFormat:@"余额：%@",userModel.coin];
    __weak UIView *tempView  = _guessContentView;
    [UIView animateWithDuration:0.3f animations:^{
        tempView.frame = CGRectMake(0,  ScreenHeight- [PUtil getActualHeight:440], ScreenWidth, ScreenHeight);
    }];
}

-(void)CloseGuessOrderView{
    [_coinTextField resignFirstResponder];
    __weak UIView *tempView  = _guessContentView;
    [UIView animateWithDuration:0.3f animations:^{
        tempView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        _guessOrderView.hidden = YES;
        if(selectGuessView){
            [selectGuessView restoreItems];
        }
        for(UIButton *tempBtn in buttons){
            tempBtn.backgroundColor = [UIColor clearColor];
        }
        _guessTitleLabel.text = @"竞猜0，猜中可得0竞猜币";
        
    }];
    [UMUtil clickEvent:EVENT_GAME_CLOSE_GUESS];
}

-(void)onBackPage{
    [[BySocket sharedBySocket]disconnect];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goLivePage{
    if(mCurrentIndex == 0){
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"分享"
                                                                       message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 [UMUtil clickEvent:EVENT_GAME_SHARE_CANCEL];
                                                             }];
        UIAlertAction* sceneAction = [UIAlertAction actionWithTitle:@"分享给微信好友" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                [UMUtil clickEvent:EVENT_GAME_SHARE_FRIEND];
                                                                [self doShare : WXSceneSession];
                                                            }];
        UIAlertAction* timelineAction = [UIAlertAction actionWithTitle:@"分享到朋友圈" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [UMUtil clickEvent:EVENT_GAME_SHARE_TIMELINE];
                                                                   [self doShare : WXSceneTimeline];
                                                                   
                                                               }];
        [alert addAction:sceneAction];
        [alert addAction:timelineAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }else{
        LivePage *page = [[LivePage alloc]init];
        [self pushPage:page];
        [UMUtil clickEvent:EVENT_GAME_LIVE];
        
    }
}

-(void)doShare : (int)scene{
    [UMUtil clickEvent:EVENT_GAME_SHARE];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"gogo电竞";
    message.description = @"快来一起参加王者荣耀竞猜吧！";
    [message setThumbImage:[UIImage imageNamed:@"etc_logo_200"]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"http://www.scrats.cn/";
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
    
}

-(void)requestDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%ld",API_GUESS_DETAIL,_race_id];
    [ByNetUtil get:requestUrl parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            id race = [data objectForKey:@"race"];
            raceModel = [RaceModel mj_objectWithKeyValues:race];
            id betting_tps = [data objectForKey:@"betting_tps"];
            bettingTypeArray = [BettingTpModel mj_objectArrayWithKeyValuesArray:betting_tps];
            if(hasLoad){
                [self updateSupportBtn];
            }else{
                [self updateTopView];
                hasLoad = YES;
            }
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)updateTopView{
    TeamModel *aTeamModel = [TeamModel mj_objectWithKeyValues:raceModel.team_a];
    TeamModel *bTeamModel = [TeamModel mj_objectWithKeyValues:raceModel.team_b];
    _aTeamLabel.text = aTeamModel.team_name;
    _bTeamLabel.text = bTeamModel.team_name;
    _scoreLabel.text = [NSString stringWithFormat:@"%@ : %@",raceModel.score_a,raceModel.score_b];
    [_aTeamImageView sd_setImageWithURL:[NSURL URLWithString:aTeamModel.logo]];
    [_bTeamImageView sd_setImageWithURL:[NSURL URLWithString:bTeamModel.logo]];
    _timeLabel.text = [TimeUtil generateAll:raceModel.race_ts];
    _gameLabel.text = raceModel.race_name;
    
    [self updateSupportBtn];
    [self initBodyView];
}

-(void)updateSupportBtn{
    int aGiftCount = [self getGiftCount:raceModel.team_a_gift];
    int bGiftCount = [self getGiftCount:raceModel.team_b_gift];
    float percent = ((float)aGiftCount / (float)(aGiftCount + bGiftCount)) * 100;
    if(aGiftCount + bGiftCount == 0){
        percent = 50;
    }
    [_aTeamSupportBtn setTitle:[NSString stringWithFormat:@"%.2f%@",percent,@"%"] forState:UIControlStateNormal];
    [_bTeamSupportBtn setTitle:[NSString stringWithFormat:@"%.2f%@",100-percent,@"%"] forState:UIControlStateNormal];
}

-(int)getGiftCount:(NSMutableArray *)datas{
    int count = 0;
    for(id aGiftModel in datas){
        GiftModel *giftModel = [GiftModel mj_objectWithKeyValues:aGiftModel];
        switch (giftModel.coin_plan_id) {
            case 1:
                count +=giftModel.total_gift*6;
                break;
            case 2:
                count +=giftModel.total_gift*30;
                break;
            case 3:
                count +=giftModel.total_gift*68;
                break;
            case 4:
                count +=giftModel.total_gift*128;
                break;
            default:
                break;
        }
    }
    return count;
}

-(void)OnGuessBtnSelect : (id)sender{
    UIButton *button = sender;
    UserModel *userModel = [[AccountManager sharedAccountManager]getUserInfo];
    int coin = 0;
    switch (button.tag) {
        case 0:
            coin = 100;
            break;
        case 1:
            coin = 500;
            break;
        case 2:
            coin = 1000;
            break;
        case 3:
            coin = 5000;
            break;
        default:
            break;
    }
    _coinTextField.text =[NSString stringWithFormat:@"%d",coin];
    [_coinTextField check];
    if([userModel.coin intValue] < coin){
        [DialogHelper showFailureAlertSheet:@"余额不足"];
        return;
    }
    for(UIButton *tempBtn in buttons){
        tempBtn.backgroundColor = [UIColor clearColor];
    }
    button.backgroundColor = c01_blue;
    _guessTitleLabel.text = [NSString stringWithFormat:@"竞猜%d， 猜中可得%.f竞猜币",coin,coin *  [selectModel.odds floatValue]];
}

-(void)getUserInfo{
    [ByNetUtil get:API_USERINFO parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            UserModel *userModel = [UserModel mj_objectWithKeyValues:data];
            [[AccountManager sharedAccountManager]saveUserInfo:userModel];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

//立即竞猜
-(void)requestGuess{
    
    [UMUtil clickEvent:EVENT_GAME_GUESS];
    if(IS_NS_STRING_EMPTY(_coinTextField.text)){
        [DialogHelper showWarnTips:@"请输入竞猜金额"];
        return;
    }
    NSString *coinStr = _coinTextField.text;
    int coin = [coinStr intValue];
    if(coin < 10){
        [DialogHelper showWarnTips:@"投注金额必须大于10"];
        return;
    }
    
    if(coin > 100000){
        [DialogHelper showWarnTips:@"最大投注额为100000"];
        return;
    }
    
    UserModel *userModel = [[AccountManager sharedAccountManager]getUserInfo];
    if([userModel.coin intValue] < coin){
        [_coinTextField resignFirstResponder];
        _normalAlertView = [[NormalAlertView alloc]initWithTitle:@"投注失败，竞猜币不足" content:@"是否去购买礼物?"];
        _normalAlertView.delegate = self;
        [self.view addSubview:_normalAlertView];
        return;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:@(selectModel.betting_item_id)];
    
    NSLog(@"竞猜%@",coinStr);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"coin"] = coinStr;
    dic[@"betting_item_id_list"] = array;
    
    [ByNetUtil post:API_GUESS content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [self getUserInfo];
            [self CloseGuessOrderView];
            [DialogHelper showSuccessTips:@"投注成功"];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:_coinTextField];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    if(_chatView){
        [_chatView keyboardWillChangeFrame:notification];
    }
    if(_coinTextField){
        [_coinTextField check];
        NSDictionary *info = [notification userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
        CGRect rect = _guessContentView.frame;
        rect.origin.y += yOffset;
        __weak UIView *view = _guessContentView;
        [UIView animateWithDuration:duration animations:^{
            view.frame = rect;
        }];
    }
}


#pragma mark 竞猜币-10
-(void)onClickReduceBtn{
    int coin = [_coinTextField.text intValue];
    coin -=10;
    if(coin >= 0){
        _coinTextField.text = [NSString stringWithFormat:@"%d",coin];
    }else{
        return;
    }
    [_coinTextField check];
    _guessTitleLabel.text = [NSString stringWithFormat:@"竞猜%d， 猜中可得%.f竞猜币",coin,coin *  [selectModel.odds floatValue]];
}

#pragma mark 竞猜币+10
-(void)onClickAddBtn{
    int coin = [_coinTextField.text intValue];
    coin +=10;
    _coinTextField.text = [NSString stringWithFormat:@"%d",coin];
    [_coinTextField check];
    _guessTitleLabel.text = [NSString stringWithFormat:@"竞猜%d， 猜中可得%.f竞猜币",coin,coin *  [selectModel.odds floatValue]];
}

#pragma mark 监听输入变化
-(void)textFieldTextDidChange:(NSNotification *)notification{
    UITextField *textfield=[notification object];
    int coin = [textfield.text intValue];
    _guessTitleLabel.text = [NSString stringWithFormat:@"竞猜%d， 猜中可得%.f竞猜币",coin,coin *  [selectModel.odds floatValue]];
    for(UIButton *tempBtn in buttons){
        tempBtn.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark 跳转到充值
-(void)OnOkBtnClick{
    if(_normalAlertView){
        [_normalAlertView removeFromSuperview];
    }
    ChargePage2 *page = [[ChargePage2 alloc]init];
    [self pushPage:page];
    [UMUtil clickEvent:EVENT_GAME_CONFIRM_NOMONEY];
    
}

#pragma mark 支持A队
-(void)OnSupportA{
    [self showGiftView:raceModel.team_a];
}

#pragma mark 支持B队
-(void)OnSupportB{
    [self showGiftView:raceModel.team_b];
}

#pragma mark 打开赠送礼物页面
-(void)showGiftView : (TeamModel *)teamModel{
    _giftView = [[GiftView alloc]initWithModel:teamModel raceId:raceModel.race_id];
    _giftView.delegate = self;
    [self.view addSubview:_giftView];
    [_giftView show];
}

#pragma mark 礼物数量不足，跳转充值
-(void)goChargePage{
    ChargePage2 *page = [[ChargePage2 alloc]init];
    [self pushPage:page];
}

#pragma mark 赠送礼物成功
-(void)sendGiftSuccess{
    [self requestDetail];
}

    
#pragma mark 聊天部分
-(void)initSocket{
    BySocket *socket =  [BySocket sharedBySocket];
    [socket initWithUrl:@"http://gogo.scrats.cn"];
    socket.socketDelegate = self;
    [socket connect];
}

-(void)OnReceiveMsgCallback:(MessageRespondModel *)model{
    switch (model.type) {
        case MY_JOIN:
            [self handleMyJoin:model];
            break;
        case OTHER_JOIN:
            [self handleOtherJoin:model];
            break;
        case LEAVE:
            [self handleLeave:model];
            break;
        case MSG:
            [self handleMsg:model];
            break;
        case HISTORY:
            [self handleHistoryMsg:model];
            break;
        default:
            break;
    }
}
    
-(void)handleMyJoin:(MessageRespondModel *)respondModel{
    MessageModel *model = [MessageRespondModel parseMessage:respondModel];
    [_chatView setIndex:model.msg_index];
    [ByLog print:@"当前msgid" content: model.msg_index];
    [ByLog print:@"自己加入房间"];
}
    
-(void)handleOtherJoin:(MessageRespondModel *)respondModel{
    [ByLog print:@"别人加入房间"];
}
    
-(void)handleLeave:(MessageRespondModel *)respondModel{
    [ByLog print:@"离开房间"];
}
    
-(void)handleMsg:(MessageRespondModel *)respondModel{
    [ByLog print:@"收到消息"];
    MessageTextModel *model = [MessageRespondModel parseTextMessage:respondModel];
    [_chatView addMessage:model];
//    [[BySocket sharedBySocket] queryMsg:@"123" index:@"10" size:5];
}
    
-(void)handleHistoryMsg:(MessageRespondModel *)respondModel{
    [ByLog print:@"收到历史消息"];
    NSMutableArray *datas = [MessageRespondModel parseHistoryMessage:respondModel];
    for(id data in datas){
        MessageTextModel *model = [MessageTextModel mj_objectWithKeyValues:data];
        [ByLog print:model.chat_id content:model.msg];
    }
    [_chatView addHistoryMessage:datas];
}
    
    
-(void)OnSocketConnectStatu:(Boolean)statu{
    if(statu){
        [[BySocket sharedBySocket]joinRoom:[NSString stringWithFormat:@"%ld",_race_id]];
    }else{
        [DialogHelper showFailureAlertSheet:@"连接超时，请重新进入房间"];
    }
}
    
@end
