//
//  NewsCell.m
//  gogo
//
//  Created by by.huang on 2017/10/22.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell()

@property (strong ,nonatomic) UILabel *mTitleLabel;
@property (strong, nonatomic) UIImageView *mTypeImage;
@property (strong ,nonatomic) UILabel *mTypeLabel;
@property (strong, nonatomic) UIImageView *mZanImage;
@property (strong ,nonatomic) UILabel *mZanLabel;
@property (strong, nonatomic) UIImageView *mCommentImage;
@property (strong ,nonatomic) UILabel *mCommentLabel;
@property (strong ,nonatomic) UIImageView *mImageView;
@property (strong ,nonatomic) UIView  *lineView;

@end

@implementation NewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.contentView.backgroundColor = c06_backgroud;
    
    _mTitleLabel = [[UILabel alloc]init];
    _mTitleLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:24], [PUtil getActualWidth:486], [PUtil getActualHeight:84]);
    _mTitleLabel.textColor = c08_text;
    _mTitleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
    _mTitleLabel.numberOfLines = 0;
    _mTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_mTitleLabel];
    
    _mTypeImage = [[UIImageView alloc]init];
    _mTypeImage.image = [UIImage imageNamed:@"ic_info_12"];
    _mTypeImage.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:120], [PUtil getActualWidth:24], [PUtil getActualWidth:24]);
    [self.contentView addSubview:_mTypeImage];
    
    _mTypeLabel = [[UILabel alloc]init];
    _mTypeLabel.frame = CGRectMake([PUtil getActualWidth:62], [PUtil getActualHeight:115], [PUtil getActualWidth:300], [PUtil getActualHeight:33]);
    _mTypeLabel.textColor = c09_tips;
    _mTypeLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [self.contentView addSubview:_mTypeLabel];
    
    _mCommentImage = [[UIImageView alloc]init];
    _mCommentImage.image = [UIImage imageNamed:@"ic_comment_12"];
    _mCommentImage.frame = CGRectMake([PUtil getActualWidth:360], [PUtil getActualHeight:120], [PUtil getActualWidth:24], [PUtil getActualWidth:24]);
    [self.contentView addSubview:_mCommentImage];
    
    _mCommentLabel = [[UILabel alloc]init];
    _mCommentLabel.frame = CGRectMake([PUtil getActualWidth:392], [PUtil getActualHeight:115], [PUtil getActualWidth:60], [PUtil getActualHeight:33]);
    _mCommentLabel.textColor = c09_tips;
    _mCommentLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [self.contentView addSubview:_mCommentLabel];
    
    _mZanImage = [[UIImageView alloc]init];
    _mZanImage.image = [UIImage imageNamed:@"ic_zan_normal"];
    _mZanImage.frame = CGRectMake([PUtil getActualWidth:440], [PUtil getActualHeight:120], [PUtil getActualWidth:24], [PUtil getActualWidth:24]);
    [self.contentView addSubview:_mZanImage];
    
    _mZanLabel = [[UILabel alloc]init];
    _mZanLabel.frame = CGRectMake([PUtil getActualWidth:472], [PUtil getActualHeight:115], [PUtil getActualWidth:60], [PUtil getActualHeight:33]);
    _mZanLabel.textColor = c09_tips;
    _mZanLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [self.contentView addSubview:_mZanLabel];
    
    
    _mImageView = [[UIImageView alloc]init];
    _mImageView.frame = CGRectMake([PUtil getActualWidth:536],  [PUtil getActualHeight:24], [PUtil getActualWidth:184], [PUtil getActualHeight:124]);
    [self.contentView addSubview:_mImageView];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c05_divider;
    _lineView.frame = CGRectMake([PUtil getActualWidth:30],  [PUtil getActualHeight:172]-1, ScreenWidth - ([PUtil getActualWidth:30]*2), 1);
    [self.contentView addSubview:_lineView];
}


-(void)setData : (NewsModel *)model{
    _mTitleLabel.text = model.title;
    _mTypeLabel.text = model.tp;
    [_mImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    _mCommentLabel.text = model.comment_count;
    _mZanLabel.text = [NSString stringWithFormat:@"%ld",model.like_count];
    if(model.is_like){
        [_mZanImage setImage:[UIImage imageNamed:@"ic_zan_select"]];
    }else{
        [_mZanImage setImage:[UIImage imageNamed:@"ic_zan_normal"]];
    }

}

+(NSString *)identify{
    return @"NewsCell";
}


@end
