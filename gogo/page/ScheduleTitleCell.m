//
//  ScheduleTitleCell.m
//  gogo
//
//  Created by by.huang on 2017/10/25.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ScheduleTitleCell.h"

@interface ScheduleTitleCell()

@property (strong, nonatomic) UILabel *mTitleLabel;

@end

@implementation ScheduleTitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.contentView.backgroundColor = c06_backgroud;
    _mTitleLabel = [[UILabel alloc]init];
    _mTitleLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30], ScreenWidth, [PUtil getActualHeight:40]);
    _mTitleLabel.textColor = c09_tips;
    _mTitleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
    _mTitleLabel.numberOfLines = 0;
    _mTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_mTitleLabel];
    
 
}


-(void)setData : (ScheduleItemModel *)model{
    NSString *tempStr = model.create_ts;
    NSRange range = NSMakeRange(0, 4);
    NSString *a = [tempStr substringWithRange:range];
    range = NSMakeRange(4, 2);
    NSString *b = [tempStr substringWithRange:range];
    range = NSMakeRange(6, 2);
    NSString *c = [tempStr substringWithRange:range];
    NSString *timeStr = [NSString stringWithFormat:@"%@年%@月%@日",a,b,c];
    _mTitleLabel.text = timeStr;

}

+(NSString *)identify{
    return @"ScheduleTitleCell";
}
@end
