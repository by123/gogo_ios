//
//  NewsDetailPage.m
//  gogo
//
//  Created by by.huang on 2017/10/26.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "NewsDetailPage.h"
#import "BarView.h"
#import "TitleView.h"
#import "InsetTextField.h"
#import "CommentCell.h"
#import "TouchScrollView.h"
#import "RespondModel.h"
#import "NewsDetailModel.h"
#import "CommentListModel.h"
#import "YGPlayerView.h"
#import "YGPlayInfo.h"
#import "RespondModel.h"
#import "TimeUtil.h"
#import "NewsCell.h"
#import "OkAlertView.h"

#define CommentCellHeight [PUtil getActualHeight:180]
#define MoreCellHeight [PUtil getActualHeight:172]
#define REREQUESTSIZE 10
#define TitleHeight [PUtil getActualHeight:88]
@interface NewsDetailPage ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIWebViewDelegate,BarViewDelegate,CommentCellDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) BarView *barView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) TitleView *moreTitleView;
@property (strong, nonatomic) UITableView *moreTableView;
@property (strong, nonatomic) TitleView *commentTitleView;
@property (strong, nonatomic) TouchScrollView *scrollerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) InsetTextField *commentTextField;
@property (strong, nonatomic) UILabel *hintLabel;
@property (strong, nonatomic) UIScrollView *webScrollView;
@property (strong, nonatomic) YGPlayerView *playView;

@end

@implementation NewsDetailPage{
    NewsDetailModel *model;
    int index;
    NSMutableArray *datas;
    NSMutableArray *commandDatas;
    Boolean webLoadFinish;
    Boolean isFirst;
    CGFloat WebViewHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    datas = [[NSMutableArray alloc]init];
    commandDatas = [[NSMutableArray alloc]init];
    index = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self requestData : NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    if(_playView){
        [_playView resetPlayer];
    }
}


-(void)initView{
    _barView = [[BarView alloc]initWithTitle:model.tp page:self delegate:self like:YES];
    if(model.is_like){
        [_barView setLike:YES];
    }else{
        [_barView setLike:NO];
    }
    [self.view addSubview:_barView];
    
    _scrollerView = [[TouchScrollView alloc]initWithParentView:self.view];
    _scrollerView.backgroundColor = c06_backgroud;
    _scrollerView.frame = CGRectMake(0, StatuBarHeight + _barView.mj_h, ScreenWidth, ScreenHeight - [PUtil getActualHeight:238]);
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.delegate = self;
    _scrollerView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMore)];
    _scrollerView.scrollEnabled = NO;
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight);
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _scrollerView.mj_header = header;
    [self.view addSubview:_scrollerView];
    
    [self initTopView];
    
    if(IS_NS_STRING_EMPTY(model.video)){
        _webView = [[UIWebView alloc]init];
        _webView.frame = CGRectMake([PUtil getActualWidth:20],0, ScreenWidth-[PUtil getActualWidth:40],2000);
        _webView.allowsInlineMediaPlayback = YES;
        _webView.backgroundColor = c06_backgroud;
        _webView.scalesPageToFit = YES;
        _webView.opaque = NO;
        _webView.delegate = self;
        _webView.hidden = YES;
        _webScrollView = (UIScrollView *)[_webView.subviews objectAtIndex:0];
        _webScrollView.scrollEnabled = NO;
        NSString *htmlStr = [NSString stringWithFormat:@"<head></head><body style=\"zoom:1.5\">%@</body>",model.body];
        [_webView loadHTMLString:htmlStr baseURL:nil];
        [_scrollerView addSubview:_webView];
    }else{
        _playView = [[[NSBundle mainBundle] loadNibNamed:@"YGPlayerView" owner:nil options:nil] lastObject];
        _playView.playerViewTop = _topView.height;
        YGPlayInfo *playInfo = [[YGPlayInfo alloc]init];
        playInfo.url = model.video;
        [_playView playWithPlayInfo:playInfo];
        [_scrollerView addSubview:_playView];
        [self requestCommandList];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)initTopView{
    
    _topView = [[UIView alloc]init];
    [_scrollerView addSubview:_topView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = model.title;
    titleLabel.textColor = c08_text;
    titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:36]];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize titleSize = [titleLabel.text boundingRectWithSize:CGSizeMake( ScreenWidth - [PUtil getActualWidth:20]*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[PUtil getActualHeight:36]]} context:nil].size;
    titleLabel.frame = CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:20] , ScreenWidth - [PUtil getActualWidth:20]*2, titleSize.height);
    [_topView addSubview:titleLabel];
    
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.text = model.tp;
    typeLabel.textColor = c08_text;
    typeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
    typeLabel.alpha = 0.25f;
    typeLabel.frame = CGRectMake([PUtil getActualWidth:20], [PUtil getActualHeight:30] + titleSize.height, typeLabel.contentSize.width, typeLabel.contentSize.height);
    [_topView addSubview:typeLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = [TimeUtil generateAll:model.news_ts];
    timeLabel.textColor = c08_text;
    timeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
    timeLabel.alpha = 0.25f;
    timeLabel.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:30] - timeLabel.contentSize.width, [PUtil getActualHeight:30] + titleSize.height, timeLabel.contentSize.width, timeLabel.contentSize.height);
    [_topView addSubview:timeLabel];

    _topView.frame = CGRectMake(0,0, ScreenWidth, typeLabel.mj_y+typeLabel.contentSize.height);
}


