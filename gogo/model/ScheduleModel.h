//
//  ScheduleModel.h
//  gogo
//
//  Created by by.huang on 2017/10/25.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleItemModel.h"

@interface ScheduleModel : NSObject

@property (assign, nonatomic) long dt;
@property (strong, nonatomic) NSMutableArray *items;




@end


