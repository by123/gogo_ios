//
//  CropsModel.h
//  gogo
//
//  Created by by.huang on 2017/10/25.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CorpsModel : NSObject

@property (assign, nonatomic) long team_id;
@property (copy, nonatomic) NSString *team_name;
@property (copy, nonatomic) NSString *short_name;
@property (copy, nonatomic) NSString *logo;
@property (copy, nonatomic) NSString *create_ts;

@end
