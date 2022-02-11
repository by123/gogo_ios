//
//  GiftView.m
//  gogo
//
//  Created by by.huang on 2018/3/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "GiftView.h"
#import "GiftCell.h"
#import "RespondModel.h"
#import "AccountManager.h"
#import "NormalAlertView.h"
@interface GiftView()<UICollectionViewDelegate,UICollectionViewDataSource,NormalAlertViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation GiftView{
    int itemWidth;
    TeamModel *teamModel;
    NSMutableArray *datas;
    long mRaceId;
}

-(instancetype)initWithModel:(TeamModel *)model raceId:(long)raceId{
    if(self == [super init]){
        datas = [[NSMutableArray alloc]init];
        teamModel = model;
        mRaceId = raceId;
        [self initView];
        [self getUserInfo];
    }
    return self;
}

-(void)initView{
    
    itemWidth = (ScreenWidth - [PUtil getActualWidth:20] * 5)/4;
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.75f];
    self.hidden = YES;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.minimumLineSpacing = [PUtil getActualWidth:20];
//    layout.minimumInteritemSpacing = [PUtil getActualWidth:20];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _contentView = [[UIView alloc]init];
    _contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, GiftViewHeight);
    _contentView.backgroundColor = c07_bar;
    [self addSubview:_contentView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = c08_text;
    _titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:28]];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text =  [NSString stringWithFormat:@"支持%@",teamModel.team_name];
    _titleLabel.frame = CGRectMake(0,[PUtil getActualHeight:20], ScreenWidth, _titleLabel.contentSize.height);
    [_contentView addSubview:_titleLabel];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, GiftViewHeight - GiftScrollViewHeight, ScreenWidth, GiftScrollViewHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_collectionView];
    
    [_collectionView registerClass:[GiftCell class] forCellWithReuseIdentifier:[GiftCell identify]];
    
}

-(void)show{
    self.hidden = NO;
    __weak UIView *tempView  = _contentView;
    [UIView animateWithDuration:0.3f animations:^{
        tempView.frame = CGRectMake(0, ScreenHeight - GiftViewHeight, ScreenWidth,GiftViewHeight);
    }];
}

-(void)hide{
    __weak UIView *tempView  = _contentView;
    [UIView animateWithDuration:0.3f animations:^{
        tempView.frame = CGRectMake(0, ScreenHeight, ScreenWidth,GiftViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [datas count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GiftCell identify] forIndexPath:indexPath];
    cell.backgroundColor = c01_blue;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = [PUtil getActualHeight:10];
    [cell setData:[datas objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return CGSizeMake(itemWidth,itemWidth+[PUtil getActualHeight:50]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake([PUtil getActualWidth:20], [PUtil getActualWidth:20], [PUtil getActualWidth:20], [PUtil getActualWidth:20]);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GiftModel *model = [datas objectAtIndex:indexPath.row];
    if(model.total_gift > 0){
        [self sendGift:model];
    }else{
        NormalAlertView *normalAlertView = [[NormalAlertView alloc]initWithTitle:@"赠送失败，礼物数量不足" content:@"是否去购买礼物?"];
        normalAlertView.delegate = self;
        [self addSubview:normalAlertView];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hide];
}


-(void)sendGift : (GiftModel *)model{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"coin_plan_id"] = @(model.coin_plan_id);
    dic[@"total_gift"] = @"1";
    dic[@"race_id"] = @(mRaceId);
    dic[@"team_id"] = @(teamModel.team_id);
    [ByNetUtil post:API_GIFT parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [self getUserInfo];
            if(_delegate && [_delegate respondsToSelector:@selector(sendGiftSuccess)]){
                [_delegate sendGiftSuccess];
            }
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
        [MBProgressHUD hideHUDForView:self animated:YES];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}

-(void)getUserInfo{
    [datas removeAllObjects];
    [ByNetUtil get:API_USERINFO parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            UserModel *userModel = [UserModel mj_objectWithKeyValues:data];
            for(int i = 0; i < [userModel.coin_gift count] ; i ++){
                id data = [userModel.coin_gift objectAtIndex:i];
                GiftModel *model = [GiftModel mj_objectWithKeyValues:data];
                [datas addObject:model];
            }
            [_collectionView reloadData];
            [[AccountManager sharedAccountManager]saveUserInfo:userModel];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)OnOkBtnClick{
    if(_delegate && [_delegate respondsToSelector:@selector(goChargePage)]){
        [_delegate goChargePage];
    }
}


@end
