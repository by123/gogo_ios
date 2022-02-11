//
//  BaseViewController.h
//  gogo
//
//  Created by by.huang on 2017/9/11.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


-(void)hideNavigationBar : (Boolean) hidden;

-(void)setStatuBarBackgroud : (UIColor *)color;

-(void)pushPage : (BaseViewController *)targetPage;

-(void)setRedBlueStatuBar;

-(void)goLoginPage;

@end
