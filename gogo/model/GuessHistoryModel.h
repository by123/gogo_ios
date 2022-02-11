//
//  GuessHistoryModel.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RaceModel.h"
#import "BettingModel.h"

//未完成，赢，输，比赛被取消
#define APPLY @"apply"
#define WIN @"win"
#define LOSE @"lose"
#define INVALID @"invalid"


@interface GuessHistoryModel : NSObject

@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *create_ts;
@property (strong, nonatomic) RaceModel *race;
@property (strong, nonatomic) NSMutableArray *bettings;
@property (copy, nonatomic) NSString *coin;
@property (copy, nonatomic) NSString *odds;



@end
