//
//  GuessCell.h
//  gogo
//
//  Created by by.huang on 2017/10/30.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BettingModel.h"
#import "GuessButton.h"

@interface GuessCell : UITableViewCell

-(void)setData : (BettingModel *)model deleaget : (id<GuessButtonDelegate>)delegate;

+(NSString *)identify;

@end
