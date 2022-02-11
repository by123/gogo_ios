//
//  Constant.h
//  gogo
//
//  Created by by.huang on 2017/9/11.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject

#define CODE_SUCCESS 200
#define CODE_TOKEN_INVAILD 498

//请求头
#define CHANNELCODE @"000001"
#define PT @"app"
#define APPKEY @"test_key"
#define APPSECRET @"test_secret"
#define WECHAT_APPID @"wx3349545f4d083130"
#define WECHAT_APPSECRET @"a38eb57a4e88a6007f5cc44f97ef84e2"
#define QQ_APPID @"1106448485"
#define UMENG_APPKEY @"5a1947f48f4a9d44ce0000c5"

//URL
#define RootUrl @"https://gogo.scrats.cn/api/"
#define API_GETVERIFY @"https://gogo.scrats.cn/api/account/sms"
#define API_LOGIN @"https://gogo.scrats.cn/api/account/sms_login"
#define API_BANNER @"https://gogo.scrats.cn/api/core/banner"
#define API_NEWS_LIST @"https://gogo.scrats.cn/api/core/news"
#define API_NEWS_DETAIL @"https://gogo.scrats.cn/api/core/news/"
#define API_COMMENT @"https://gogo.scrats.cn/api/core/comments"
#define API_ADDCOMMENT @"https://gogo.scrats.cn/api/core/comment"
#define API_RACE @"https://gogo.scrats.cn/api/core/races"
#define API_RACE2 @"https://gogo.scrats.cn/api/core/races2"
#define API_TEAMLIST @"https://gogo.scrats.cn/api/core/teams"
#define API_TEAMDETAIL @"https://gogo.scrats.cn/api/core/team/"
#define API_PAYLIST @"https://gogo.scrats.cn/api/core/coin/plans"
#define API_ALIPAY @"https://gogo.scrats.cn/api/pay/alipay/order/coin_plan"
#define API_WECAHT_PAY @"https://gogo.scrats.cn/api/pay/weixin/order/coin_plan"
#define API_USERINFO @"https://gogo.scrats.cn/api/core/user"
#define API_LOGOUT @"https://gogo.scrats.cn/api/account/logout"
#define API_WECHAT_LOGIN @"https://gogo.scrats.cn/api/account/wx_login"
#define API_QQ_LOGIN @"https://gogo.scrats.cn/api/account/qq_login"
#define API_GOODS_LIST @"https://gogo.scrats.cn/api/mall/goods"
#define API_GOODS_DETAIL @"https://gogo.scrats.cn/api/mall/goods/"
#define API_EXCHANGE @"https://gogo.scrats.cn/api/mall/exchange/"
#define API_EXCHANGE_HISTORY @"https://gogo.scrats.cn/api/mall/exchange/history"
#define API_GET_ADDRESS @"https://gogo.scrats.cn/api/core/address"
#define API_UPDATE_ADDRESS @"https://gogo.scrats.cn/api/core/address"
#define API_GUESS_DETAIL @"https://gogo.scrats.cn/api/core/race2/"
#define API_GUESS @"https://gogo.scrats.cn/api/core/betting"
#define API_REFRESH_TOKEN @"https://gogo.scrats.cn/api/account/token"
#define API_GUESS_HISTORY @"https://gogo.scrats.cn/api/core/betting"
#define API_UPLOAD_HEAD @"https://gogo.scrats.cn/api/file/qiniu_token"
#define API_UPLOAD_USERINFO @"https://gogo.scrats.cn/api/core/user"
#define API_QINIU @"https://gogo.scrats.cn/api/file/qiniu_token"
#define API_GETTYPE @"https://gogo.scrats.cn/api/core/news/type"
#define API_NEWS_LIKE @"https://gogo.scrats.cn/api/core/news/like"
#define API_NEWS_UNLIKE @"https://gogo.scrats.cn/api/core/news/unlike"
#define API_COMMENT_LIKE @"https://gogo.scrats.cn/api/core/comment/like"
#define API_COMMENT_UNLIKE @"https://gogo.scrats.cn/api/core/comment/unlike"
#define API_SIGN_STATU @"https://gogo.scrats.cn/api/core/coin"
#define API_SIGN @"https://gogo.scrats.cn/api//core/sign_in"
#define API_NEWS_COMMOND @"https://gogo.scrats.cn/api/core/news/recommend"
#define API_HOT_RACES @"https://gogo.scrats.cn/api/core/races/hot"
#define API_GIFT @"https://gogo.scrats.cn/api/core/race2/coin_gift"

//notification
#define NOTIFY_WECAHT_CALLBACK @"notify_wechat_callback"
#define NOTIFY_WECAHT_PAY_SUCCESS @"notify_wechat_pay_success"
#define NOTIFY_WECAHT_PAY_FAIL @"notify_wechat_pay_fail"
#define NOTIFY_ALIPAY_PAY_SUCCESS @"notify_alipay_pay_success"
#define NOTIFY_ALIPAY_PAY_FAIL @"notify_alipay_pay_fail"

@end
