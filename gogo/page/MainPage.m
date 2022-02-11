//
//  MainPage.m
//  gogo
//
//  Created by by.huang on 2017/10/22.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "MainPage.h"
#import "BottomView.h"
#import "HomeView.h"
#import "GamePage.h"
#import "MallPage.h"
#import "MineView.h"
#import "NewsDetailPage.h"
#import "ScheduleDetailPage.h"
#import "CorpsDetailPage.h"
#import "LoginPage.h"
#import "ChargePage2.h"
#import "AddressPage.h"
#import "GuessHistoryPage.h"
#import "ExchangePage.h"
#import "AboutPage.h"
#import "PersonalPage.h"
#import "GuessPage.h"
#import "GoodsDetailPage.h"
#import "RespondModel.h"
#import "UserModel.h"
#import "AccountManager.h"
#import "SettingPage.h"
#import <AVKit/AVKit.h>
#import "SignView2.h"
#import "GiftModel.h"

#define TitleHeight [PUtil getActualHeight:88]

@interface MainPage ()<BottomViewDelegate,MainHandleDelegate,SignView2Delegate>

@property (strong, nonatomic) UILabel *mTitleLabel;
@property (strong, nonatomic) UIView  *mBodyView;
@property (strong, nonatomic) MineView *mineView;
@property (strong, nonatomic) HomeView *homeView;
@property (strong, nonatomic) UIButton *signBtn;
@property (strong, nonatomic) BottomView *bottomView;

@end

@implementation MainPage
{
    NSArray * titles;
    NSArray * images;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    [self getSignStatu];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserInfo];
}


//切换到后台
- (void)appWillResignActive:(NSNotification *)notification{
    if(_homeView){
        [_homeView appWillResignActive];
    }
}

//切换回前台
- (void)appBecomeActive:(NSNotification *)notification{
    
}

//播放结束
- (void)videoPlayEnd{
    if(_homeView){
        [_homeView videoPlayEnd];
    }
}

-(void)initView{
    titles = @[@"首页",@"赛事",@"商城",@"我的"];
    images =@[@"ic_home_0_24",@"ic_home_1_24",@"ic_game_0_24",@"ic_game_1_24",@"ic_store_0_24",@"ic_store_1_24",@"ic_me_0_24",@"ic_me_1_24"];
    [self initBar];
    [self initBody];
    [self initBottom];
    [self addHomePage];
}

-(void)initBar{
//    [self setStatuBarBackgroud:c07_bar];
    _mTitleLabel = [[UILabel alloc]init];
    _mTitleLabel.backgroundColor = c07_bar;
    _mTitleLabel.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, TitleHeight);
    _mTitleLabel.text = @"首页";
    _mTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    _mTitleLabel.textColor = c08_text;
    _mTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_mTitleLabel];
    
    _signBtn = [[UIButton alloc]init];
    _signBtn.frame = CGRectMake(0, StatuBarHeight , [PUtil getActualWidth:150], TitleHeight);
    [_signBtn addTarget:self action:@selector(showSignView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signBtn];
    
    UIImageView *signImageView = [[UIImageView alloc]init];
    UIImage *signImage = [UIImage imageNamed:@"ic_checkin_16"];
    signImageView.image = signImage;
    signImageView.frame = CGRectMake([PUtil getActualWidth:21], (TitleHeight-signImage.size.height)/2, signImage.size.width, signImage.size.height);
    [_signBtn addSubview:signImageView];
    
    UILabel *signLabel = [[UILabel alloc]init];
    signLabel.text = @"签到";
    signLabel.textColor = c09_tips;
    signLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.frame = CGRectMake([PUtil getActualWidth:62], 0, signLabel.contentSize.width, TitleHeight);
    [_signBtn addSubview:signLabel];
}

-(void)initBody{
    _mBodyView = [[UIView alloc]init];
    _mBodyView.frame = CGRectMake(0, StatuBarHeight + TitleHeight, ScreenWidth, ScreenHeight - ( StatuBarHeight + TitleHeight + [PUtil getActualHeight:100]));
    [self.view addSubview:_mBodyView];
}

-(void)initBottom{
    _bottomView = [[BottomView alloc]initWithTitles:titles images:images delegate:self];
    [self.view addSubview:_bottomView];
}


-(void)OnTabSelected:(NSInteger)index{
    if(_homeView){
        [_homeView restore];
    }
    [self removeBodySubView];
    _mTitleLabel.text = [titles objectAtIndex:index];
    switch (index) {
        case 0:
            [self addHomePage];
            break;
        case 1:
            [self addGamePage];
            break;
        case 2:
            [self addMallPage];
            break;
        case 3:
            [self addMinePage];
            break;
        default:
            break;
    }
    
}


#pragma mark 移除所有UI
-(void)removeBodySubView{
    for(UIView *view in [_mBodyView subviews]){
        [view removeFromSuperview];
    }
}

#pragma mark 添加首页
-(void)addHomePage{
    _signBtn.hidden = NO;
    _homeView = [[HomeView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, _mBodyView.mj_h)];
    _homeView.handleDelegate = self;
    _homeView.vc = self;
    [_mBodyView addSubview:_homeView];
    [UMUtil clickEvent:EVENT_HOME];
}

#pragma mark 添加赛事
-(void)addGamePage{
    _signBtn.hidden = YES;
    GamePage *gamepage  = [[GamePage alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, _mBodyView.mj_h)];
    gamepage.handleDelegate = self;
    [_mBodyView addSubview:gamepage];
    [UMUtil clickEvent:EVENT_GAME];
}

