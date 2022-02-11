//
//  MemberModel.h
//  gogo
//
//  Created by by.huang on 2017/10/27.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberModel : NSObject

@property (assign, nonatomic) long member_id;
@property (assign, nonatomic) long team_id;
@property (copy, nonatomic) NSString *member_name;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *introduce;
@property (copy, nonatomic) NSString *create_ts;

+ (NSDictionary *)mj_replacedKeyFromPropertyName;

@end
