
//
//  HistoryModel.m
//  gogo
//
//  Created by by.huang on 2017/10/27.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "HistoryModel.h"

@implementation HistoryModel

+(NSMutableArray *)getModels{
    NSMutableArray *models = [[NSMutableArray alloc]init];
    HistoryModel *model = [[HistoryModel alloc]init];
    model.result = @"胜利";
    model.aTeam = @"AG超会玩";
    model.bTeam = @"GK";
    model.score = @"2 : 0";
    model.time = @"2017年6月7日 6月7日第3场";
    for(int i=0;i<5;i++){
        [models addObject:model];
    }
    return models;
}

@end