#pragma mark 添加商城
-(void)addMallPage{
    _signBtn.hidden = YES;
    MallPage *mallpage = [[MallPage alloc]init];
    mallpage.handleDelegate = self;
    [_mBodyView addSubview:mallpage.view];
    [UMUtil clickEvent:EVENT_MALL];

}

#pragma mark 添加我的
-(void)addMinePage{
    _signBtn.hidden = YES;
    _mineView = [[MineView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, _mBodyView.mj_h)];
    _mineView.handleDelegate = self;
    [_mBodyView addSubview:_mineView];
    [UMUtil clickEvent:EVENT_MINE];
}


#pragma mark 跳转到新闻详细页
-(void)goNewsDetailPage:(NewsModel *)model{
    NewsDetailPage *page = [[NewsDetailPage alloc]init];
    page.newsModel = model;
    [self pushPage:page];
}

#pragma mark 跳转到赛事安排详细页
-(void)goScheduleDetailPage : (long)nid{
    ScheduleDetailPage *page = [[ScheduleDetailPage alloc]init];
    [self pushPage:page];
}

#pragma mark 跳转到战队详细页
-(void)goCorpsDetailPage : (long)nid{
    CorpsDetailPage *page = [[CorpsDetailPage alloc]init];
    page.team_id = nid;
    [self pushPage:page];
}

#pragma mark 跳转到登录页
-(void)goLoginPage{
    LoginPage *page = [[LoginPage alloc]init];
    [self pushPage:page];
}

#pragma mark 跳转到充值页
-(void)goChargePage{
    ChargePage2 *page = [[ChargePage2 alloc]init];
    [self pushPage:page];
}

#pragma mark 跳转到地址信息
-(void)goAddressPage{
    AddressPage *page = [[AddressPage alloc]init];
    [self pushPage:page];
}

#pragma mark 跳转竞猜历史
-(void)goHistoryPage{
    GuessHistoryPage *page = [[GuessHistoryPage alloc]init];
    [self pushPage:page];
}

#pragma mark 跳转到兑换记录
-(void)goExchangePage{
    ExchangePage *page = [[ExchangePage alloc]init];
    [self pushPage:page];
}

#pragma mark 跳转到设置
-(void)goSettingPage{
    SettingPage *page = [[SettingPage alloc]init];
    [self pushPage:page];
}

#pragma mark 跳转到个人信息
-(void)goPersonalPage{
    PersonalPage *page = [[PersonalPage alloc]init];
    [self pushPage:page];
    [UMUtil clickEvent:EVENT_USERINFO];
}

#pragma mark 跳转到竞猜
-(void)goGuessPage:(long)race_id end:(Boolean)isEnd{
    GuessPage *page = [[GuessPage alloc]init];
    page.race_id = race_id;
    page.isEnd = isEnd;
    [self pushPage:page];
}

#pragma mark 跳转到商品详情
-(void)goGoodsDetailPage:(long)nid{
    GoodsDetailPage *page = [[GoodsDetailPage alloc]init];
    page.goods_id = nid;
    [self pushPage:page];
}



-(void)getUserInfo{
    [ByNetUtil get:API_USERINFO parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            UserModel *userModel = [UserModel mj_objectWithKeyValues:data];
            for(GiftModel *temp in userModel.coin_gift){
                GiftModel *model = [GiftModel mj_objectWithKeyValues:temp];
                NSLog(@"%@",model.gift_name);
            }
            [[AccountManager sharedAccountManager]saveUserInfo:userModel];
            if(_mineView){
                [_mineView updateUserInfo];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 显示签到UI
-(void)showSignView{
    NSLog(@"点击签到");
    [UMUtil clickEvent:EVENT_SIGN];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self doRequestSign];
//    SignView *signView =[[SignView alloc]init];
//    signView.delegate = self;
//    [self.view addSubview:signView];
}

-(void)OnSignSuccess{
    [_signBtn setTitle:@"今日已签到" forState:UIControlStateNormal];
    _signBtn.backgroundColor = c02_red;
    _signBtn.enabled = NO;
}

-(void)getSignStatu{
    [ByNetUtil get:API_SIGN_STATU parameters:nil success:^(RespondModel *model) {
        if(model.code == 200){
            id data = model.data;
            id sign = [data objectForKey:@"sign_in"];
            bool statu = [[sign objectForKey:@"has_sign"] boolValue];
            if(statu){
                [self OnSignSuccess];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)goGamePage{
    if(_bottomView){
        [_bottomView gameClick];
    }
}

-(void)doRequestSign{
    int tempCoins = [[[AccountManager sharedAccountManager]getUserInfo].coin intValue];
    [ByNetUtil get:API_SIGN parameters:nil success:^(RespondModel *model) {
        if(model.code == 200){
            id data = model.data;
            id sign = [data objectForKey:@"sign_in"];
            long coins = [[data objectForKey:@"coin"] longValue];
//            bool statu = [[sign objectForKey:@"has_sign"] boolValue];
            if((coins-tempCoins) == 0){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [DialogHelper showFailureAlertSheet:@"您今天已经签过到了哦！"];
                return;
            }
            int day = [[sign objectForKey:@"day"] intValue];
            SignView2 *signView = [[SignView2 alloc]initWithCoin:coins-tempCoins withDay:day];
            signView.delegate = self;
            [self.view addSubview:signView];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
            
        }
        [DialogHelper showFailureAlertSheet:model.msg];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [DialogHelper showFailureAlertSheet:@"签到失败，请重试"];
    }];
    
}

-(void)OnGuessClicked{
    [UMUtil clickEvent:EVENT_SIGN_GUESS];
    [self goGamePage];
}
@end