-(void)initMore{
    int height = 0;
    if(IS_NS_STRING_EMPTY(model.video)){
        height = WebViewHeight+_topView.height;
    }else{
        height = ScreenWidth * ScreenWidth /ScreenHeight + _topView.height;
    }
    _moreTitleView = [[TitleView alloc]initWithTitle:height title:@"更多文章"];
    [_scrollerView addSubview:_moreTitleView];
    
    _moreTableView = [[UITableView alloc]init];
    _moreTableView.frame = CGRectMake(0, _moreTitleView.mj_y+_moreTitleView.mj_h, ScreenWidth,  MoreCellHeight * [commandDatas count]);
    _moreTableView.delegate = self;
    _moreTableView.dataSource = self;
    _moreTableView.backgroundColor = c06_backgroud;
    _moreTableView.scrollEnabled = NO;
    _moreTableView.userInteractionEnabled = YES;
    [_moreTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_moreTableView];
    
    [self initComment];
    [self requestNew];
    
}

-(void)initComment{
    int height = _moreTableView.mj_h + _moreTableView.mj_y;

    _commentTitleView = [[TitleView alloc]initWithTitle:height title:@"评论（0）"];
    [_commentTitleView setTitle:[NSString stringWithFormat:@"评论（%d）",model.comment_count]];
    [_scrollerView addSubview:_commentTitleView];
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, _commentTitleView.mj_y+_commentTitleView.mj_h, ScreenWidth,  ScreenHeight);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = c06_backgroud;
    _tableView.scrollEnabled = NO;
    _tableView.userInteractionEnabled = YES;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_tableView];
    
    _commentView  = [[UIView alloc]init];
    _commentView.backgroundColor = c07_bar;
    _commentView.frame = CGRectMake(0, ScreenHeight - [PUtil getActualHeight:110], ScreenWidth, [PUtil getActualHeight:110]);
    [self.view addSubview:_commentView];
    
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
    [sendBtn addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    [_commentView addSubview:sendBtn];

    
    _hintLabel = [[UILabel alloc]init];
    _hintLabel.text = @"发表评论";
    _hintLabel.textColor = c08_text;
    _hintLabel.alpha = 0.5f;
    _hintLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _hintLabel.frame =  CGRectMake([PUtil getActualWidth:46], [PUtil getActualHeight:32], [PUtil getActualHeight:140] , [PUtil getActualHeight:46]);
    [_commentView addSubview:_hintLabel];
    
    _scrollerView.scrollEnabled = YES;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _tableView){
        return [datas count];
    }
    return [commandDatas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _tableView){
        return CommentCellHeight;
    }
    return MoreCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _moreTableView){
        NewsDetailPage *page = [[NewsDetailPage alloc]init];
        page.newsModel = [commandDatas objectAtIndex:indexPath.row];
        [self pushPage:page];
        [UMUtil clickEvent:EVENT_DETAIL_MORE];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _tableView){
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommentCell identify]];
        if(cell == nil){
            cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CommentCell identify] delegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CommentListModel *model = [datas objectAtIndex:indexPath.row];
        [cell setData:model];
        return cell;
    }else{
        NewsCell *cell =  [tableView dequeueReusableCellWithIdentifier:[NewsCell identify]];
        if(cell == nil){
            cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewsCell identify]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NewsModel *model = [commandDatas objectAtIndex:indexPath.row];
        [cell setData:model];
        return cell;
    }
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
    [self addComment];
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


