//
//  GoodsDetailPage.m
//  gogo
//
//  Created by by.huang on 2017/11/9.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GoodsDetailPage.h"
#import "BarView.h"
#import "RespondModel.h"
#import "GoodDetailModel.h"

@interface GoodsDetailPage()

@property (strong, nonatomic) BarView *barView;
@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *coinLabel;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) UILabel *introduceLabel;
@property (strong, nonatomic) UIView *introduceView;
@property (strong, nonatomic) UIButton *exchangeBtn;


@end

@implementation GoodsDetailPage{
    GoodDetailModel *detailModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    detailModel = [[GoodDetailModel alloc]init];
    [self initView];
    [self requestDetail];
}

-(void)initView{
    
    _barView = [[BarView alloc]initWithTitle:@"商品详情" page:self];
    [self.view addSubview:_barView];
    
    int height = _barView.mj_h + _barView.mj_y;
    _scrollerView = [[UIScrollView alloc]init];
    _scrollerView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight - height);
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.backgroundColor = c06_backgroud;
    _scrollerView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight);
    [self.view addSubview:_scrollerView];
    
    
    _imageView = [[UIImageView alloc]init];
    _imageView.frame = CGRectMake(0,0, ScreenWidth, [PUtil getActualHeight:300]);
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [_scrollerView addSubview:_imageView];
    
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, [PUtil getActualHeight:300], ScreenWidth,[PUtil getActualHeight:182]);
    titleView.backgroundColor = c07_bar;
    [_scrollerView addSubview:titleView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.frame =  CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30], ScreenWidth -[PUtil getActualWidth:30] *2, [PUtil getActualHeight:48]);
    _titleLabel.textColor = c08_text;
    _titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
    [titleView addSubview:_titleLabel];
    
    _coinLabel = [[UILabel alloc]init];
    _coinLabel.frame =  CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:78], [PUtil getActualWidth:500], [PUtil getActualHeight:84]);
    _coinLabel.textColor = c03_yellow;
    _coinLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:60]];
    [titleView addSubview:_coinLabel];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = c08_text;
    _countLabel.alpha = 0.5f;
    _countLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [titleView addSubview:_countLabel];
    
    UILabel *introduceTitleLabel = [[UILabel alloc]init];
    introduceTitleLabel.frame =  CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30] + titleView.mj_h + titleView.mj_y, ScreenWidth - [PUtil getActualWidth:30], [PUtil getActualHeight:40]);
    introduceTitleLabel.textColor = c09_tips;
    introduceTitleLabel.text = @"详情说明";
    introduceTitleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    [_scrollerView addSubview:introduceTitleLabel];
    
    
    _introduceView = [[UIView alloc]init];
//    _introduceView.frame = CGRectMake(0, [PUtil getActualHeight:86]+ titleView.mj_h + titleView.mj_y, ScreenWidth,[PUtil getActualHeight:500]);
    _introduceView.backgroundColor = c07_bar;
    [_scrollerView addSubview:_introduceView];
    
    _introduceLabel = [[UILabel alloc]init];
    _introduceLabel.textColor = c08_text;
    _introduceLabel.numberOfLines = 0;
    _introduceLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _introduceLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
    [_introduceView addSubview:_introduceLabel];
    
    
    _exchangeBtn = [[UIButton alloc]init];
    _exchangeBtn.frame = CGRectMake(0, ScreenHeight- [PUtil getActualHeight:110],ScreenWidth , [PUtil getActualHeight:110]);
    [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [_exchangeBtn addTarget:self action:@selector(doExchange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exchangeBtn];
    [ColorUtil setGradientColor:_exchangeBtn startColor:c01_blue endColor:c02_red director:Left];
}

-(void)updateUI{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:detailModel.cover]];
    _titleLabel.text = detailModel.title;
    
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld竞猜币",detailModel.coin]];
    NSRange redRangeTwo = NSMakeRange(noteStr.length - 3, 3);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[PUtil getActualHeight:24]] range:redRangeTwo];
    [_coinLabel setAttributedText:noteStr];
    [_coinLabel sizeToFit];
    
    _countLabel.text = [NSString stringWithFormat:@"剩余：%ld",(detailModel.total - detailModel.total_apply)];
    _countLabel.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:30] - _countLabel.contentSize.width ,[PUtil getActualHeight:117] , _countLabel.contentSize.width, _countLabel.contentSize.height);
    
    _introduceLabel.text = detailModel.introduce;
    CGSize titleSize = [_introduceLabel.text boundingRectWithSize:CGSizeMake( ScreenWidth - [PUtil getActualWidth:30]*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[PUtil getActualHeight:30]]} context:nil].size;
    _introduceLabel.frame =  CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30], ScreenWidth - [PUtil getActualWidth:30]*2, titleSize.height);
    
    _introduceView.frame = CGRectMake(0, [PUtil getActualHeight:268]+ _imageView.mj_h + _imageView.mj_y, ScreenWidth,titleSize.height + [PUtil getActualHeight:30] * 2);
}

-(void)requestDetail{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%ld",API_GOODS_DETAIL,_goods_id];
    [ByNetUtil get:requestUrl parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            detailModel = [GoodDetailModel mj_objectWithKeyValues:data];
            [self updateUI];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
    }];
}

-(void)doExchange{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%ld",API_EXCHANGE,_goods_id];
    [ByNetUtil post:requestUrl parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [DialogHelper showSuccessTips:@"兑换成功"];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
    }];
    [UMUtil clickEvent:EVENT_EXCHANGE];
}

@end
