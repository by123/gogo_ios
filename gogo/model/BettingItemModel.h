//
//  BettingItemModel.h
//  gogo
//
//  Created by by.huang on 2017/11/11.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Statu_Win @"win"
#define Statu_Lose @"lose"
#define Statu_Unknown @"unknown"
#define Statu_NotBet @"not_bet"
#define Statu_AlreadyBet @"already_bet"

@interface BettingItemModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) long betting_item_id;
@property (assign, nonatomic) long betting_id;
@property (copy, nonatomic) NSString *odds;
@property (assign, nonatomic) long coin;
@property (assign, nonatomic) Boolean isSelect;
@property (copy, nonatomic) NSString *status;

@end
