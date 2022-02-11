//
//  GuessHistoryCell.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuessHistoryModel.h"

@interface GuessHistoryCell : UITableViewCell

-(void)setData : (GuessHistoryModel *)model;

+(NSString *)identify;

@end
