//
//  PayModel.h
//  gogo
//
//  Created by by.huang on 2017/11/8.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject

@property (assign, nonatomic) long coin_plan_id;
@property (assign, nonatomic) long fee;
@property (assign, nonatomic) long coin_count;
@property (copy, nonatomic) NSString* gift_name;
@property (assign, nonatomic) long gift_count;
@property (copy, nonatomic) NSString *gift_icon;

@end
