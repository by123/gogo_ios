//
//  BettingModel.h
//  gogo
//
//  Created by by.huang on 2017/11/11.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BettingItemModel.h"
@interface BettingModel : NSObject

@property (assign, nonatomic) long betting_id;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) long race_id;
@property (copy, nonatomic) NSString *tp;
@property (copy, nonatomic) NSString *expired_ts;
@property (copy, nonatomic) NSString *betting_status;
@property (strong, nonatomic) NSMutableArray *items;

@end
