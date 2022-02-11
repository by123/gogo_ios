//
//  BottomView.m
//  gogo
//
//  Created by by.huang on 2017/10/23.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "BottomView.h"

#define TabHeight [PUtil getActualHeight:100]

@interface BottomView()

@property (strong, nonatomic) id<BottomViewDelegate> delegate;

@end

@implementation BottomView{
    UIButton *selectButton;
    NSArray *imagesArray;
    NSMutableArray *buttons;
}


-(instancetype)initWithTitles:(NSArray *)titles images : (NSArray *)images delegate:(id<BottomViewDelegate>)delegate{
    if(self == [super init]){
        self.delegate = delegate;
        buttons = [[NSMutableArray alloc]init];
        [self initView : titles images:images];
    }
    return self;
}


-(void)initView : (NSArray*) titles images : (NSArray *)images{
    imagesArray = images;
    self.frame = CGRectMake(0, ScreenHeight - TabHeight, ScreenWidth, TabHeight);
    self.backgroundColor = c07_bar;
    if(titles!=nil &&  [titles count]> 0){
        int width = ScreenWidth / [titles count];
        for(int i= 0 ; i < [titles count] ; i++){
            UIButton *button = [[UIButton alloc]init];
            button.tag = i;
            button.frame = CGRectMake(width * i, 0, width, TabHeight);
            [button setTitle:[titles objectAtIndex:i]  forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[images objectAtIndex:i*2]]  forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:20]];
            
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.size.width, -button.imageView.size.height - 5, 0);
            button.imageEdgeInsets = UIEdgeInsetsMake( -button.titleLabel.size.height - 5,  0,  0, -button.titleLabel.size.width);
            if(i == 0){
                selectButton = button;
                [button setTitleColor:c01_blue forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:[images objectAtIndex:i*2+1]]  forState:UIControlStateNormal];
            }else{
                [button setTitleColor:c10_icon forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttons addObject:button];
            [self addSubview:button];
        }
    }
}

-(void)OnButtonClick : (id)sender{
    UIButton *button = sender;
    if(button.tag != selectButton.tag){
        [button setTitleColor:c01_blue forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[imagesArray objectAtIndex:button.tag*2+1]]  forState:UIControlStateNormal];

        [selectButton setTitleColor:c10_icon forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:[imagesArray objectAtIndex:selectButton.tag*2]]  forState:UIControlStateNormal];
        selectButton = button;
        if(self.delegate){
            [self.delegate OnTabSelected:button.tag];
        }
    }
}

-(void)gameClick{
    UIButton *button = [buttons objectAtIndex:1];
    [self OnButtonClick:button];
}

@end
