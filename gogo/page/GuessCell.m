//
//  GuessCell.m
//  gogo
//
//  Created by by.huang on 2017/10/30.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GuessCell.h"
#import "GuessButton.h"

@interface GuessCell()

@property (strong, nonatomic) UILabel *guessLabel;
@property (strong, nonatomic) UIView *guessContentView;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation GuessCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.contentView.backgroundColor = c06_backgroud;
    
    _guessLabel = [[UILabel alloc]init];
    _guessLabel.frame = CGRectMake([PUtil getActualWidth:30], [PUtil getActualHeight:30],ScreenWidth - [PUtil getActualWidth:30], [PUtil getActualHeight:33]);
    _guessLabel.textColor =c09_tips;
    _guessLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:24]];
    [self.contentView addSubview:_guessLabel];
    
    _guessContentView =[[UIView alloc]init];
    [self.contentView addSubview:_guessContentView];

    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = c05_divider;
    [self.contentView addSubview:_lineView];
    
    
}

-(void)setData : (BettingModel *)model deleaget : (id<GuessButtonDelegate>)delegate{
    _guessLabel.text = model.title;
    NSMutableArray *datas = [BettingItemModel mj_objectArrayWithKeyValuesArray:model.items];
    if(datas != nil && [datas count] > 0){
        NSInteger rows = ([datas count]-1) / 3;
        int per = [PUtil getActualHeight:117];
        _guessContentView.frame = CGRectMake(0, [PUtil getActualHeight:79], ScreenWidth, [PUtil getActualHeight:127] +per * rows);
        _lineView.frame = CGRectMake([PUtil getActualWidth:30],[PUtil getActualHeight:206] + (per * rows)-1, ScreenWidth - 30, 1);
        for(int i = 0 ; i < [datas count] ; i ++){
            BettingItemModel *itemModel = [datas objectAtIndex:i];
            GuessButton *button  =[[GuessButton alloc]initWithModel:itemModel delegate:delegate statu:model.betting_status];
            if(itemModel.isSelect){
                button.backgroundColor = c01_blue;
            }else{
                button.backgroundColor = c06_backgroud;
            }
            if([itemModel.status isEqualToString:Statu_Win]){
                button.backgroundColor = c01_blue;
            }else{
                button.backgroundColor = c06_backgroud;
            }
            button.frame = CGRectMake([PUtil getActualWidth:30] + [PUtil getActualWidth:236] * (i % 3),  per * (i/3), [PUtil getActualWidth:216], [PUtil getActualHeight:97]);
            [_guessContentView addSubview:button];
        }
        [_guessContentView layoutSubviews];
        
        
    }
}

+(NSString *)identify{
    return @"SCDHistoryCell";
}

@end
