//
//  MessageModel.h
//  gogo
//
//  Created by by.huang on 2018/3/22.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject


@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *avatar;
@property (assign, nonatomic) long total_user;
@property (copy, nonatomic) NSString *msg_index;
    

    
@end
