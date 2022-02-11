//
//  RespondModel.h
//  gogo
//
//  Created by by.huang on 2017/11/3.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespondModel : NSObject
@property (assign, nonatomic) int code;
@property (copy, nonatomic) NSString *msg;
@property (strong, nonatomic) id data;
@end
