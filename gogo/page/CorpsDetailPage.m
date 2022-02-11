//
//  CorpsDetailPage.m
//  gogo
//
//  Created by by.huang on 2017/10/27.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "CorpsDetailPage.h"
#import "BarView.h"
#import "TitleView.h"
#import "HistoryModel.h"
#import "CommentModel.h"
#import "HistoryCell.h"
#import "CommentCell.h"
#import "InsetTextField.h"
#import "TouchScrollView.h"
#import "MembersDetailPage.h"
#import "RespondModel.h"
#import "TeamModel.h"
#import "MemberModel.h"
@interface CorpsDetailPage ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) BarView  *barView;
@property (strong, nonatomic) TouchScrollView *scrollerView;
@property (strong, nonatomic) UIImageView   *corpsImageView;
@property (strong, nonatomic) UILabel  *corpsNameLabel;
@property (strong, nonatomic) UIView   *membersView;
@property (strong, nonatomic) UIButton *moreBtn;
@property (strong, nonatomic) UILabel  *honourLabel;
//@property (strong, nonatomic) UIView   *honourListView;
@property (strong, nonatomic) UILabel   *corpsIntroduce;
@property (strong, nonatomic) TitleView *historyTitleView;
@property (strong, nonatomic) UITableView *historyTabelView;
@property (strong, nonatomic) TitleView *commentTitleView;
@property (strong, nonatomic) UITableView *commentTabelView;
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) InsetTextField *commentTextField;
@property (strong, nonatomic) UILabel *hintLabel;

@end

@implementation CorpsDetailPage{
    NSMutableArray *historyModels;
    NSMutableArray *commentModels;
    TeamModel *teamModel;
    NSMutableArray *memberModels;
    CGSize titleSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    historyModels = [HistoryModel getModels];
    [self initView];
    [self request];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)initView{
    _barView = [[BarView alloc]initWithTitle:@"战队详情" page:self];
    [self.view addSubview:_barView];
    
    _scrollerView = [[TouchScrollView alloc]initWithParentView:self.view];
    _scrollerView.frame = CGRectMake(0,  StatuBarHeight + [PUtil getActualHeight:88], ScreenWidth, ScreenHeight - [PUtil getActualHeight:110]-(StatuBarHeight + [PUtil getActualHeight:88]));
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    
    _scrollerView.contentSize = CGSizeMake(ScreenWidth, [PUtil getActualHeight:621] + [PUtil getActualHeight:153] * [historyModels count] + [PUtil getActualHeight:180] * [commentModels count]);
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(uploadNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _scrollerView.mj_header = header;
    [self.view addSubview:_scrollerView];
    

    
}

-(void)initTopView{
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, ScreenWidth, [PUtil getActualHeight:220]);
    [_scrollerView addSubview:topView];
    
    _corpsImageView = [[UIImageView alloc]init];
    _corpsImageView.contentMode =UIViewContentModeScaleAspectFit;
    _corpsImageView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualWidth:30], [PUtil getActualWidth:160], [PUtil getActualWidth:160]);
    _corpsImageView.layer.masksToBounds = YES;
    _corpsImageView.layer.cornerRadius = [PUtil getActualWidth:20];
    [_corpsImageView sd_setImageWithURL:[NSURL URLWithString:teamModel.logo]];
    [topView addSubview:_corpsImageView];
    
    _corpsNameLabel = [[UILabel alloc]init];
    _corpsNameLabel.text = teamModel.team_name;
    _corpsNameLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:40]];
    _corpsNameLabel.textColor = c08_text;
    _corpsNameLabel.frame = CGRectMake([PUtil getActualWidth:210], [PUtil getActualHeight:42], ScreenWidth - [PUtil getActualWidth:210], [PUtil getActualHeight:56]);
    [topView addSubview:_corpsNameLabel];
    
    _membersView = [[UIView alloc]init];
    _membersView.frame = CGRectMake([PUtil getActualWidth:210], [PUtil getActualHeight:114], ScreenWidth - [PUtil getActualWidth:210], [PUtil getActualHeight:64]);
    
    int width = [PUtil getActualWidth:64];
    if(!IS_NS_COLLECTION_EMPTY(memberModels)){
        _moreBtn = [[UIButton alloc]init];
        _moreBtn.frame = CGRectMake(4*[PUtil getActualWidth:74], 0, width, width);
        _moreBtn.layer.masksToBounds = YES;
        _moreBtn.layer.cornerRadius = width/2;
        [_moreBtn addTarget:self action:@selector(OnClickMore) forControlEvents:UIControlEventTouchUpInside];
        [_membersView addSubview:_moreBtn];
        [ColorUtil setGradientColor:_moreBtn startColor:c01_blue endColor:c02_red director:Left];
    }
    
    NSInteger index = 0;
    if([memberModels count]> 4){
        index = 5;
    }else{
        index = [memberModels count];
    }
    for(int i=0;i<index;i++){
        if(i == index-1){
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(i*[PUtil getActualWidth:74], 0, width, width);
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = width/2;
            label.text = @"更多";
            label.textColor = c08_text;
            label.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
            label.textAlignment = NSTextAlignmentCenter;
            [_membersView addSubview:label];
        }else{
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.contentMode =UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(i*[PUtil getActualWidth:74], 0, width, width);
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = width/2;
            MemberModel *memberModel = [memberModels objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:memberModel.avatar]];
            [_membersView addSubview:imageView];
        }
    }
  
    [topView addSubview:_membersView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = c05_divider;
    lineView.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:220] -1, ScreenWidth -[PUtil getActualWidth:30] , 1);
    [topView addSubview:lineView];
    
    [self initHonourView];
    [self initHistory];
    [self initCommentView];
    [self initWriteCommentView];
    
}

