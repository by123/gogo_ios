//
//  FeedbackPage.m
//  gogo
//
//  Created by by.huang on 2017/11/23.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "FeedbackPage.h"
#import "BarView.h"

@interface FeedbackPage ()

@property (strong, nonatomic) BarView *barView;

@end

@implementation FeedbackPage{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    _barView = [[BarView alloc]initWithTitle:@"意见反馈" page:self];
    [self.view addSubview:_barView];
}

@end
