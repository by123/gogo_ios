//
//  InsetTextField.h
//  gogo
//
//  Created by by.huang on 2017/10/26.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InsetTextField : UITextField<UITextFieldDelegate>

-(instancetype)initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;

-(instancetype)initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets hint:(NSString *)hint;

-(void)check;

@end
