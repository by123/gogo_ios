//
//  MessageRespondModel.h
//  gogo
//
//  Created by by.huang on 2018/3/24.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "MessageTextModel.h"

@interface MessageRespondModel : NSObject
    
typedef NS_ENUM(NSInteger,MessageType){
    INVALID = 0,
    MY_JOIN ,
    OTHER_JOIN,
    LEAVE,
    MSG,
    HISTORY,
};

@property (assign, nonatomic) MessageType type;
@property (copy, nonatomic) NSString *tp;
@property (strong, nonatomic) id data;

+(MessageType)getMessageType : (NSString *)type;
+(MessageModel *)parseMessage : (MessageRespondModel *)respondModel;
+(MessageTextModel *)parseTextMessage : (MessageRespondModel *)respondModel;
+(NSMutableArray *)parseHistoryMessage : (MessageRespondModel *)respondModel;

@end
