//
//  TitleButton.m
//  gogo
//
//  Created by by.huang on 2017/11/13.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

-(instancetype)initWithTitle : (NSString *)title{
    if(self == [super init]){
        [self initView : title];
    }
    return self;
}


-(void)initView : (NSString *)title{
    self.backgroundColor = c07_bar;

    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = c08_text;
    titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake([PUtil getActualWidth:30], 0, titleLabel.contentSize.width, [PUtil getActualHeight:110]);
    [self addSubview:titleLabel];
    
    UIImageView *arrowView = [[UIImageView alloc]init];
    arrowView.image = [UIImage imageNamed:@"ic_go_12"];
    arrowView.frame = CGRectMake([PUtil getActualWidth:701], [PUtil getActualHeight:43], [PUtil getActualHeight:24], [PUtil getActualHeight:24]);
    [self addSubview:arrowView];

}

@end
