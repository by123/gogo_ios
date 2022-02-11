//
//  ExchangeCell.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeModel.h"

@interface ExchangeCell : UITableViewCell

-(void)setData : (ExchangeModel *)model hideline : (Boolean)hideline;

+(NSString *)identify;

@end
