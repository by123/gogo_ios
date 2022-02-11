//
//  UploadImageUtil.m
//  gogo
//
//  Created by by.huang on 2017/11/15.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "UploadImageUtil.h"
#import "RespondModel.h"
#import <Qiniu/QiniuSDK.h>

@implementation UploadImageUtil

+(void)getUploadToken : (NSData *)imageData delegate : (id<UploadImageDelegate>)delegate{
    [ByNetUtil get:API_QINIU parameters:nil success:^(RespondModel *repondModel) {
        if(repondModel.code == 200){
            id data = repondModel.data;
            NSString *upload_token = [data objectForKey:@"upload_token"];
            NSString *domain = [data objectForKey:@"domain"];
            NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            [upManager putData:imageData key:timestamp token:upload_token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSString *url = [domain stringByAppendingString:[resp objectForKey:@"key"]];
                if(delegate){
                    [delegate uploadSuccess:url];
                }
            } option:nil];

        }
    } failure:^(NSError *error) {
        if(delegate){
            [delegate uploadFail];
        }
    }];
}

@end
