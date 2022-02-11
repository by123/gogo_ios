//
//  SCDHistoryModel.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDHistoryModel : NSObject


@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *aTeam;
@property (copy, nonatomic) NSString *bTeam;
@property (copy, nonatomic) NSString *time;


+(NSMutableArray *)getModels;
@end
