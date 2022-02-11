//
//  ChargePage2.m
//  gogo
//
//  Created by by.huang on 2018/3/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ChargePage2.h"
#import "BarView.h"
#import "RespondModel.h"
#import "PayModel.h"
#import "WXApi.h"
#import "WechatPayModel.h"
#import<CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "OkAlertView.h"
#import "ChargeCell.h"


@interface ChargePage2 ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) BarView *barView;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation ChargePage2{
    NSMutableArray *datas;
    NSUInteger priceSelect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = [PUtil getActualWidth:30];
    layout.minimumInteritemSpacing = [PUtil getActualWidth:30];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, StatuBarHeight + [PUtil getActualHeight:88], ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:88]) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = c06_backgroud;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[ChargeCell class] forCellWithReuseIdentifier:[ChargeCell identify]];
    
    [self requestPayList];
}

-(void)requestPayList{
    [ByNetUtil get:API_PAYLIST parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            datas = [PayModel mj_objectArrayWithKeyValuesArray:data];
            [_collectionView reloadData];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败!"];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [datas count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ChargeCell identify] forIndexPath:indexPath];
    cell.backgroundColor = c01_blue;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = [PUtil getActualHeight:10];
    [cell setData:[datas objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake([PUtil getActualWidth:330], [PUtil getActualWidth:400]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake([PUtil getActualWidth:30], [PUtil getActualWidth:30], [PUtil getActualWidth:30], [PUtil getActualWidth:30]);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    priceSelect = indexPath.row;
    [self showPay];
}

-(void)showPay{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择支付方式"
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
    UIAlertAction* wechatAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self doWechatPay];
                                                         }];
    UIAlertAction* alipayAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self doAliPay];
                                                             
                                                         }];
    [alert addAction:wechatAction];
    [alert addAction:alipayAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)doWechatPay{
    PayModel *model = [datas objectAtIndex:priceSelect];
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
    PayModel *model = [datas objectAtIndex:priceSelect];
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
    PayModel *model = [datas objectAtIndex:priceSelect];
    OkAlertView *alertView = [[OkAlertView alloc]initWithTitle:@"支付结果" content:[NSString stringWithFormat:@"获得%@ x1(赠送%ld竞猜币)",model.gift_name,model.coin_count]];
    [self.view addSubview:alertView];
}

-(void)OnWechatPayFail{
    OkAlertView *alertView = [[OkAlertView alloc]initWithTitle:@"支付结果" content:@"购买礼物失败！请重试"];
    [self.view addSubview:alertView];
}


-(void)OnAlipayPaySuccess{
    PayModel *model = [datas objectAtIndex:priceSelect];
    OkAlertView *alertView = [[OkAlertView alloc]initWithTitle:@"支付结果" content:[NSString stringWithFormat:@"获得%@ x1(赠送%ld竞猜币)",model.gift_name,model.coin_count]];
    [self.view addSubview:alertView];
}

-(void)OnAliPayPayFail{
    OkAlertView *alertView = [[OkAlertView alloc]initWithTitle:@"支付结果" content:@"购买礼物失败！请重试"];
    [self.view addSubview:alertView];
}


@end
