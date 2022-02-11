//
//  GuessPage.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//


#import "BaseViewController.h"
#import "BettingItemModel.h"
#import "GuessView.h"

@protocol GuessDelegate<NSObject>

@optional -(void)OpenGuessOrderView : (BettingItemModel *)model guessView : (UIView *)guessView;

@end

@interface GuessPage : BaseViewController<GuessDelegate>

@property (assign, nonatomic) long race_id;
@property (assign, nonatomic) Boolean isEnd;

@end


