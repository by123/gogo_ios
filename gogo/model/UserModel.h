//
//  UserModel.h
//  gogo
//
//  Created by by.huang on 2017/11/4.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *coin;
@property (strong, nonatomic) NSMutableArray *coin_gift;

@end
