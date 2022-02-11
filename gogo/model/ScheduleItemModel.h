//
//  ScheduleItemModel.h
//  gogo
//
//  Created by by.huang on 2017/11/6.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamModel.h"

#define Statu_Ready @"ready"
#define Statu_End @"end"


typedef NS_ENUM(NSInteger,ScheduleType){
    Content = 0,
    Title = 1,
};

@interface ScheduleItemModel : NSObject

@property (assign, nonatomic) long race_id;
@property (assign, nonatomic) long race_info_id;
@property (assign, nonatomic) long game_id;
@property (copy, nonatomic) NSString* score_a;
@property (copy, nonatomic) NSString* score_b;
@property (copy, nonatomic) NSString* race_ts;
@property (copy, nonatomic) NSString* race_name;
@property (copy, nonatomic) NSString* create_ts;
@property (copy, nonatomic) NSString* status;
@property (assign, nonatomic) Boolean hideLine;


@property (strong, nonatomic) TeamModel *team_a;
@property (strong, nonatomic) TeamModel *team_b;

@end
