//
//  MembersDetailPage.m
//  gogo
//
//  Created by by.huang on 2017/10/27.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "MembersDetailPage.h"
#import "BarView.h"
#import "MemberModel.h"
#import "MemberCell.h"

@interface MembersDetailPage ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BarView *barView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MembersDetailPage{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    _barView = [[BarView alloc]initWithTitle:@"队员介绍" page:self];
    [self.view addSubview:_barView];
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, StatuBarHeight + [PUtil getActualHeight:88], ScreenWidth, ScreenHeight -[PUtil getActualHeight:88] - StatuBarHeight);
    _tableView.contentSize = CGSizeMake(ScreenWidth, [_memberModels count] *[PUtil getActualHeight:200]);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = c06_backgroud;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(IS_NS_COLLECTION_EMPTY(_memberModels)){
        return 0;
    }
    return [_memberModels count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PUtil getActualHeight:200];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberCell *cell =  [tableView dequeueReusableCellWithIdentifier:[MemberCell identify]];
    if(cell == nil){
        cell = [[MemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MemberCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MemberModel *model = [_memberModels objectAtIndex:indexPath.row];
    [cell setData:model];
    return cell;
}




@end
