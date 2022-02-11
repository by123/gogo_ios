//
//  GiftView.h
//  gogo
//
//  Created by by.huang on 2018/3/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamModel.h"
#define GiftViewHeight [PUtil getActualHeight:300]
#define GiftScrollViewHeight [PUtil getActualHeight:250]

@protocol GiftViewDelegate

@optional
-(void)goChargePage;
-(void)sendGiftSuccess;

@end

@interface GiftView : UIView

@property (weak, nonatomic) id delegate;

-(instancetype)initWithModel:(TeamModel *)model raceId:(long)raceId;

-(void)show;

-(void)hide;

@end
