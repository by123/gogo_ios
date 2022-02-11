//
//  BySocket.h
//  gogo
//
//  Created by by.huang on 2018/3/22.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageRespondModel.h"
@import SocketIO;

@protocol BySocketDelegate

-(void)OnReceiveMsgCallback:(MessageRespondModel *)model;
-(void)OnSocketConnectStatu : (Boolean)statu;
    
@end

@interface BySocket : NSObject
SINGLETON_DECLARATION(BySocket);

@property (weak, nonatomic) id socketDelegate;
    
#pragma mark 初始化socket
-(void)initWithUrl:(NSString *)urlStr;
    
#pragma mark 连接socket
-(void)connect;
    
#pragma mark 断开socket连接
-(void)disconnect;
    
#pragma mark 重连socket
-(void)reconnect;
    
#pragma mark 加入房间
-(void)joinRoom:(NSString *)roomId;
    
#pragma mark 离开房间
-(void)leaveRoom:(NSString *)roomId;
    
#pragma mark 发送消息
-(void)sendMsg:(NSString *)roomId msg:(NSString *)msg;
    
#pragma mark 解析消息
-(MessageModel *)parseMsg : (NSString *)msg;
    
#pragma mark 拉取消息
-(void)queryMsg : (NSString *)roomId index:(NSString*)index size:(NSInteger)size;
    
@end

