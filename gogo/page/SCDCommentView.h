//
//  SCDCommentView.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDCommentView : UIView

- (void)keyboardWillChangeFrame:(NSNotification *)notification;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end
