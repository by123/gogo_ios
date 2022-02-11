//
//  CompetitionView.h
//  gogo
//
//  Created by by.huang on 2018/1/26.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPage.h"


@protocol CompetitionViewDelegate

@optional
-(void)goGuessPage : (long)race_id end:(Boolean)isEnd;
-(void)goSchedulePage;

@end

@interface CompetitionView : UIView

@property (weak, nonatomic) id<CompetitionViewDelegate> delegate;

@end
