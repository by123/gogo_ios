//
//  HistoryCell.h
//  gogo
//
//  Created by by.huang on 2017/10/27.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"

@interface HistoryCell : UITableViewCell

-(void)setData : (HistoryModel *)model hideLine : (Boolean)hideLine;

+(NSString *)identify;

@end
