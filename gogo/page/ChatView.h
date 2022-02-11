//
//  ChatView.h
//  gogo
//
//  Created by by.huang on 2017/12/10.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageTextModel.h"

@interface ChatView : UIView
    
@property (copy,nonatomic) NSString *roomId;
    
-(instancetype)initWithRoomId:(NSString *)roomId;

-(void)setIndex:(NSString *)index;

- (void)keyboardWillChangeFrame:(NSNotification *)notification;

-(void)addMessage:(MessageTextModel *)model;
    
-(void)addHistoryMessage : (NSMutableArray *)models;
    
@end
