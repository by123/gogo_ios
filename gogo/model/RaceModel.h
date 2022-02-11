//
//  RaceModel.h
//  gogo
//
//  Created by by.huang on 2017/11/11.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamModel.h"

@interface RaceModel : NSObject

@property (assign, nonatomic) long race_id;
@property (assign, nonatomic) long race_info_id;
@property (assign, nonatomic) long game_id;
@property (copy, nonatomic) NSString *score_a;
@property (copy, nonatomic) NSString *score_b;
@property (copy, nonatomic) NSString *race_ts;
@property (copy, nonatomic) NSString *create_ts;
@property (copy, nonatomic) NSString *status;
@property (strong, nonatomic) TeamModel *team_a;
@property (strong, nonatomic) TeamModel *team_b;
@property (copy, nonatomic) NSString *introduce;
@property (copy, nonatomic) NSString *race_name;
@property (copy, nonatomic) NSString *start_ts;
@property (copy, nonatomic) NSString *end_ts;
@property (strong, nonatomic) NSMutableArray *team_a_gift;
@property (strong, nonatomic) NSMutableArray *team_b_gift;



@end
