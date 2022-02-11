//
//  BottomView.h
//  gogo
//
//  Created by by.huang on 2017/10/23.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

@optional -(void)OnTabSelected : (NSInteger)index;

@end

@interface BottomView : UIView

-(instancetype)initWithTitles:(NSArray *)titles images : (NSArray *)images delegate:(id<BottomViewDelegate>)delegate;

-(void)gameClick;
@end
