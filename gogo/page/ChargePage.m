//
//  ChargePage.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ChargePage.h"
#import "BarView.h"
#import "PriceCell.h"
#import "PayCell.h"
#import "RespondModel.h"
#import "PayModel.h"
#import "WXApi.h"
#import "WechatPayModel.h"
#import<CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "OkAlertView.h"

@interface ChargePage ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BarView *barView;
@property (strong, nonatomic) UITableView *priceTableView;
@property (strong, nonatomic) UITableView *payTableView;
@property (strong, nonatomic) UIButton *payBtn;

@end

@implementation ChargePage{
    NSArray *priceArray;
    NSArray *payArray;
    NSArray *payImages;
    NSInteger priceSelect;
    NSInteger paySelect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    priceArray = [[NSMutableArray alloc]init];
    payArray = @[@"微信支付",@"支付宝支付"];
    payImages = @[@"ic_wxpay_29",@"ic_alipay_29"];
    [self initView];
    [self requestPayList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnWechatPaySuccess) name:NOTIFY_WECAHT_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnWechatPayFail) name:NOTIFY_WECAHT_PAY_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnAlipayPaySuccess) name:NOTIFY_ALIPAY_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnAliPayPayFail) name:NOTIFY_ALIPAY_PAY_FAIL object:nil];


}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFY_WECAHT_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFY_WECAHT_PAY_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFY_ALIPAY_PAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFY_ALIPAY_PAY_FAIL object:nil];
}

-(void)initView{
    _barView = [[BarView alloc]initWithTitle:@"充值" page:self];
    [self.view addSubview:_barView];

    int height = _barView.mj_h+_barView.mj_y;
    UILabel *priceTitle = [[UILabel alloc]init];
    priceTitle.text = @"请选择充值的数量";
    priceTitle.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    priceTitle.textColor = c09_tips;
    priceTitle.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30] + height, ScreenWidth - [PUtil getActualWidth:30], [PUtil getActualHeight:40]);
    [self.view addSubview:priceTitle];
    
    _priceTableView = [[UITableView alloc]init];
    _priceTableView.frame = CGRectMake(0,  [PUtil getActualHeight:86] + height, ScreenWidth, 4*[PUtil getActualHeight:110]);
    _priceTableView.delegate = self;
    _priceTableView.dataSource = self;
    _priceTableView.backgroundColor = c06_backgroud;
    [_priceTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_priceTableView];
    
    UILabel *payTitle = [[UILabel alloc]init];
    payTitle.text = @"请选择支付方式";
    payTitle.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    payTitle.textColor = c09_tips;
    payTitle.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:556] + height, ScreenWidth - [PUtil getActualWidth:30], [PUtil getActualHeight:40]);
    [self.view addSubview:payTitle];
    
    _payTableView = [[UITableView alloc]init];
    _payTableView.frame = CGRectMake(0,  [PUtil getActualHeight:612] + height, ScreenWidth, [payArray count]*[PUtil getActualHeight:110]);
    _payTableView.delegate = self;
    _payTableView.dataSource = self;
    _payTableView.scrollEnabled = NO;
    [_payTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_payTableView];
    
    _payBtn = [[UIButton alloc]init];
    _payBtn.frame = CGRectMake((ScreenWidth - [PUtil getActualWidth:542])/2, [PUtil getActualHeight:892] + height,[PUtil getActualWidth:542] , [PUtil getActualHeight:100]);
    [_payBtn setTitle:@"支付" forState:UIControlStateNormal];
    _payBtn.layer.masksToBounds = YES;
    _payBtn.layer.cornerRadius = [PUtil getActualHeight:100]/2;
    [_payBtn addTarget:self action:@selector(doPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_payBtn];
    [ColorUtil setGradientColor:_payBtn startColor:c01_blue endColor:c02_red director:Left];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _priceTableView){
        return [priceArray count];
    }else{
        return [payArray count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PUtil getActualHeight:110];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _priceTableView){
        priceSelect = indexPath.row;
    }else{
        paySelect = indexPath.row;
    }
    [tableView reloadData];

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _priceTableView){
        PriceCell *cell =  [tableView dequeueReusableCellWithIdentifier:[PriceCell identify]];
        if(cell == nil){
            cell = [[PriceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PriceCell identify]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.row == [priceArray count]-1){
            [cell setData:[priceArray objectAtIndex:indexPath.row] hideline:YES];
        }else{
            [cell setData:[priceArray objectAtIndex:indexPath.row] hideline:NO];
        }
        if(priceSelect == indexPath.row){
            [cell setSelect:YES];
        }else{
            [cell setSelect:NO];
        }
        return cell;
    }else{
        PayCell *cell =  [tableView dequeueReusableCellWithIdentifier:[PayCell identify]];
        if(cell == nil){
            cell = [[PayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PayCell identify]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.row == [payArray count]-1){
            [cell setData:[payArray objectAtIndex:indexPath.row] hideline:YES image:[payImages objectAtIndex:indexPath.row]];
        }else{
            [cell setData:[payArray objectAtIndex:indexPath.row] hideline:NO image:[payImages objectAtIndex:indexPath.row]];
        }
        if(paySelect == indexPath.row){
            [cell setSelect:YES];
        }else{
            [cell setSelect:NO];
        }
        return cell;
    }
}

-(void)requestPayList{
    [ByNetUtil get:API_PAYLIST parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            priceArray = [PayModel mj_objectArrayWithKeyValuesArray:data];
            _priceTableView.contentSize = CGSizeMake(ScreenWidth, [payArray count]*[PUtil getActualHeight:110]);
            [_priceTableView reloadData];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败!"];
    }];
}

