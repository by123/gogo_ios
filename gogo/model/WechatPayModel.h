//
//  WechatPayModel.h
//  gogo
//
//  Created by by.huang on 2017/11/14.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatPayModel : NSObject

@property (copy, nonatomic) NSString *app_id;
@property (copy, nonatomic) NSString *partner_id;
@property (copy, nonatomic) NSString *prepay_id;
@property (copy, nonatomic) NSString *package;
@property (copy, nonatomic) NSString *nonce_str;
@property (copy, nonatomic) NSString *timestamp;
@property (copy, nonatomic) NSString *sign;


@end
