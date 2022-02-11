//
//  Account.h
//  gogo
//
//  Created by by.huang on 2017/10/21.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface Account : NSObject

@property (copy, nonatomic)   NSString  *uid;
@property (copy, nonatomic)   NSString  *access_token;
@property (copy, nonatomic)   NSString  *code;
@property (copy, nonatomic)   NSString  *refresh_token;


@end
