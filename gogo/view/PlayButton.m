//
//  PlayButton.m
//  gogo
//
//  Created by by.huang on 2017/12/4.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "PlayButton.h"
@interface PlayButton()

@property (strong, nonatomic) UIImageView *playImageView;

@end

@implementation PlayButton

-(instancetype)initWithImage:(CGRect)rect image:(UIImage *)image{
    if(self == [super initWithFrame:rect]){
        [self initView:image];
    }
    return self;
}

-(void)initView : (UIImage *)image{
    self.backgroundColor = [UIColor clearColor];
    _playImageView = [[UIImageView alloc]init];
    _playImageView.image = image;
    int width = [PUtil getActualWidth:100];
    _playImageView.frame = CGRectMake((self.frame.size.width - width ) /2,(self.frame.size.height - width)/2, width, width);
    [self addSubview:_playImageView];
}

@end
