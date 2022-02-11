//
//  ItemView.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemView : UIView

-(instancetype)initWithItemView: (NSString *)title;

-(void)setContent : (NSString *)content;

-(void)setHideLine : (Boolean)hideLine;

@end
