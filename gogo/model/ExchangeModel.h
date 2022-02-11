//
//  ExchangeModel.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeGoodsModel.h"
#import "ExchangeOrderModel.h"


@interface ExchangeModel : NSObject

@property (strong, nonatomic) ExchangeOrderModel *goods_order;

@property (strong, nonatomic) ExchangeGoodsModel *goods;



@end
