//
//  GuessButton.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BettingItemModel.h"

@protocol GuessButtonDelegate <NSObject>

@optional -(void)onClick : (BettingItemModel *)model;

@end

@interface GuessButton : UIButton

-(instancetype)initWithModel : (BettingItemModel *)model delegate : (id<GuessButtonDelegate>)delegate statu:(NSString *)statu;

@end
