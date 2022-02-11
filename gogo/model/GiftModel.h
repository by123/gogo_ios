//
//  GiftModel.h
//  gogo
//
//  Created by by.huang on 2018/3/5.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject

@property(assign, nonatomic)long total_gift;
@property(assign, nonatomic)long coin_plan_id;
@property(copy, nonatomic)NSString *gift_name;
@property(copy, nonatomic)NSString *gift_icon;

@end