-(void)initHonourView{
    UIView *honourView = [[UIView alloc]init];
    [_scrollerView addSubview:honourView];
    
    _honourLabel = [[UILabel alloc]init];
    _honourLabel.text = @"战队简介";
    _honourLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:20], ScreenWidth - [PUtil getActualWidth:30], [PUtil getActualHeight:33]);
    _honourLabel.textColor = c09_tips;
    _honourLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [honourView addSubview:_honourLabel];
    
//    _honourListView = [[UIView alloc]init];
//    NSArray *datas = @[@"2016年KPL秋季赛冠军",@"2017年KPL春季赛冠军",@"2017年KPL秋季赛亚军"];
//    for(int i=0 ; i < [datas count] ; i++){
//        UILabel *label = [[UILabel alloc]init];
//        label.text = [datas objectAtIndex:i];
//        label.textColor = c08_text;
//        label.alpha = 0.5f;
//        label.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:69] + i * [PUtil getActualHeight:48], ScreenWidth - [PUtil getActualWidth:30], [PUtil getActualHeight:40]);
//        label.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
//        [_honourListView addSubview:label];
//    }
//    [honourView addSubview:_honourListView];
    
    _corpsIntroduce = [[UILabel alloc]init];
    _corpsIntroduce.textColor = c08_text;
    _corpsIntroduce.alpha = 0.5f;
    _corpsIntroduce.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _corpsIntroduce.text = teamModel.introduce;
    _corpsIntroduce.numberOfLines = 0;
    _corpsIntroduce.lineBreakMode = NSLineBreakByCharWrapping;
    titleSize = [_corpsIntroduce.text boundingRectWithSize:CGSizeMake( ScreenWidth - [PUtil getActualWidth:30]*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[PUtil getActualHeight:28]]} context:nil].size;

    _corpsIntroduce.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:48], ScreenWidth - [PUtil getActualWidth:30],titleSize.height);
    [honourView addSubview:_corpsIntroduce];
    
    honourView.frame = CGRectMake(0,  [PUtil getActualHeight:219], ScreenWidth, [PUtil getActualHeight:78] + titleSize.height);

   
    
}

