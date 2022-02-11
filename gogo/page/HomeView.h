//
//  OnePage.h
//  gogo
//
//  Created by by.huang on 2017/9/19.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "SDCycleScrollView.h"
#import "MainPage.h"

@interface HomeView : UIView<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) id<MainHandleDelegate> handleDelegate;

@property (strong, nonatomic) BaseViewController *vc;

-(void)appWillResignActive;

-(void)videoPlayEnd;

-(void)restore;

@end
