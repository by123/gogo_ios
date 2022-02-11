//
//  ScheduleContentCell.h
//  gogo
//
//  Created by by.huang on 2017/10/25.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleModel.h"
#import "MainPage.h"

@interface ScheduleContentCell : UITableViewCell

-(void)setData : (ScheduleItemModel *)model;

-(void)setDelegate : (id<MainHandleDelegate>)delegate;

+(NSString *)identify;

@end
