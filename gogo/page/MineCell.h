//
//  MineCell.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCell : UITableViewCell

-(void)setData : (NSString *)title hideline : (Boolean)hideline;

+(NSString *)identify;
@end
