//
//  AccountManager.h
//  gogo
//
//  Created by by.huang on 2017/10/21.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "AddressModel.h"

#define UID @"uid"
#define ACCESS_TOKEN @"access_token"
#define REFRESH_TOKEN @"refresh_token"
#define CODE @"code"


#define USERNAME @"username"
#define GENDER @"gender"
#define AVATAR @"avatar"
#define COIN @"coin"



#define ADDRESS_NAME @"address_name"
#define ADDRESS_PHONE @"address_phone"
#define ADDRESS_AREA @"address_area"
#define ADDRESS_ADDRESS @"address_address"

@interface AccountManager : NSObject
SINGLETON_DECLARATION(AccountManager);

-(void)saveAccount : (Account *)account;

-(Account *)getAccount;

-(Boolean)isLogin;

-(void)clear;

-(void)saveUserInfo : (UserModel *)userModel;

-(UserModel *)getUserInfo;

-(void)saveAddress : (AddressModel *)addressModel;

-(AddressModel *)getAddressModel;

@end