-(void)initHistory{
    _historyTitleView = [[TitleView alloc]initWithTitle: [PUtil getActualHeight:277]+titleSize.height title:@"历史战绩"];
    [_scrollerView addSubview:_historyTitleView];
    
    _historyTabelView = [[UITableView alloc]init];
    _historyTabelView.frame = CGRectMake(0,  [PUtil getActualHeight:277+88] + titleSize.height, ScreenWidth, [historyModels count]*[PUtil getActualHeight:153]);
    _historyTabelView.delegate = self;
    _historyTabelView.dataSource = self;
    _historyTabelView.backgroundColor = c06_backgroud;
    _historyTabelView.scrollEnabled = NO;
    _historyTabelView.userInteractionEnabled = NO;
    [_historyTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_historyTabelView];
}

-(void)initCommentView{
    _commentTitleView = [[TitleView alloc]initWithTitle: _historyTabelView.mj_h + _historyTabelView.mj_y title:@"评论(12)"];
    [_scrollerView addSubview:_commentTitleView];
    
    _commentTabelView = [[UITableView alloc]init];
    _commentTabelView.frame = CGRectMake(0,  _commentTitleView.mj_y+_commentTitleView.mj_h, ScreenWidth, [commentModels count]*[PUtil getActualHeight:180]);
    _commentTabelView.delegate = self;
    _commentTabelView.dataSource = self;
    _commentTabelView.backgroundColor = c06_backgroud;
    _commentTabelView.scrollEnabled = NO;
    _commentTabelView.userInteractionEnabled = NO;
    [_commentTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_commentTabelView];
}

-(void)initWriteCommentView{
    _commentView  = [[UIView alloc]init];
    _commentView.backgroundColor = c07_bar;
    _commentView.frame = CGRectMake(0, ScreenHeight - [PUtil getActualHeight:110], ScreenWidth, [PUtil getActualHeight:110]);
    [self.view addSubview:_commentView];
    
    _commentTextField = [[InsetTextField alloc]initWithFrame: CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:15], ScreenWidth -[PUtil getActualWidth:30]*2 , [PUtil getActualHeight:80]) andInsets:UIEdgeInsetsMake(0, [PUtil getActualWidth:16], 0, [PUtil getActualWidth:16])];
    _commentTextField.backgroundColor = c06_backgroud;
    _commentTextField.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _commentTextField.textColor = c08_text;
    _commentTextField.layer.masksToBounds = YES;
    _commentTextField.returnKeyType = UIReturnKeySend;
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
    
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,  [PUtil getActualHeight:277+88 + 88] + titleSize.height + [PUtil getActualHeight:153] * [historyModels count] + [PUtil getActualHeight:180] * [commentModels count]);
}

 -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     if(tableView == _historyTabelView){
         return [historyModels count];
     }else{
         return [commentModels count];
     }
 }
 
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(tableView == _historyTabelView){
         return [PUtil getActualHeight:153];
     }else{
         return [PUtil getActualHeight:180];
     }
 }
 

 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(tableView == _historyTabelView){
         HistoryCell *cell =  [tableView dequeueReusableCellWithIdentifier:[HistoryCell identify]];
         if(cell == nil){
             cell = [[HistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HistoryCell identify]];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
         }
         HistoryModel *model = [historyModels objectAtIndex:indexPath.row];
         if(indexPath.row + 1 == [historyModels count]){
             [cell setData:model hideLine:YES];
         }else{
             [cell setData:model hideLine:NO];
         }
         return cell;
     }else{
         CommentCell *cell =  [tableView dequeueReusableCellWithIdentifier:[CommentCell identify]];
         if(cell == nil){
             cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CommentCell identify]];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
         }
         CommentListModel *model = [commentModels objectAtIndex:indexPath.row];
         [cell setData:model];
         return cell;
     }
  
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

                                         
-(void)OnClickMore{
    MembersDetailPage *page = [[MembersDetailPage alloc]init];
    page.memberModels = memberModels;
    [self pushPage:page];
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


-(void)request{
    NSString *urlStr = [NSString stringWithFormat:@"%@%ld",API_TEAMDETAIL,_team_id];
    [ByNetUtil get:urlStr parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            id team = [data objectForKey:@"team"];
            teamModel = [TeamModel mj_objectWithKeyValues:team];
            id members = [data objectForKey:@"members"];
            memberModels = [MemberModel mj_objectArrayWithKeyValuesArray:members];
            [self initTopView];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
    }];
}

@end
