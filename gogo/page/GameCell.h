//
//  GameCell.h
//  gogo
//
//  Created by by.huang on 2018/1/31.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItemModel.h"

@interface GameCell : UITableViewCell

-(void)setData : (ScheduleItemModel *)model;

+(NSString *)identify;

@end
