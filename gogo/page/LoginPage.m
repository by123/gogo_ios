//
//  LoginPage.m
//  gogo
//
//  Created by by.huang on 2017/10/20.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "LoginPage.h"
#import "AccountManager.h"
#import "MainPage.h"
#import "RespondModel.h"
#import "LoginModel.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface LoginPage ()<UITextFieldDelegate,TencentSessionDelegate>

@property (strong, nonatomic) UIImageView *mLogoImage;
@property (strong, nonatomic) UILabel     *mPhoneLabel;
@property (strong, nonatomic) UITextField *mPhoneText;
@property (strong, nonatomic) UILabel     *mVerifyLabel;
@property (strong, nonatomic) UITextField *mVerifyText;
@property (strong, nonatomic) UIButton    *mGetVerifyBtn;
@property (strong, nonatomic) UIButton    *mLoginBtn;
@property (strong, nonatomic) UILabel     *mThirdText;
@property (strong, nonatomic) UIButton    *mWechatBtn;
@property (strong, nonatomic) UIButton    *mQQBtn;
@property (strong, nonatomic) UILabel     *mDisclaimerText;
@property (strong, nonatomic) TencentOAuth *tencentOAuth;


@end

@implementation LoginPage{
    NSTimer *timer;
    int time;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStatuBarBackgroud:[ColorUtil colorWithHexString:@"#120e1e"]];
    [self initView];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onWechatLoginCallback) name:NOTIFY_WECAHT_CALLBACK object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFY_WECAHT_CALLBACK object:nil];
}