-(void)requestNew
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    index = 0;
    [self requestComment : NO];
}

-(void)requestMore
{
    [_scrollerView.mj_header endRefreshing];
    [_scrollerView.mj_footer endRefreshing];
    [self requestComment : YES];
}

-(void)requestData : (Boolean)updateComment{
    NSString *urlStr = [NSString stringWithFormat:@"%@%ld",API_NEWS_DETAIL,_newsModel.news_id];
    [ByNetUtil get:urlStr parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            model = [NewsDetailModel mj_objectWithKeyValues:data];
            if(updateComment){
                [_commentTitleView setTitle:[NSString stringWithFormat:@"评论（%d）",model.comment_count]];
            }else{
                [self initView];
            }
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    if([url.absoluteString isEqualToString:@"http://kpl.qq.com/"]){
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView{
    if(_webView.isLoading){
        return;
    }
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#252845'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#FFFFFF'"];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WebViewHeight = [webView sizeThatFits:webView.frame.size].height + [PUtil getActualWidth:20];
//        WebViewHeight = [webView sizeThatFits:CGSizeZero].height + [PUtil getActualWidth:20];
        CGRect WebViewRect = CGRectMake([PUtil getActualWidth:20], _topView.height, ScreenWidth-[PUtil getActualWidth:40], WebViewHeight);
        WebViewRect.size.height = WebViewHeight;
        _scrollerView.contentSize = CGSizeMake(ScreenWidth,_topView.height+CommentCellHeight* [datas count]+ TitleHeight +WebViewHeight);
        _webView.frame = WebViewRect;
        _webScrollView.contentSize = CGSizeMake(ScreenWidth, WebViewHeight);
        
        _webView.hidden = NO;
        
        [self requestCommandList];
    });


}

-(void)requestComment : (Boolean) isRequestMore{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"index"] = @(index);
    dic[@"size"] = @(REREQUESTSIZE);
    dic[@"target_id"] = [NSString stringWithFormat:@"%ld",_newsModel.news_id];
    dic[@"tp"] = @"news";
    [ByNetUtil get:API_COMMENT parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            id items = [data objectForKey:@"items"];
            index = [[data objectForKey:@"index"] intValue];
            if(isRequestMore){
                NSArray *temps = [CommentListModel mj_objectArrayWithKeyValuesArray:items];
                if([temps count] == 0){
                    [_scrollerView.mj_footer endRefreshingWithNoMoreData];
                }
                [datas addObjectsFromArray:temps];
            }else{
                datas = [CommentListModel mj_objectArrayWithKeyValuesArray:items];
            }
            _tableView.frame = CGRectMake(0, _commentTitleView.mj_y+_commentTitleView.mj_h, ScreenWidth, [datas count] *CommentCellHeight);
            if(IS_NS_STRING_EMPTY(model.video)){
                _scrollerView.contentSize = CGSizeMake(ScreenWidth, _topView.height + WebViewHeight + MoreCellHeight * [commandDatas count]+CommentCellHeight* [datas count] +TitleHeight*2);
            }else{
                _scrollerView.contentSize = CGSizeMake(ScreenWidth, _topView.height + MoreCellHeight* [commandDatas count]+CommentCellHeight* [datas count]+ScreenWidth *ScreenWidth / ScreenHeight +TitleHeight*2);
            }
            [_tableView reloadData];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)addComment{
    if(IS_NS_STRING_EMPTY(_commentTextField.text)){
        [DialogHelper showWarnTips:@"请输入评论内容"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"content"] = _commentTextField.text;
    dic[@"tp"] = @"news";
    dic[@"target_id"] = [NSString stringWithFormat:@"%ld",_newsModel.news_id];
    [ByNetUtil post:API_ADDCOMMENT parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [DialogHelper showSuccessTips:@"发送成功!"];
            [self requestNew];
            [self requestData : YES];
            _commentTextField.text = @"";
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"评论失败"];
    }];
    [UMUtil clickEvent:EVENT_COMMENT];

}


//-(BOOL)playerViewShouldPlay{
//    return YES;
//}

//// 当前播放的
//- (void)playerView:(RHPlayerView *)playView didPlayVideo:(RHVideoModel *)videoModel index:(NSInteger)index{
//
//}
//// 当前播放结束的
//- (void)playerView:(RHPlayerView *)playView didPlayEndVideo:(RHVideoModel *)videoModel index:(NSInteger)index {
//
//
//}
//// 当前正在播放的,会调用多次,更新当前播放时间
//- (void)playerView:(RHPlayerView *)playView didPlayVideo:(RHVideoModel *)videoModel playTime:(NSTimeInterval)playTime {
//
//}


