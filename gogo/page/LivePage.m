//
//  LivePage.m
//  gogo
//
//  Created by by.huang on 2017/10/30.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "LivePage.h"
#import "BarView.h"

@interface LivePage ()

@property (strong, nonatomic) BarView *barView;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation LivePage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    _barView = [[BarView alloc]initWithTitle:@"直播" page:self];
    [self.view addSubview:_barView];
    
    _webView = [[UIWebView alloc]init];
    _webView.frame = CGRectMake(0, [PUtil getActualHeight:88]+StatuBarHeight, ScreenWidth, ScreenHeight - ([PUtil getActualHeight:88]+StatuBarHeight));
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:_webView];
    
    [self loadWebView:@"http://pvp.qq.com/match/kpl/"];
    
    
}

- (void)loadWebView:(NSString *)str{
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
