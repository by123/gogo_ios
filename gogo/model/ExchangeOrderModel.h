//
//  ExchangeOrderModel.h
//  gogo
//
//  Created by by.huang on 2017/11/9.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ExchangeStatu){
    InHand,
    Exchanged
};

@interface ExchangeOrderModel : NSObject

@property (assign, nonatomic) long goods_order_id;
@property (assign, nonatomic) long goods_id;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *create_ts;

@end
