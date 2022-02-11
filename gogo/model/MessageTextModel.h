//
//  MessageHistoryModel.h
//  gogo
//
//  Created by by.huang on 2018/3/24.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTextModel : NSObject

@property (copy, nonatomic) NSString *msg_tp;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *room_id;
@property (copy, nonatomic) NSString *chat_id;
@property (copy, nonatomic) NSString *msg;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *create_ts;


@end
