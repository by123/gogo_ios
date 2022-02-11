//
//  MallView.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPage.h"

#define HOT @"hot"
#define EQUIPMENT @"equipment"
#define LUCKYMONEY @"lucky_money"
#define GAMEAROUND @"game_around"
#define VIRTUAL @"virtual"

@interface GoodsView : UIView

@property (copy, nonatomic) NSString *type;

@property (weak, nonatomic) id<MainHandleDelegate> handleDelegate;

-(instancetype)initWithType : (NSString *)type withDelegate : (id<MainHandleDelegate>)delegate;

@end
