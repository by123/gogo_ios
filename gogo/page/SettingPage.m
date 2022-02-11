//
//  SettingPage.m
//  gogo
//
//  Created by by.huang on 2017/11/23.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "SettingPage.h"
#import "BarView.h"
#import "TouchScrollView.h"
#import "MineCell.h"
#import "AboutPage.h"
#import "FeedbackPage.h"

@interface SettingPage ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BarView *barView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SettingPage{
    NSArray *datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    datas = @[@"意见反馈",@"关于"];
    [self initView];
}

-(void)initView{
    _barView = [[BarView alloc]initWithTitle:@"设置" page:self];
    [self.view addSubview:_barView];
    [self initBody];
}

-(void)initBody{
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, _barView.mj_h + _barView.mj_y+10, ScreenWidth, [datas count]*[PUtil getActualHeight:110]);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [datas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PUtil getActualHeight:110];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goPage : indexPath.row];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell *cell =  [tableView dequeueReusableCellWithIdentifier:[MineCell identify]];
    if(cell == nil){
        cell = [[MineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MineCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row == [datas count]-1){
        [cell setData:[datas objectAtIndex:indexPath.row] hideline:YES];
    }else{
        [cell setData:[datas objectAtIndex:indexPath.row] hideline:NO];
    }
    return cell;
}


-(void)goPage : (NSInteger)index{
    switch (index) {
        case 0:
            [self goFeedbackPage];
            break;
        case 1:
            [self goAboutPage];
            break;
       }
}

-(void)goAboutPage{
    AboutPage *page = [[AboutPage alloc]init];
    [self pushPage:page];
    [UMUtil clickEvent:EVENT_ABOUT];
}

-(void)goFeedbackPage{
    FeedbackPage *page= [[FeedbackPage alloc]init];
    [self pushPage:page];
    [UMUtil clickEvent:EVENT_ADVICE];
}


@end
