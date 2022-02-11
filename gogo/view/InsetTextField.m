//
//  InsetTextField.m
//  gogo
//
//  Created by by.huang on 2017/10/26.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "InsetTextField.h"
@interface InsetTextField()

@property (strong, nonatomic) UILabel *hintLabel;

@end

@implementation InsetTextField{
    UIEdgeInsets edgeInsets;
}

-(instancetype)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets{
    if(self == [super initWithFrame:frame]){
        edgeInsets = insets;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets hint:(NSString *)hint{
    if(self == [super initWithFrame:frame]){
        edgeInsets = insets;
        [self initView : hint];
    }
    return self;
}

-(void)initView : (NSString *)hint{
    self.delegate = self;
    _hintLabel = [[UILabel alloc]init];
    _hintLabel.text = hint;
    _hintLabel.textColor = c08_text;
    _hintLabel.alpha = 0.5f;
    _hintLabel.frame = CGRectMake([PUtil getActualWidth:30], 0,  self.frame.size.width, self.frame.size.height);
    _hintLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_hintLabel];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds,edgeInsets.left,0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds,edgeInsets.left,0);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(_hintLabel){
        _hintLabel.hidden = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(_hintLabel){
        if([textField.text isEqualToString:@""]){
            _hintLabel.hidden = NO;
        }
    }
}

-(void)check{
    if(!IS_NS_STRING_EMPTY(self.text)){
        _hintLabel.hidden = YES;
    }
}

@end
