//
//  AppDelegate.m
//  gogo
//
//  Created by by.huang on 2017/9/11.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginPage.h"
#import "MainPage.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AccountManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "QiniuSDK.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "RespondModel.h"


@interface AppDelegate ()<WXApiDelegate,QQApiInterfaceDelegate,UNUserNotificationCenterDelegate>
    @end

@implementation AppDelegate{
    LoginPage *loginPage;
}
    
    
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *controller;
    if([[AccountManager sharedAccountManager]isLogin]){
        MainPage *page = [[MainPage alloc]init];
        controller = [[UINavigationController alloc]initWithRootViewController:page];
        [self updateUserInfo];
        
    }else{
        loginPage = [[LoginPage alloc]init];
        controller = [[UINavigationController alloc]initWithRootViewController:loginPage];
    }
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    [self initNet];
    [self initWechat];
    [self initUmeng];
    [self initUmengPush : launchOptions];
    [UMUtil clickEvent:EVENT_LAUNCH];
    
    //    Account *accout = [[AccountManager sharedAccountManager] getAccount];
    //    accout.access_token = @"123456";
    //    [[AccountManager sharedAccountManager]saveAccount:accout];
    
    [ByNetUtil refreshToken:^(id data) {
    }];
    
    return YES;
    
}
    

    
-(void)initNet{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
}
    
    
- (void)initWechat{
    [WXApi registerApp:WECHAT_APPID];
}
    
-(void)initUmeng{
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = CHANNELCODE;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}
    
-(void)initUmengPush : (NSDictionary *)launchOptions{
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
}
    
    // 这个方法是用于从微信返回第三方App
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}
    
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    NSString *host = url.host;
    if([host isEqualToString:@"oauth"]){
        [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]){
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_ALIPAY_PAY_SUCCESS object:nil];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_ALIPAY_PAY_FAIL object:nil];
            }
        }];
    }else if([url.host isEqualToString:@"pay"]){
        return  [WXApi handleOpenURL:url delegate:self];
        
    }
    else{
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}
    
    
    
    
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]){
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_ALIPAY_PAY_SUCCESS object:nil];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_ALIPAY_PAY_FAIL object:nil];
            }
            
        }];
    }
    return YES;
}
    
    
    
-(void)onReq:(BaseReq *)req{
    
}
    
-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        NSString *code =  authResp.code;
        Account *account = [[AccountManager sharedAccountManager] getAccount];
        account.code = code;
        [[AccountManager sharedAccountManager] saveAccount:account];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_WECAHT_CALLBACK object:nil];
    }
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_WECAHT_PAY_SUCCESS object:nil];
            break;
            default:
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_WECAHT_PAY_FAIL object:nil];
            break;
        }
    }
}
    
    
- (void)isOnlineResponse:(NSDictionary *)response{
    
}
    
    
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
    {
        NSMutableString *deviceTokenString1 = [NSMutableString string];
        const char *bytes = deviceToken.bytes;
        NSUInteger iCount = deviceToken.length;
        for (int i = 0; i < iCount; i++) {
            [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
        }
        NSLog(@"deviceToken：%@", deviceTokenString1);
    }
    
    //iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    {
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
        
        //    self.userInfo = userInfo;
        //    //定制自定的的弹出框
        //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        //    {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
        //                                                            message:@"Test On ApplicationStateActive"
        //                                                           delegate:self
        //                                                  cancelButtonTitle:@"确定"
        //                                                  otherButtonTitles:nil];
        //
        //        [alertView show];
        //
        //    }
    }
    
    //iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
    
    //iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}
    
-(void)updateUserInfo{
    [ByNetUtil get:API_USERINFO parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            UserModel *userModel = [UserModel mj_objectWithKeyValues:data];
            [[AccountManager sharedAccountManager]saveUserInfo:userModel];
        }
    } failure:^(NSError *error) {
        
    }];
}
    
    
    @end
