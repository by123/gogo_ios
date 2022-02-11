//
//  LoginModel.h
//  gogo
//
//  Created by by.huang on 2017/11/3.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *refresh_token;
@property (copy, nonatomic) NSString *access_token;
@property (assign, nonatomic) long expired_in;


@end
