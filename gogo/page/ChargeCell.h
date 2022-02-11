//
//  ChargeCell.h
//  gogo
//
//  Created by by.huang on 2018/3/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModel.h"


@interface ChargeCell : UICollectionViewCell

+(NSString *)identify;

-(void)setData : (PayModel *)payModel;

@end
