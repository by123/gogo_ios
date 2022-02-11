//
//  MessageRespondModel.m
//  gogo
//
//  Created by by.huang on 2018/3/24.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "MessageRespondModel.h"

@implementation MessageRespondModel

+(MessageType)getMessageType : (NSString *)type{
    if([type isEqualToString:@"my_join"]){
        return MY_JOIN;
    }
    if([type isEqualToString:@"other_join"]){
        return OTHER_JOIN;
    }
    if([type isEqualToString:@"leave"]){
        return LEAVE;
    }
    if([type isEqualToString:@"msg"]){
        return MSG;
    }
    if([type isEqualToString:@"history"]){
        return HISTORY;
    }
    return INVALID;
}
    
+(MessageModel *)parseMessage:(MessageRespondModel *)respondModel{
    MessageModel *model = [MessageModel mj_objectWithKeyValues:respondModel.data];
    return model;
}
    
+(MessageTextModel *)parseTextMessage:(MessageRespondModel *)respondModel{
    MessageTextModel *textModel = [MessageTextModel mj_objectWithKeyValues:respondModel.data];
    return textModel;
}
    
+(NSMutableArray *)parseHistoryMessage:(MessageRespondModel *)respondModel{
    id items = [respondModel.data objectForKey:@"items"];
    NSMutableArray *models = [MessageTextModel mj_objectArrayWithKeyValuesArray:items];
    return models;
}
    

    
@end
