//
//  GuessListModel.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuessModel.h"

@interface GuessListModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *models;

+(NSMutableArray *)models;

@end
