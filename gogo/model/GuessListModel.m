//
//  GuessListModel.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GuessListModel.h"

@implementation GuessListModel

+(NSMutableArray *)models{
    NSMutableArray *models = [[NSMutableArray alloc]init];
    
    ////
    GuessListModel *model1 = [[GuessListModel alloc]init];
    model1.title = @"全场比赛结果为?";
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    
    GuessModel *gModel11 = [[GuessModel alloc]init];
    gModel11.teamName = @"AG超会玩";
    gModel11.guess = @"1.68";
    [array1 addObject:gModel11];
    
    GuessModel *gModel12 = [[GuessModel alloc]init];
    gModel12.teamName = @"GK";
    gModel12.guess = @"2.55";
    [array1 addObject:gModel12];
    
    model1.models = array1;
    [models addObject:model1];
    ////
    
    GuessListModel *model2 = [[GuessListModel alloc]init];
    model2.title = @"第一局谁先拿到一血?";
    NSMutableArray *array2 = [[NSMutableArray alloc]init];
    
    GuessModel *gModel21 = [[GuessModel alloc]init];
    gModel21.teamName = @"AG超会玩";
    gModel21.guess = @"1.8";
    [array2 addObject:gModel21];
    
    GuessModel *gModel22 = [[GuessModel alloc]init];
    gModel22.teamName = @"GK";
    gModel22.guess = @"1.2";
    [array2 addObject:gModel22];
    
    model2.models = array2;
    [models addObject:model2];

    ///
    
    GuessListModel *model3 = [[GuessListModel alloc]init];
    model3.title = @"全场比赛胜局比分为?";
    NSMutableArray *array3 = [[NSMutableArray alloc]init];
    
    GuessModel *gModel31 = [[GuessModel alloc]init];
    gModel31.teamName = @"0:2";
    gModel31.guess = @"1.68";
    [array3 addObject:gModel31];
    
    GuessModel *gModel32 = [[GuessModel alloc]init];
    gModel32.teamName = @"1:2";
    gModel32.guess = @"2.55";
    [array3 addObject:gModel32];
    
    GuessModel *gModel33 = [[GuessModel alloc]init];
    gModel33.teamName = @"2:0";
    gModel33.guess = @"2.80";
    [array3 addObject:gModel33];
    
    GuessModel *gModel34 = [[GuessModel alloc]init];
    gModel34.teamName = @"2:1";
    gModel34.guess = @"2.15";
    [array3 addObject:gModel34];
    
    model3.models = array3;
    [models addObject:model3];
    ///
    
    
    GuessListModel *model4 = [[GuessListModel alloc]init];
    model4.title = @"第二局谁先拿到一血?";
    NSMutableArray *array4 = [[NSMutableArray alloc]init];
    
    GuessModel *gModel41 = [[GuessModel alloc]init];
    gModel41.teamName = @"AG超会玩";
    gModel41.guess = @"1.8";
    [array4 addObject:gModel41];
    
    GuessModel *gModel42 = [[GuessModel alloc]init];
    gModel42.teamName = @"GK";
    gModel42.guess = @"1.2";
    [array4 addObject:gModel42];
    
    model4.models = array4;
    [models addObject:model4];
    
    return models;
    
}

@end
