//
//  GoodsCell.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface GoodsCell : UICollectionViewCell


+(NSString *)identify;

-(void)setData : (GoodsModel *)goodsModel;

@end
