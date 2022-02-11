//
//  SignView.h
//  gogo
//
//  Created by by.huang on 2017/12/9.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignViewDelegate

@optional -(void)OnSignSuccess;

@end

@interface SignView : UIView

@property (weak, nonatomic) id<SignViewDelegate> delegate;


@end
