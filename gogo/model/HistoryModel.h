//
//  HistoryModel.h
//  gogo
//
//  Created by by.huang on 2017/10/27.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject

@property (copy, nonatomic) NSString *result;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *score;

@property (copy, nonatomic) NSString *aTeam;

@property (copy, nonatomic) NSString *bTeam;

@property (copy, nonatomic) NSString *time;

@property (assign, nonatomic) Boolean hideLine;


+(NSMutableArray *)getModels;
@end
