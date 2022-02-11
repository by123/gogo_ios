//
//  SCDHistoryView.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "SCDHistoryView.h"
#import "SCDHistoryModel.h"
#import "SCDHistoryCell.h"

@interface SCDHistoryView()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SCDHistoryView{
    NSMutableArray *models;
}

-(instancetype)init{
    if(self == [super init]){
        models = [SCDHistoryModel getModels];
        [self initView];
    }
    return self;
}

-(void)initView{
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:168]);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    _tableView.backgroundColor = c06_backgroud;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [models count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PUtil getActualHeight:153];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCDHistoryCell *cell =  [tableView dequeueReusableCellWithIdentifier:[SCDHistoryCell identify]];
    if(cell == nil){
        cell = [[SCDHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SCDHistoryCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SCDHistoryModel *model = [models objectAtIndex:indexPath.row];
    [cell setData:model];
    return cell;
}

@end
