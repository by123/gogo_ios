//
//  SCDCommentView.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "SCDCommentView.h"
#import "CommentCell.h"
#import "CommentModel.h"
#import "TouchScrollView.h"
#import "InsetTextField.h"
#import "TouchTableView.h"

@interface SCDCommentView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) TouchTableView *tableView;
@property (strong, nonatomic) TouchScrollView *scrollerView;
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) InsetTextField *commentTextField;
@property (strong, nonatomic) UILabel *hintLabel;

@end

@implementation SCDCommentView{
    NSMutableArray *models;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
//        models = [CommentModel getModels];
        [self initView];
    }
    return self;
}

-(void)initView{
    _scrollerView = [[TouchScrollView alloc]initWithParentView:self];
    _scrollerView.userInteractionEnabled =YES;
    _scrollerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:278]);
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,  [models count]*[PUtil getActualHeight:180]);
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(uploadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _scrollerView.mj_header = header;
    [self addSubview:_scrollerView];
    
    _tableView = [[TouchTableView alloc]initWithParentView:_scrollerView];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, [models count]*[PUtil getActualHeight:180]);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = c06_backgroud;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_tableView];
    
    [self initWriteCommentView];
}

-(void)initWriteCommentView{
    _commentView  = [[UIView alloc]init];
    _commentView.backgroundColor = c07_bar;
    _commentView.frame = CGRectMake(0, _scrollerView.mj_h, ScreenWidth, [PUtil getActualHeight:110]);
    [self addSubview:_commentView];
    
    _commentTextField = [[InsetTextField alloc]initWithFrame: CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:15], ScreenWidth -[PUtil getActualWidth:30]*2 , [PUtil getActualHeight:80]) andInsets:UIEdgeInsetsMake(0, [PUtil getActualWidth:16], 0, [PUtil getActualWidth:16])];
    _commentTextField.backgroundColor = c06_backgroud;
    _commentTextField.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _commentTextField.textColor = c08_text;
    _commentTextField.returnKeyType = UIReturnKeySend;
    _commentTextField.layer.masksToBounds = YES;
    _commentTextField.layer.cornerRadius = [PUtil getActualHeight:10];
    _commentTextField.delegate = self;
    [_commentView addSubview:_commentTextField];
    
    _hintLabel = [[UILabel alloc]init];
    _hintLabel.text = @"发表评论";
    _hintLabel.textColor = c08_text;
    _hintLabel.alpha = 0.5f;
    _hintLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _hintLabel.frame =  CGRectMake([PUtil getActualWidth:46], [PUtil getActualHeight:32], [PUtil getActualHeight:140] , [PUtil getActualHeight:46]);
    [_commentView addSubview:_hintLabel];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [models count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PUtil getActualHeight:180];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell =  [tableView dequeueReusableCellWithIdentifier:[CommentCell identify]];
    if(cell == nil){
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CommentCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CommentModel *model = [models objectAtIndex:indexPath.row];
    [cell setData:model];
    return cell;
}

-(void)uploadNew
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    //    CURRENT = 0;
    //    [self requestList : NO];
}

-(void)uploadMore
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    //    CURRENT += REQUEST_SIZE;
    //    [self requestList : YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _hintLabel.hidden = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text isEqualToString:@""]){
        _hintLabel.hidden = NO;
    }
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


@end
