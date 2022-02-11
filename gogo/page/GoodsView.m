//
//  MallView.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "GoodsView.h"
#import "GoodsCell.h"
#import "RespondModel.h"
#import "GoodsModel.h"

@interface GoodsView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end
@implementation GoodsView{
    int index;
    NSMutableArray *datas;
}

-(instancetype)initWithType : (NSString *)type withDelegate : (id<MainHandleDelegate>)delegate{
    if(self == [super init]){
        index = 0;
        datas = [[NSMutableArray alloc]init];
        _type = type;
        _handleDelegate = delegate;
        [self initView];
        [self requestList : NO];
    }
    return self;
}

-(void)initView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
  
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - [PUtil getActualHeight:268]) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = c06_backgroud;
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[GoodsCell class] forCellWithReuseIdentifier:[GoodsCell identify]];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [datas count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GoodsCell identify] forIndexPath:indexPath];
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
    return CGSizeMake([PUtil getActualWidth:330], [PUtil getActualWidth:330]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake([PUtil getActualWidth:30], [PUtil getActualWidth:30], [PUtil getActualWidth:30], [PUtil getActualWidth:30]);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_handleDelegate){
        GoodsModel *model = [datas objectAtIndex:indexPath.row];
        [_handleDelegate goGoodsDetailPage:model.goods_id];
        [UMUtil clickEvent:EVENT_GOODS];
    }
}

-(void)requestList : (Boolean)isRequestMore{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"index"] = @(index);
    dic[@"tp"] = _type;

    [ByNetUtil get:API_GOODS_LIST parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            id items = [data objectForKey:@"items"];
            NSMutableArray *tempDatas = [GoodsModel mj_objectArrayWithKeyValuesArray:items];
            if(isRequestMore){
                [datas addObjectsFromArray:tempDatas];
            }else{
                datas = tempDatas;
            }
            [_collectionView reloadData];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
    }];
}

@end
