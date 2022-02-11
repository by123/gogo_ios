//
//  GiftCell.m
//  gogo
//
//  Created by by.huang on 2018/3/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "GiftCell.h"

@interface GiftCell()

@property (strong, nonatomic) UIImageView *showImg;
@property (strong, nonatomic) UILabel *countLabel;

@end

@implementation GiftCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = c02_red;
    int width =  (ScreenWidth - [PUtil getActualWidth:20] * 5)/4;
    _showImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 ,width,width)];
    _showImg.layer.masksToBounds = YES;
    _showImg.layer.cornerRadius = [PUtil getActualWidth:10];
    _showImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_showImg];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = c08_text;
    _countLabel.backgroundColor = c06_backgroud;
    _countLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.frame = CGRectMake(0, width, width, [PUtil getActualHeight:50]);
    [self.contentView addSubview:_countLabel];
    
    
}

-(void)setData : (GiftModel *)giftModel{
    [_showImg sd_setImageWithURL:[NSURL URLWithString:giftModel.gift_icon]];
    _countLabel.text = [NSString stringWithFormat:@"%@:%ld",giftModel.gift_name,giftModel.total_gift];
    
}

+(NSString *)identify{
    return @"GiftCell";
}
@end
