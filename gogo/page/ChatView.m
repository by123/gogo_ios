//
//  ChatView.m
//  gogo
//
//  Created by by.huang on 2017/12/10.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ChatView.h"
#import "TouchTableView.h"
#import "TouchScrollView.h"
#import "InsetTextField.h"
#import "BySocket.h"
#import "ChatViewCell.h"
@interface ChatView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) TouchTableView *tableView;
@property (strong, nonatomic) TouchScrollView *scrollerView;
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) InsetTextField *commentTextField;
@property (strong, nonatomic) UILabel *hintLabel;


@end
@implementation ChatView{
    int height;
    NSMutableArray *datas;
    NSString *_index;
}

-(instancetype)initWithRoomId:(NSString *)roomId{
    if(self == [super init]){
        _roomId = roomId;
        datas = [[NSMutableArray alloc]init];
        [self initView];
    }
    return self;
}

-(void)setIndex:(NSString *)index{
    _index = index;
}

-(void)initView{
    height = ScreenHeight - [PUtil getActualHeight:400] - StatuBarHeight - [PUtil getActualHeight:88];
    self.backgroundColor = c06_backgroud;
    _scrollerView = [[TouchScrollView alloc]initWithParentView:self];
    _scrollerView.userInteractionEnabled =YES;
    _scrollerView.frame = CGRectMake(0, 0, ScreenWidth,height );
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;

    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(uploadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _scrollerView.mj_header = header;
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,  2000);
    [self addSubview:_scrollerView];
    
    _tableView = [[TouchTableView alloc]initWithParentView:_scrollerView];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, 2000);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = c06_backgroud;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_tableView];

    [self initCommentView];
}

-(void)initCommentView{
    _commentView  = [[UIView alloc]init];
    _commentView.backgroundColor = c07_bar;
    _commentView.frame = CGRectMake(0, height - [PUtil getActualHeight:110], ScreenWidth, [PUtil getActualHeight:110]);
    [self addSubview:_commentView];
    
    _commentTextField = [[InsetTextField alloc]initWithFrame: CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:15], ScreenWidth - [PUtil getActualWidth:180] , [PUtil getActualHeight:80]) andInsets:UIEdgeInsetsMake(0, [PUtil getActualWidth:16], 0, [PUtil getActualWidth:16])];
    _commentTextField.backgroundColor = c06_backgroud;
    _commentTextField.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _commentTextField.textColor = c08_text;
    _commentTextField.returnKeyType = UIReturnKeySend;
    _commentTextField.layer.masksToBounds = YES;
    _commentTextField.layer.cornerRadius = [PUtil getActualHeight:10];
    _commentTextField.delegate = self;
    [_commentView addSubview:_commentTextField];
    
    UIButton *sendBtn = [[UIButton alloc]init];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.backgroundColor = c01_blue;
    sendBtn.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:140], [PUtil getActualHeight:15], [PUtil getActualWidth:120], [PUtil getActualHeight:80]);
    sendBtn.layer.cornerRadius = [PUtil getActualHeight:10];
    sendBtn.layer.masksToBounds = YES;
    [sendBtn addTarget:self action:@selector(sendChat) forControlEvents:UIControlEventTouchUpInside];
    [_commentView addSubview:sendBtn];
    
    
    _hintLabel = [[UILabel alloc]init];
    _hintLabel.text = @"发送消息";
    _hintLabel.textColor = c08_text;
    _hintLabel.alpha = 0.5f;
    _hintLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _hintLabel.frame =  CGRectMake([PUtil getActualWidth:46], [PUtil getActualHeight:32], [PUtil getActualHeight:140] , [PUtil getActualHeight:46]);
    [_commentView addSubview:_hintLabel];
    
    [self addSubview:_commentView];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _hintLabel.hidden = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text isEqualToString:@""]){
        _hintLabel.hidden = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendChat];
    return YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    CGRect commmentViewRect = _commentView.frame;
    commmentViewRect.origin.y += yOffset;
    __weak UIView *commentView = _commentView;
    [UIView animateWithDuration:duration animations:^{
        commentView.frame = commmentViewRect;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_commentTextField resignFirstResponder];
}


-(void)sendChat{
    [UMUtil clickEvent:EVENT_GAME_SEND_CHAT];
    NSString *msg = _commentTextField.text;
    if(!IS_NS_STRING_EMPTY(msg)){
        [[BySocket sharedBySocket]sendMsg:_roomId msg:msg];
        _commentTextField.text = @"";
    }else{
        [DialogHelper showFailureAlertSheet:@"请输入聊天内容"];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [datas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [PUtil getActualHeight:50];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:[ChatViewCell identify]];
    if(cell == nil){
        cell = [[ChatViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ChatViewCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = c06_backgroud;
    }
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,  ([PUtil getActualHeight:50] * [datas count])+[PUtil getActualHeight:160]);
    if(!IS_NS_COLLECTION_EMPTY(datas)){
        MessageTextModel *model = [datas objectAtIndex:indexPath.row];
        [cell updateData:model];
    }
    [_scrollerView.mj_header endRefreshing];
    return cell;
}
    
    
-(void)uploadNew
{
    [ByLog print:@"这是啥" content:_index];
    [[BySocket sharedBySocket] queryMsg:_roomId index:_index size:10];
}


    
-(void)addMessage:(MessageTextModel *)model{
    _index = model.chat_id;
    [ByLog print:@"当前msgid" content:_index];
    [datas addObject:model];
    [_tableView reloadData];
    if([datas count]>0){
        CGPoint point = CGPointMake(_scrollerView.contentOffset.x, _scrollerView.contentOffset.y+[PUtil getActualHeight:50]);
        [_scrollerView setContentOffset:point animated:YES];
    }
  
}
    
-(void)addHistoryMessage : (NSMutableArray *)models{
    if(!IS_NS_COLLECTION_EMPTY(models)){
        NSMutableArray *temps =  [[models reverseObjectEnumerator] allObjects];
        MessageTextModel *firstModel = [temps objectAtIndex:0];
        _index = firstModel.chat_id;
        [ByLog print:@"当前msgid" content:_index];
        [temps addObjectsFromArray:datas];
        [datas removeAllObjects];
        [datas addObjectsFromArray:temps];
        [_tableView reloadData];
    }

}





@end