-(void)onBackClick{
    if(_playView){
        [_playView resetPlayer];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)onLikeClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(model.is_like){
        [self doUnlike];
    }else{
        [self doLike];
    }
}


-(void)doLike{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"news_id"] = @(_newsModel.news_id);
    [ByNetUtil post:API_NEWS_LIKE parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [_barView setLike:YES];
            model.is_like = true;
            [DialogHelper showSuccessTips:@"点赞成功"];
        }else{
            [DialogHelper showFailureAlertSheet:@"点赞失败"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"点赞失败"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [UMUtil clickEvent:EVENT_DETAIL_PRAISE];
}


-(void)doUnlike{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"news_id"] = @(_newsModel.news_id);
    [ByNetUtil post:API_NEWS_UNLIKE parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [_barView setLike:NO];
            model.is_like = false;
            [DialogHelper showSuccessTips:@"取消点赞成功"];
        }else{
            [DialogHelper showFailureAlertSheet:@"取消点赞失败"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [DialogHelper showFailureAlertSheet:@"取消点赞失败"];
    }];
    
    [UMUtil clickEvent:EVENT_DETAIL_CANCEL_PRAISE];
}


-(void)onCommentLikeClick:(long)comment_id{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for(CommentListModel *model in datas){
        CommentModel *commentModel = [CommentModel mj_objectWithKeyValues:model.comment];
        if(commentModel.comment_id == comment_id){
            if(commentModel.is_like){
                [self doCommentUnLike:comment_id];
            }else{
                [self doCommentLike:comment_id];
            }
            break;
        }
    }
}

-(void)doCommentLike : (long)comment_id{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"comment_id"] = @(comment_id);
    [ByNetUtil post:API_COMMENT_LIKE parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [self updateCommentData:comment_id like:true];
            [DialogHelper showSuccessTips:@"点赞成功"];
        }else{
            [DialogHelper showFailureAlertSheet:@"点赞失败"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [DialogHelper showFailureAlertSheet:@"点赞失败"];
    }];
    [UMUtil clickEvent:EVENT_COMMENT_PRAISE];

}


-(void)doCommentUnLike : (long)comment_id{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"comment_id"] = @(comment_id);
    [ByNetUtil post:API_COMMENT_UNLIKE parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [self updateCommentData:comment_id like:false];
            [DialogHelper showSuccessTips:@"取消点赞成功"];
        }else{
            [DialogHelper showFailureAlertSheet:@"取消点赞失败"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"取消点赞失败"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [UMUtil clickEvent:EVENT_COMMENT_CANCEL_PRAISE];

}


-(void)updateCommentData : (long)comment_id like:(bool)isLike{
    for(CommentListModel *model in datas){
        CommentModel *commentModel = [CommentModel mj_objectWithKeyValues:model.comment];
        if(commentModel.comment_id == comment_id){
            commentModel.is_like  = isLike;
            if(isLike){
                commentModel.like_count +=1;
            }else{
                commentModel.like_count -=1;
            }
            model.comment = commentModel;
            break;
        }
    }
    [_tableView reloadData];

}


-(void)requestCommandList{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%ld",API_NEWS_COMMOND,@"wangzhe",model.news_id];
    [ByNetUtil get:urlStr parameters:nil success:^(RespondModel *respondModel) {
        id items = [respondModel.data objectForKey:@"items"];
        commandDatas = [NewsModel mj_objectArrayWithKeyValuesArray:items];
        [self initMore];
        [_moreTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//     CGFloat offsetY = scrollView.contentOffset.y;
//    if(offsetY > WebViewHeight){
//        __weak UIView *tempView = _commentView;
//        [UIView animateWithDuration:0.3f animations:^{
//            tempView.frame = CGRectMake(0, ScreenHeight - [PUtil getActualHeight:110], ScreenWidth, [PUtil getActualHeight:110]);
//
//        }];
//    }else{
//        __weak UIView *tempView = _commentView;
//        [UIView animateWithDuration:0.3f animations:^{
//            tempView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, [PUtil getActualHeight:110]);
//
//        }];
//    }
//    NSLog(@"这是啥%f",offsetY);
//}


@end
