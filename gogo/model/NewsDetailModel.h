//
//  NewsDetailModel.h
//  gogo
//
//  Created by by.huang on 2017/11/4.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDetailModel : NSObject

@property (assign, nonatomic) long news_id;
@property (assign, nonatomic) long nid;
@property (assign, nonatomic) int view_count;
@property (assign, nonatomic) int comment_count;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *tp;
@property (copy, nonatomic) NSString *news_ts;
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *body;
@property (copy, nonatomic) NSString *video;
@property (assign, nonatomic) long like_count;
@property (assign, nonatomic) bool is_like;


@end
