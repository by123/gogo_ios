//
//  MinePage.h
//  gogo
//
//  Created by by.huang on 2017/10/22.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "MainPage.h"


@interface MineView : UIView

@property (weak, nonatomic) id<MainHandleDelegate> handleDelegate;

-(void)updateUserInfo;

@end
