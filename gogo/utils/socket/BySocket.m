//
//  BySocket.m
//  gogo
//
//  Created by by.huang on 2018/3/22.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BySocket.h"
#import "AccountManager.h"

#define SOCKET_TIMEOUT 30
@interface BySocket()
    
    @property (strong, nonatomic)SocketManager *manager;
    @property (strong, nonatomic)SocketIOClient *socket;
    
    @end

@implementation BySocket
    SINGLETON_IMPLEMENTION(BySocket);
    
-(void)initWithUrl:(NSString *)urlStr{
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    _manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES}];
    _socket = _manager.defaultSocket;
}
    
-(void)connect{
    [ByLog print:@"开始连接socket"];
    [_socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *act) {
        if(_socketDelegate && [_socketDelegate respondsToSelector:@selector(OnSocketConnectStatu:)]){
            [ByLog print:@"socket连接成功,开始监听"];
            [self handleReceiveSocket];
            [_socketDelegate OnSocketConnectStatu:YES];
        }
    }];
    [_socket connectWithTimeoutAfter:SOCKET_TIMEOUT withHandler:^{
        if(_socketDelegate && [_socketDelegate respondsToSelector:@selector(OnSocketConnectStatu:)]){
            [ByLog print:@"socket连接超时"];
            [_socketDelegate OnSocketConnectStatu:NO];
        }
    }];
}
    
-(void)handleReceiveSocket{
    [_socket onAny:^(SocketAnyEvent* any) {
        NSArray *array = any.items;
        if(!IS_NS_COLLECTION_EMPTY(array)){
            NSMutableArray *dataArray  = [NSMutableArray mj_keyValuesArrayWithObjectArray:array];
            if(!IS_NS_COLLECTION_EMPTY(dataArray)){
                MessageRespondModel *respondModel = [MessageRespondModel mj_objectWithKeyValues:dataArray[0]];
                respondModel.type = [MessageRespondModel getMessageType:respondModel.tp];
                if(_socketDelegate && [_socketDelegate respondsToSelector:@selector(OnReceiveMsgCallback:)]){
                    if(_socketDelegate && [_socketDelegate respondsToSelector:@selector(OnReceiveMsgCallback:)]){
                        [_socketDelegate OnReceiveMsgCallback:respondModel];
                    }
                }
            }
        }
    }];
}
    
-(void)disconnect{
    if(_socket){
        [_socket disconnect];
        _socket = nil;
    }
}
    
-(void)reconnect{
    [self disconnect];
    [self connect];
}
    
    
-(void)joinRoom:(NSString *)roomId{
    [ByLog print:@"加入房间" content:roomId];
    NSString *uid = [[AccountManager sharedAccountManager]getUserInfo].uid;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:roomId forKey:@"room_id"];
    [dic setObject:uid forKey:@"uid"];
    [_socket emit:@"join_room" with:@[dic]];
    
}
    
-(void)leaveRoom:(NSString *)roomId{
    [ByLog print:@"离开房间" content:roomId];
    NSString *uid = [[AccountManager sharedAccountManager]getUserInfo].uid;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:roomId forKey:@"room_id"];
    [dic setObject:uid forKey:@"uid"];
    [_socket emit:@"leave_room" with:@[dic]];
}
    
-(void)sendMsg:(NSString *)roomId msg:(NSString *)msg{
    [ByLog print:@"发送消息，房间ID" content:roomId];
    NSString *uid = [[AccountManager sharedAccountManager]getUserInfo].uid;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:roomId forKey:@"room_id"];
    [dic setObject:msg forKey:@"msg"];
    [dic setObject:uid forKey:@"uid"];
    [_socket emit:@"send_msg" with:@[dic]];
}
    
-(MessageModel *)parseMsg:(NSString *)msg{
    MessageModel *model = [[MessageModel alloc]init];
    return model;
}
    
    
-(void)queryMsg : (NSString *)roomId index:(NSString *)index size:(NSInteger)size{
    if(IS_NS_STRING_EMPTY(index) || size <= 0){
        [ByLog print:@"拉取消息失败" content:@"index或size非法"];
        return;
    }
    [ByLog print:@"拉取消息，房间ID" content:roomId];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:roomId forKey:@"room_id"];
    [dic setObject:index forKey:@"index"];
    [dic setObject:@(size) forKey:@"size"];
    [_socket emit:@"history_msg" with:@[dic]];
}
    
    
-(NSString *)parseArrayToJsonStr:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:kNilOptions
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}
    
@end

