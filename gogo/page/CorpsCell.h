//
//  CorpsCell.h
//  gogo
//
//  Created by by.huang on 2017/10/25.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorpsModel.h"

@interface CorpsCell : UITableViewCell

-(void)setData : (CorpsModel *)model;

+(NSString *)identify;

@end
