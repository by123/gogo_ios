//
//  MinePage.m
//  gogo
//
//  Created by by.huang on 2017/10/22.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "MineView.h"
#import "MineCell.h"
#import "LoginPage.h"
#import "TouchScrollView.h"
#import "AccountManager.h"
#import "RespondModel.h"
#import "SignView.h"

@interface MineView ()<UITableViewDelegate,UITableViewDataSource,SignViewDelegate>

@property (strong, nonatomic) TouchScrollView *scrollerView;
@property (strong, nonatomic) UIImageView *userView;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *nickNameLabel;
@property (strong, nonatomic) UILabel *coinLabel;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MineView{
    NSArray *datas;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        datas = @[@"充值",@"地址信息",@"竞猜历史",@"兑换记录",@"设置"];
        [self initView];
    }
    return self;
}


-(void)initView{
    
    UserModel *model = [[AccountManager sharedAccountManager]getUserInfo];
    
    _scrollerView = [[TouchScrollView alloc]initWithParentView:self];
    _scrollerView.frame = self.frame;
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight);
    [self addSubview:_scrollerView];
    
    _userView = [[UIImageView alloc]init];
    _userView.frame = CGRectMake(0, [PUtil getActualHeight:20], ScreenWidth, [PUtil getActualHeight:272]);
    _userView.backgroundColor = c07_bar;
    _userView.contentMode = UIViewContentModeScaleAspectFill;
//    if(!IS_NS_STRING_EMPTY(model.avatar)){
//        [_userView sd_setImageWithURL:[NSURL URLWithString:model.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            _userView.image = [ColorUtil boxblurImage:image withBlurNumber:0.5f];
//
//        }];
//    }

    _userView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goPersonalPage)];
    [_userView addGestureRecognizer:recognizer];
    [_scrollerView addSubview:_userView];
    
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake([PUtil getActualWidth:40], [PUtil getActualHeight:56], [PUtil getActualWidth:160], [PUtil getActualWidth:160]);
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"ic_default_head"]];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = [PUtil getActualWidth:160]/2;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_userView addSubview:_headImageView];
    
    _nickNameLabel = [[UILabel alloc]init];
    _nickNameLabel.text = model.username;
    _nickNameLabel.textColor = c08_text;
    _nickNameLabel.frame = CGRectMake([PUtil getActualWidth:240], [PUtil getActualHeight:55], ScreenWidth - [PUtil getActualWidth:240], [PUtil getActualHeight:67]);
    _nickNameLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:48]];
    [_userView addSubview:_nickNameLabel];
    
    UILabel *coinTitleLabel = [[UILabel alloc]init];
    coinTitleLabel.text = @"竞猜币";
    coinTitleLabel.textColor = c09_tips;
    coinTitleLabel.frame = CGRectMake([PUtil getActualWidth:240], [PUtil getActualHeight:122], ScreenWidth - [PUtil getActualWidth:240], [PUtil getActualHeight:40]);
    coinTitleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    [_userView addSubview:coinTitleLabel];

    
    UIImageView *coinImageView = [[UIImageView alloc]init];
    coinImageView.image = [UIImage imageNamed:@"ic_coin"];
    coinImageView.frame = CGRectMake([PUtil getActualWidth:240], [PUtil getActualHeight:165], [PUtil getActualHeight:50], [PUtil getActualHeight:50]);
    [_userView addSubview:coinImageView];

    _coinLabel = [[UILabel alloc]init];
    _coinLabel.text = model.coin;
    _coinLabel.textColor = c15_text3;
    _coinLabel.frame = CGRectMake([PUtil getActualWidth:300], [PUtil getActualHeight:162], ScreenWidth - [PUtil getActualWidth:240], [PUtil getActualHeight:56]);
    _coinLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:40]];
    [_userView addSubview:_coinLabel];
    
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0,  [PUtil getActualHeight:312], ScreenWidth, [datas count]*[PUtil getActualHeight:110]);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_scrollerView addSubview:_tableView];
    

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [datas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PUtil getActualHeight:110];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goPage : indexPath.row];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell *cell =  [tableView dequeueReusableCellWithIdentifier:[MineCell identify]];
    if(cell == nil){
        cell = [[MineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MineCell identify]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row == [datas count]-1){
        [cell setData:[datas objectAtIndex:indexPath.row] hideline:YES];
    }else{
        [cell setData:[datas objectAtIndex:indexPath.row] hideline:NO];
    }
    return cell;
}


-(void)goPage : (NSInteger)index{
    if(_handleDelegate){
        switch (index) {
            case 0:
                [_handleDelegate goChargePage];
                [UMUtil clickEvent:EVENT_CHARGE];
                break;
            case 1:
                [_handleDelegate goAddressPage];
                [UMUtil clickEvent:EVENT_ADDRESS];
                break;
            case 2:
                [_handleDelegate goHistoryPage];
                [UMUtil clickEvent:EVENT_GUESS_HISTORY];
                break;
            case 3:
                [_handleDelegate goExchangePage];
                [UMUtil clickEvent:EVENT_EXCHANGE_HISTORY];
                break;
            case 4:
                [_handleDelegate goSettingPage];
                [UMUtil clickEvent:EVENT_SETTING];
                break;
            default:
                break;
        }
    }
}

-(void)goPersonalPage{
    if(_handleDelegate){
        [_handleDelegate goPersonalPage];
    }
}

-(void)updateUserInfo{
    UserModel *model = [[AccountManager sharedAccountManager]getUserInfo];
    _nickNameLabel.text = model.username;
    _coinLabel.text = model.coin;
    if(!IS_NS_STRING_EMPTY(model.avatar)){
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        [_userView sd_setImageWithURL:[NSURL URLWithString:model.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _userView.image = [ColorUtil boxblurImage:image withBlurNumber:0.5f];
            
        }];
    }
    
}

@end