-(void)initView{
    [ColorUtil setGradientColor:self.view startColor:c11_bg1 endColor:c12_bg2 director:Top];
    _mLogoImage = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"etc_logo_200"];
    _mLogoImage.image = image;
    if(IS_IPHONE_X){
        _mLogoImage.frame = CGRectMake((ScreenWidth - [PUtil getActualWidth:320])/2, [PUtil getActualHeight:190], [PUtil getActualWidth:320], [PUtil getActualWidth:320]);
    }else{
         _mLogoImage.frame = CGRectMake([PUtil getActualWidth:255], [PUtil getActualHeight:190], [PUtil getActualWidth:240], [PUtil getActualWidth:240]);
    }
    _mLogoImage.layer.masksToBounds = YES;
    _mLogoImage.layer.cornerRadius =  [PUtil getActualWidth:40]/2;
    [self.view addSubview:_mLogoImage];
    
    UIView *phoneView = [[UIView alloc]init];
    phoneView = [[UITextField alloc]init];
    phoneView.layer.borderWidth = 1;
    phoneView.layer.borderColor = c13_text1.CGColor;
    phoneView.userInteractionEnabled = NO;
    phoneView.frame = CGRectMake([PUtil getActualWidth:89], [PUtil getActualHeight:552], [PUtil getActualWidth:572], [PUtil getActualHeight:100]);
    phoneView.layer.masksToBounds = YES;
    phoneView.layer.cornerRadius = [PUtil getActualHeight:100]/2;
    [self.view addSubview:phoneView];
    
    _mPhoneLabel = [[UILabel alloc]init];
    if(IS_IPHONE_X){
       _mPhoneLabel.frame = CGRectMake([PUtil getActualWidth:119], [PUtil getActualHeight:578], [PUtil getActualWidth:200], [PUtil getActualHeight:48]);
    }else{
       _mPhoneLabel.frame = CGRectMake([PUtil getActualWidth:119], [PUtil getActualHeight:578], [PUtil getActualWidth:120], [PUtil getActualHeight:48]);
    }
    _mPhoneLabel.text = @"手机号";
    _mPhoneLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _mPhoneLabel.alpha = 0.5;
    _mPhoneLabel.textColor = c08_text;
    [self.view addSubview:_mPhoneLabel];

    _mPhoneText = [[UITextField alloc]init];
    _mPhoneText.frame = CGRectMake([PUtil getActualWidth:119], [PUtil getActualHeight:552], [PUtil getActualWidth:572-230], [PUtil getActualHeight:100]);
    _mPhoneText.textColor = c08_text;
    _mPhoneText.keyboardType =UIKeyboardTypeNumberPad;
    _mPhoneText.delegate = self;
    [self.view addSubview:_mPhoneText];
    
    _mGetVerifyBtn = [[UIButton alloc]init];
    [_mGetVerifyBtn setTintColor:c08_text];
    [_mGetVerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _mGetVerifyBtn.titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _mGetVerifyBtn.frame = CGRectMake([PUtil getActualWidth:450],  [PUtil getActualHeight:552], [PUtil getActualWidth:185], [PUtil getActualHeight:100]);
    [_mGetVerifyBtn addTarget:self action:@selector(OnGetVerify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mGetVerifyBtn];
    
    UIView *verifyView = [[UIView alloc]init];
    verifyView = [[UITextField alloc]init];
    verifyView.layer.borderWidth = 1;
    verifyView.userInteractionEnabled = NO;
    verifyView.layer.borderColor = c13_text1.CGColor;
    verifyView.frame = CGRectMake([PUtil getActualWidth:89], [PUtil getActualHeight:682], [PUtil getActualWidth:572], [PUtil getActualHeight:100]);
    verifyView.layer.masksToBounds = YES;
    verifyView.layer.cornerRadius = [PUtil getActualHeight:100]/2;
    [self.view addSubview:verifyView];

    
    _mVerifyLabel = [[UILabel alloc]init];
    if(IS_IPHONE_X){
        _mVerifyLabel.frame = CGRectMake([PUtil getActualWidth:119], [PUtil getActualHeight:708], [PUtil getActualWidth:200], [PUtil getActualHeight:48]);
    }else{
        _mVerifyLabel.frame = CGRectMake([PUtil getActualWidth:119], [PUtil getActualHeight:708], [PUtil getActualWidth:120], [PUtil getActualHeight:48]);
    }
    _mVerifyLabel.text = @"验证码";
    _mVerifyLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _mVerifyLabel.alpha = 0.5;
    _mVerifyLabel.textColor = c08_text;
    [self.view addSubview:_mVerifyLabel];
    
    _mVerifyText = [[UITextField alloc]init];
    _mVerifyText.frame = CGRectMake([PUtil getActualWidth:119], [PUtil getActualHeight:682], [PUtil getActualWidth:572-230], [PUtil getActualHeight:100]);
    _mVerifyText.textColor = c08_text;
    _mVerifyText.keyboardType =UIKeyboardTypeNumberPad;
    _mVerifyText.delegate = self;
    [self.view addSubview:_mVerifyText];
    
    _mLoginBtn = [[UIButton alloc]init];
    _mLoginBtn.frame = CGRectMake([PUtil getActualWidth:89], [PUtil getActualHeight:812], [PUtil getActualWidth:572], [PUtil getActualHeight:100]);
    [_mLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _mLoginBtn.layer.masksToBounds = YES;
    _mLoginBtn.layer.cornerRadius = [PUtil getActualHeight:100]/2;
    [_mLoginBtn addTarget:self action:@selector(OnLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mLoginBtn];
    [ColorUtil setGradientColor:_mLoginBtn startColor:c01_blue endColor:c02_red director:Left];

    _mThirdText = [[UILabel alloc]init];
    _mThirdText.text = @"其他登录方式";
    _mThirdText.alpha = 0.25f;
    _mThirdText.frame = CGRectMake(0, [PUtil getActualHeight:1069], ScreenWidth, [PUtil getActualHeight:28]);
    _mThirdText.textColor = c08_text;
    _mThirdText.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
    _mThirdText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_mThirdText];
    
    _mWechatBtn = [[UIButton alloc]init];
    _mWechatBtn.frame = CGRectMake([PUtil getActualWidth:246], [PUtil getActualHeight:1126], [PUtil getActualWidth:99], [PUtil getActualHeight:99]);
    [_mWechatBtn setImage:[UIImage imageNamed:@"ic_wx_50"] forState:UIControlStateNormal];
    [_mWechatBtn addTarget:self action:@selector(onWechatLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mWechatBtn];
    
    _mQQBtn = [[UIButton alloc]init];
    _mQQBtn.frame = CGRectMake([PUtil getActualWidth:405], [PUtil getActualHeight:1126], [PUtil getActualWidth:99], [PUtil getActualHeight:99]);
    [_mQQBtn setImage:[UIImage imageNamed:@"ic_qq_50"] forState:UIControlStateNormal];
    [_mQQBtn addTarget:self action:@selector(onQQLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mQQBtn];
    
    _mDisclaimerText = [[UILabel alloc]init];
    _mDisclaimerText.text = @"隐私策略及免责声明";
    _mDisclaimerText.frame = CGRectMake(0, [PUtil getActualHeight:1286], ScreenWidth, [PUtil getActualHeight:28]);
    _mDisclaimerText.textColor = c14_text2;
    _mDisclaimerText.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
    _mDisclaimerText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_mDisclaimerText];
    
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == _mPhoneText){
        _mPhoneLabel.hidden = YES;
    }else if(textField == _mVerifyText){
        _mVerifyLabel.hidden = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text isEqualToString:@""]){
        if(textField == _mPhoneText){
            _mPhoneLabel.hidden = NO;
        }else if(textField == _mVerifyText){
            _mVerifyLabel.hidden = NO;
        }
    }
}

-(void)OnGetVerify{
    if(IS_NS_STRING_EMPTY(_mPhoneText.text) || _mPhoneText.text.length != 11){
        [DialogHelper showWarnTips:@"请输入正确的手机号"];
        return;
    }
    time = 59;
    [self handleTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_mPhoneText.text forKey:@"tel"];
    [ByNetUtil post:API_GETVERIFY parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [DialogHelper showSuccessTips:@"获取验证码成功！"];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"获取验证码失败!"];
    }];
}

