//
//  AboutPage.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "AboutPage.h"
#import "BarView.h"

@interface AboutPage ()

@property(strong, nonatomic) BarView *barView;

@end

@implementation AboutPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    _barView = [[BarView alloc]initWithTitle:@"关于" page:self];
    [self.view addSubview:_barView];
    
    int height = _barView.mj_h + _barView.mj_y;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"etc_logo_200"];
    imageView.frame = CGRectMake((ScreenWidth -  [PUtil getActualWidth:240])/2, height+[PUtil getActualHeight:359], [PUtil getActualWidth:240],  [PUtil getActualWidth:240]);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = [PUtil getActualWidth:40]/2;
    [self.view addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.frame =CGRectMake(0, height+[PUtil getActualHeight:631], ScreenWidth,  [PUtil getActualHeight:56]);
    nameLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:40]];
    nameLabel.textColor = c08_text;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"GOGO电竞";
    [self.view addSubview:nameLabel];
    
    UILabel *sloganLabel = [[UILabel alloc]init];
    sloganLabel.frame =CGRectMake(0, height+[PUtil getActualHeight:687], ScreenWidth,  [PUtil getActualHeight:33]);
    sloganLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    sloganLabel.textColor = c08_text;
    sloganLabel.textAlignment = NSTextAlignmentCenter;
    sloganLabel.alpha = 0.5f;
    sloganLabel.text = @"这里是SLOGAN";
    [self.view addSubview:sloganLabel];
    
    

}

@end
