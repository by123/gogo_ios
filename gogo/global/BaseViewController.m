//
//  BaseViewController.m
//  gogo
//
//  Created by by.huang on 2017/9/11.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginPage.h"
#import "RespondModel.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroud];
    [self hideNavigationBar:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *className = [NSString stringWithFormat:@"%s",class_getName(self.class)];
    [MobClick beginLogPageView:className];
    NSLog(@"当前页面->%@",className);
}

-(void)viewWillDisappear:(BOOL)animated{
    NSString *className = [NSString stringWithFormat:@"%s",class_getName(self.class)];
    [MobClick endLogPageView:className];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)setBackgroud{
    self.view.backgroundColor = c06_backgroud;
}


-(void)hideNavigationBar : (Boolean) hidden{
    self.navigationController.navigationBarHidden = hidden;
}


-(void)setStatuBarBackgroud : (UIColor *)color{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)setRedBlueStatuBar{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        [ColorUtil setGradientColor:statusBar startColor:c01_blue endColor:c02_red director:Left];
    }
}


-(void)pushPage:(BaseViewController *)targetPage{
    [self.navigationController pushViewController:targetPage animated:YES];
}


-(void)goLoginPage{
    [DialogHelper showSuccessTips:@"正在重新登录，请稍后"];
    [ByNetUtil refreshToken:^(id data) {
        RespondModel *model = data;
        if(model.code == 404){
            [DialogHelper showSuccessTips:@"登录失败，请重新登录"];
            LoginPage *page = [[LoginPage alloc]init];
            [self pushPage:page];
        }else{
            [DialogHelper showSuccessTips:@"登录成功!"];
        }
    }];

}




@end
