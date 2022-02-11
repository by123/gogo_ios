//
//  CommentModel.h
//  gogo
//
//  Created by by.huang on 2017/10/26.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (assign, nonatomic) long comment_id;
@property (assign, nonatomic) long replay_comment_id;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *tp;
@property (assign, nonatomic) long target_id;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *create_ts;
@property (assign, nonatomic) long like_count;
@property (assign, nonatomic) bool is_like;


@end
