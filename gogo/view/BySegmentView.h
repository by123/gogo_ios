//
//  BySegmentView.h
//  gogo
//
//  Created by by.huang on 2017/9/19.
//  Copyright © 2017年 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol BySegmentViewDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)index;

@end

@interface BySegmentView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL animation;

@property (nonatomic, strong) NSArray *titleArray;//标题title
@property (nonatomic, strong) NSArray *showControllerArray;//每项对应的UIViewController
@property (nonatomic, weak) id <BySegmentViewDelegate> delegate;


-(instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray andShowControllerNameArray:(NSMutableArray *)showControllerArray;


@end
