//
//  SCDHistoryCell.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDHistoryModel.h"

@interface SCDHistoryCell : UITableViewCell

-(void)setData : (SCDHistoryModel *)model;

+(NSString *)identify;

@end
