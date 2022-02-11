//
//  ChatViewCell.m
//  gogo
//
//  Created by by.huang on 2018/3/25.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ChatViewCell.h"
#import "AccountManager.h"


@interface ChatViewCell()

@property (strong, nonatomic) UILabel *messageLabel;
    
@end
@implementation ChatViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}
    
-(void)initView{
    _messageLabel = [[UILabel alloc]init];
    _messageLabel.textColor = c08_text;
    _messageLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _messageLabel.frame = CGRectMake([PUtil getActualWidth:15],[PUtil getActualHeight:50], ScreenWidth - [PUtil getActualWidth:30], [PUtil getActualHeight:50]);
    [self.contentView addSubview:_messageLabel];
}
    
-(void)updateData:(MessageTextModel *)model{
    UserModel *userModel = [[AccountManager sharedAccountManager]getUserInfo];
    if([model.uid isEqualToString:userModel.uid]){
        _messageLabel.textColor = c01_blue;
    }else{
        _messageLabel.textColor = c08_text;
    }
    if([model.msg_tp isEqualToString:@"sys"]){
        _messageLabel.textColor = c03_yellow;
    }
    _messageLabel.text = [NSString stringWithFormat:@"%@:%@",model.username,model.msg];

}
    
+(NSString *)identify{
    return @"ChatViewCell";
}
@end
