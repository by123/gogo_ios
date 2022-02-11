//
//  AccountManager.m
//  gogo
//
//  Created by by.huang on 2017/10/21.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager
SINGLETON_IMPLEMENTION(AccountManager);

-(void)saveAccount:(Account *)account{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:account.uid forKey:UID];
    [userDefaults setValue:account.access_token forKey:ACCESS_TOKEN];
    [userDefaults setValue:account.code forKey:CODE];
    [userDefaults setValue:account.refresh_token forKey:REFRESH_TOKEN];
    [userDefaults synchronize];
}

-(Account *)getAccount{
    Account *account = [[Account alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    account.uid = [userDefaults objectForKey:UID];
    account.access_token = [userDefaults objectForKey:ACCESS_TOKEN];
    account.code = [userDefaults objectForKey:CODE];
    account.refresh_token = [userDefaults objectForKey:REFRESH_TOKEN];
    return account;
}

-(void)clear{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:UID];
    [userDefaults removeObjectForKey:ACCESS_TOKEN];
    [userDefaults removeObjectForKey:CODE];
    [userDefaults removeObjectForKey:REFRESH_TOKEN];
    [userDefaults removeObjectForKey:AVATAR];
    [userDefaults removeObjectForKey:USERNAME];
    [userDefaults removeObjectForKey:GENDER];
    [userDefaults removeObjectForKey:COIN];
    [userDefaults synchronize];
}

-(Boolean)isLogin{
    Account *account = [self getAccount];
    if(!IS_NS_STRING_EMPTY(account.uid) && !IS_NS_STRING_EMPTY(account.access_token)){
        return YES;
    }
    return NO;
}

-(void)saveUserInfo : (UserModel *)userModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:userModel.uid forKey:UID];
    [userDefaults setValue:userModel.avatar forKey:AVATAR];
    [userDefaults setValue:userModel.username forKey:USERNAME];
    [userDefaults setValue:userModel.gender forKey:GENDER];
    [userDefaults setValue:userModel.coin forKey:COIN];
    [userDefaults synchronize];
}

-(UserModel *)getUserInfo{
    UserModel *userModel = [[UserModel alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userModel.uid = [userDefaults objectForKey:UID];
    userModel.avatar = [userDefaults objectForKey:AVATAR];
    userModel.username = [userDefaults objectForKey:USERNAME];
    userModel.coin = [userDefaults objectForKey:COIN];
    userModel.gender = [userDefaults objectForKey:GENDER];
    return userModel;
}


-(void)saveAddress : (AddressModel *)addressModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:addressModel.receiver forKey:ADDRESS_NAME];
    [userDefaults setValue:addressModel.tel forKey:ADDRESS_PHONE];
    [userDefaults setValue:addressModel.location forKey:ADDRESS_AREA];
    [userDefaults setValue:addressModel.address_detail forKey:ADDRESS_ADDRESS];
    [userDefaults synchronize];
}

-(AddressModel *)getAddressModel{
    AddressModel *addressModel = [[AddressModel alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    addressModel.receiver = [userDefaults objectForKey:ADDRESS_NAME];
    addressModel.tel = [userDefaults objectForKey:ADDRESS_PHONE];
    addressModel.location = [userDefaults objectForKey:ADDRESS_AREA];
    addressModel.address_detail = [userDefaults objectForKey:ADDRESS_ADDRESS];
    return addressModel;
}
@end