-(void)doPay{
    if(paySelect == 0){
        [self doWechatPay];
    }else{
        [self doAliPay];
    }
}

-(void)doWechatPay{
    PayModel *model = [priceArray objectAtIndex:priceSelect];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%ld",API_WECAHT_PAY,model.coin_plan_id];
    [ByNetUtil post:requestUrl parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == CODE_SUCCESS){
            id data = respondModel.data;
            WechatPayModel *payModel = [WechatPayModel mj_objectWithKeyValues:data];
            PayReq *request = [[PayReq alloc]init];
            request.openID = payModel.app_id;
            request.partnerId = payModel.partner_id;
            request.prepayId = payModel.prepay_id;
            request.nonceStr = payModel.nonce_str;
            request.timeStamp = [payModel.timestamp intValue];
            request.package = payModel.package;
            request.sign = payModel.sign;
            [WXApi sendReq:request];
        }else if(respondModel.code == CODE_TOKEN_INVAILD){
            [self goLoginPage];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败!"];
    }];
}

-(void)doAliPay{
    PayModel *model = [priceArray objectAtIndex:priceSelect];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%ld",API_ALIPAY,model.coin_plan_id];
    [ByNetUtil post:requestUrl parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            [[AlipaySDK defaultService]payOrder:data fromScheme:@"gogo" callback:^(NSDictionary *resultDic) {
                if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]){
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_ALIPAY_PAY_SUCCESS object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_ALIPAY_PAY_FAIL object:nil];
                }
            }];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败!"];

    }];
}


-(void)OnWechatPaySuccess{
    PayModel *model = [priceArray objectAtIndex:priceSelect];
    OkAlertView *alertView = [[OkAlertView alloc]initWithTitle:@"支付结果" content:[NSString stringWithFormat:@"充值成功！获得%ld竞猜币",model.coin_count]];
    [self.view addSubview:alertView];
}

-(void)OnWechatPayFail{
    OkAlertView *alertView = [[OkAlertView alloc]initWithTitle:@"支付结果" content:@"充值失败！请重试"];
    [self.view addSubview:alertView];
}


-(void)OnAlipayPaySuccess{
    PayModel *model = [priceArray objectAtIndex:priceSelect];
    OkAlertView *alertView = [[OkAlertView alloc]initWithTitle:@"支付结果" content:[NSString stringWithFormat:@"充值成功！获得%ld竞猜币",model.coin_count]];
    [self.view addSubview:alertView];
}

-(void)OnAliPayPayFail{
    OkAlertView *alertView = [[OkAlertView alloc]initWithTitle:@"支付结果" content:@"充值失败！请重试"];
    [self.view addSubview:alertView];
}


@end
