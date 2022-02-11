//
//  NetUtil.h
//  gogo
//
//  Created by by.huang on 2017/9/18.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByNetUtil : NSObject


typedef void(^ByDownloadCallback)(id respondObj);

typedef void(^RefreshCompelete)(id data);


+(void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+(void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+(void)post:(NSString *)url content:(NSString *)content success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+(void)download : (NSString *)url callback : (ByDownloadCallback) callback;

+(void)refreshToken : (RefreshCompelete)compelete;

@end