-(void)handleTimer{
    if(time >= 0){
        [_mGetVerifyBtn setUserInteractionEnabled:NO];
        _mGetVerifyBtn.alpha = 0.5f;
        NSString *text = [NSString stringWithFormat:@"重新获取(%ds)",time];
        [_mGetVerifyBtn setTitle:text forState:UIControlStateNormal];
    }else{
        [_mGetVerifyBtn setUserInteractionEnabled:YES];
        _mGetVerifyBtn.alpha = 1.0f;
        [_mGetVerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [timer invalidate];
    }
    time -- ;
}

-(void)OnLogin{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_mPhoneText.text forKey:@"tel"];
    [dic setObject:_mVerifyText.text forKey:@"code"];
    [ByNetUtil post:API_LOGIN parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            LoginModel *model = [LoginModel mj_objectWithKeyValues:data];
            //保存uid和token
            Account *account = [[Account alloc]init];
            account.uid = model.uid;
            account.access_token = model.access_token;
            account.refresh_token = model.refresh_token;
            [[AccountManager sharedAccountManager] saveAccount:account];
            [MobClick profileSignInWithPUID : model.uid];
            [DialogHelper showSuccessTips:@"登录成功!"];
            [self pushPage:[[MainPage alloc]init]];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"登录失败!"];
    }];
}

-(void)onWechatLogin{
    NSLog(@"微信登录");
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }
    else {
        [DialogHelper showFailureAlertSheet:@"您手机上未安装微信"];
    }
}

-(void)onWechatLoginCallback{
    Account *account = [[AccountManager sharedAccountManager] getAccount];
    if(account == nil || IS_NS_STRING_EMPTY(account.code)){
        [DialogHelper showFailureAlertSheet:@"授权失败，请重新授权"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"code"] = account.code;
    [ByNetUtil post:API_WECHAT_LOGIN parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            LoginModel *model = [LoginModel mj_objectWithKeyValues:data];
            //保存uid和token
            account.uid = model.uid;
            account.access_token = model.access_token;
            account.refresh_token = model.refresh_token;
            [[AccountManager sharedAccountManager] saveAccount:account];
            [MobClick profileSignInWithPUID : model.uid];
            [DialogHelper showSuccessTips:@"登录成功!"];
            [self pushPage:[[MainPage alloc]init]];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"登录失败!"];
    }];
}


-(void)onQQLogin{
    NSLog(@"QQ登录");
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:QQ_APPID andDelegate:self];
    NSMutableArray *permissionArray = [NSMutableArray arrayWithObjects: kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
    [_tencentOAuth authorize:permissionArray inSafari:NO];

}

-(void)tencentDidLogin{
    if (_tencentOAuth.accessToken && _tencentOAuth.openId) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic[@"openid"] = _tencentOAuth.openId;
        dic[@"access_token"] = _tencentOAuth.accessToken;

        [ByNetUtil post:API_QQ_LOGIN parameters:dic success:^(RespondModel *respondModel) {
            if(respondModel.code == 200){
                id data = respondModel.data;
                LoginModel *model = [LoginModel mj_objectWithKeyValues:data];
                Account *account = [[AccountManager sharedAccountManager] getAccount];
                account.uid = model.uid;
                account.access_token = model.access_token;
                account.refresh_token = model.refresh_token;
                [[AccountManager sharedAccountManager] saveAccount:account];
                [MobClick profileSignInWithPUID : model.uid];
                [DialogHelper showSuccessTips:@"登录成功!"];
                [self pushPage:[[MainPage alloc]init]];
            }else{
                [DialogHelper showFailureAlertSheet:respondModel.msg];
            }
        } failure:^(NSError *error) {
            [DialogHelper showFailureAlertSheet:@"登录失败!"];
        }];
        
    }else{
        [DialogHelper showFailureAlertSheet:@"accessToken 没有获取成功"];
    }
}

-(void)tencentDidNotNetWork{
    [DialogHelper showFailureAlertSheet:@"网络好像开了点小差,请重试"];
}

-(void)tencentDidNotLogin:(BOOL)cancelled{
    [DialogHelper showFailureAlertSheet:@"授权失败，请重试"];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_mPhoneText resignFirstResponder];
    [_mVerifyText resignFirstResponder];
}

@end
