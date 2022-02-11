//
//  SCDHistoryModel.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "SCDHistoryModel.h"

@implementation SCDHistoryModel

+(NSMutableArray *)getModels{
    NSMutableArray *models = [[NSMutableArray alloc]init];
    SCDHistoryModel *model = [[SCDHistoryModel alloc]init];
    model.aTeam = @"AG超会玩";
    model.bTeam = @"GK";
    model.score = @"2 : 0";
    model.time = @"2017年6月7日 6月7日第3场";
    for(int i=0;i<6;i++){
        [models addObject:model];
    }
    return models;
}

@end
