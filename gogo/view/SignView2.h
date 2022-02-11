//
//  SignView2.h
//  gogo
//
//  Created by by.huang on 2018/2/12.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignView2Delegate

@optional -(void)OnGuessClicked;

@end

@interface SignView2 : UIView

@property (weak, nonatomic) id<SignView2Delegate> delegate;

-(instancetype)initWithCoin : (long)coins withDay : (int)days;

@end
