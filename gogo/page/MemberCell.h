//
//  MemberCell.h
//  gogo
//
//  Created by by.huang on 2017/10/27.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberModel.h"

@interface MemberCell : UITableViewCell

-(void)setData : (MemberModel *)model;

-(void)setData : (MemberModel *)model hideline: (Boolean)hideline;

+(NSString *)identify;

@end
