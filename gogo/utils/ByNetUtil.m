//
//  NetUtil.m
//  gogo
//
//  Created by by.huang on 2017/9/18.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ByNetUtil.h"
#import "AccountManager.h"
#import "RespondModel.h"
#import "LoginModel.h"
@implementation ByNetUtil

+(void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //请求头
    Account *account = [[AccountManager sharedAccountManager] getAccount];
    [manager.requestSerializer setValue:PT forHTTPHeaderField:@"pt"];
    [manager.requestSerializer setValue:APPKEY forHTTPHeaderField:@"app_key"];
    [manager.requestSerializer setValue:account.uid forHTTPHeaderField:@"uid"];
    [manager.requestSerializer setValue:account.access_token forHTTPHeaderField:@"access_token"];
    // 请求参数类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/xml",@"text/html", nil ];
    // post请求
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success){
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            RespondModel *model = [RespondModel mj_objectWithKeyValues:responseObject];
//            if(model.code == 498){
//                [self refreshToken:^(id data) {
//                    [self get:url parameters:parameters success:success failure:failure];
//                }];
//                return;
//            }
            success(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure){
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //请求头
    Account *account = [[AccountManager sharedAccountManager] getAccount];
    [manager.requestSerializer setValue:PT forHTTPHeaderField:@"pt"];
    [manager.requestSerializer setValue:APPKEY forHTTPHeaderField:@"app_key"];
    [manager.requestSerializer setValue:account.uid forHTTPHeaderField:@"uid"];
    [manager.requestSerializer setValue:account.access_token forHTTPHeaderField:@"access_token"];
    // 请求参数类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/xml",@"text/html", nil ];
    // post请求
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success){
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            RespondModel *model = [RespondModel mj_objectWithKeyValues:responseObject];
            success(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure){
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            failure(error);
        }
    }];
}


+(void)post:(NSString *)url content:(NSString *)content success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //请求头
    Account *account = [[AccountManager sharedAccountManager] getAccount];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:PT forHTTPHeaderField:@"pt"];
    [request addValue:APPKEY forHTTPHeaderField:@"app_key"];
    [request addValue:account.uid forHTTPHeaderField:@"uid"];
    [request addValue:account.access_token forHTTPHeaderField:@"access_token"];
    
    NSData *body  =[content dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error)
      {
          if(error){
              if (failure){
                  failure(error);
              }
          }else{
              if (success){
                  RespondModel *model = [RespondModel mj_objectWithKeyValues:responseObject];
                  success(model);
              }
          }
          [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
          
      }] resume];
}


+(void)download : (NSString *)url callback : (ByDownloadCallback) callback{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

+(void)refreshToken : (RefreshCompelete)compelete{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        Account *account = [[AccountManager sharedAccountManager]getAccount];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic[@"refresh_token"]=account.refresh_token ;
        [self post:API_REFRESH_TOKEN parameters:dic success:^(RespondModel *respondModel) {
            if(respondModel.code == 200){
                id data = respondModel.data;
                LoginModel *model = [LoginModel mj_objectWithKeyValues:data];
                account.uid = model.uid;
                account.access_token = model.access_token;
                account.refresh_token = model.refresh_token;
                [[AccountManager sharedAccountManager] saveAccount:account];
            }
            compelete(respondModel);
        } failure:^(NSError *error) {
            
        }];
//    });
}


@end
