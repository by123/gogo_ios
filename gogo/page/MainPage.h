//
//  MainPage.h
//  gogo
//
//  Created by by.huang on 2017/10/22.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "SignView.h"
#import "NewsModel.h"

@protocol MainHandleDelegate <NSObject>

@optional -(void)goNewsDetailPage : (NewsModel *)model;

@optional -(void)goScheduleDetailPage : (long)nid;

@optional -(void)goCorpsDetailPage : (long)nid;

@optional -(void)goLoginPage;

@optional -(void)goChargePage;

@optional -(void)goAddressPage;

@optional -(void)goHistoryPage;

@optional -(void)goExchangePage;

@optional -(void)goSettingPage;

@optional -(void)goPersonalPage;

@optional -(void)goGuessPage : (long)race_id end:(Boolean)isEnd;

@optional -(void)goGoodsDetailPage : (long)nid;

@optional -(void)updateUserInfo;

@optional -(void)goGamePage;

//@optional -(void)showSignView : (id<SignViewDelegate>)delegate;


@end

@interface MainPage : BaseViewController

@property (weak, nonatomic) id<MainHandleDelegate> handleDelegate;

@end
