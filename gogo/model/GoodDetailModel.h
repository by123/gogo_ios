//
//  GoodDetailModel.h
//  gogo
//
//  Created by by.huang on 2017/11/9.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodDetailModel : NSObject

@property (assign, nonatomic) long goods_id;
@property (assign, nonatomic) long coin;
@property (assign, nonatomic) long total;
@property (assign, nonatomic) long max_per_buy;
@property (assign, nonatomic) long total_buy;
@property (copy, nonatomic) NSString *tp;
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *introduce;
@property (copy, nonatomic) NSString *expired_ts;
@property (copy, nonatomic) NSString *create_ts;
@property (assign, nonatomic) long total_apply;


@end
