//
//  NormalAlertView.h
//  gogo
//
//  Created by by.huang on 2018/3/1.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NormalAlertViewDelegate

@optional -(void)OnOkBtnClick;

@end

@interface NormalAlertView : UIView

@property (weak, nonatomic) id delegate;

-(instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

@end
