//
//  GuessView.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuessButton.h"
#import "BettingItemModel.h"
#import "GuessPage.h"

@interface GuessView : UIView<GuessButtonDelegate>

@property (weak, nonatomic) id delegate;

-(instancetype)initWithDatas : (NSMutableArray *)datas raceid:(long)raceid end:(Boolean)end;

-(void)restoreItems;

@end
