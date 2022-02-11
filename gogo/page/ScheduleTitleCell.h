//
//  ScheduleTitleCell.h
//  gogo
//
//  Created by by.huang on 2017/10/25.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleModel.h"

@interface ScheduleTitleCell : UITableViewCell

-(void)setData : (ScheduleItemModel *)model;

+(NSString *)identify;

@end
