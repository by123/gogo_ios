//
//  CommentListModel.h
//  gogo
//
//  Created by by.huang on 2017/11/4.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
#import "UserModel.h"
@interface CommentListModel : NSObject

@property (strong, nonatomic) id comment;
@property (strong, nonatomic) id user;

@end
