//
//  PriceCell.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModel.h"

NS_CLASS_DEPRECATED_IOS(2_0, 9_0, "PriceCell is Deprecated") __TVOS_PROHIBITED
@interface PriceCell : UITableViewCell

-(void)setData : (PayModel *)model hideline : (Boolean)hideline;

-(void)setSelect : (Boolean)select;

+(NSString *)identify;

@end
