//
//  WDGoodChoiceColllectionView.m
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDGoodChoiceColllectionView.h"
#import "WDGoodChoiceCell.h"
#import "WDGoodsInfoViewController.h"
#import "WDNearDetailsViewController.h"

static NSString *string = @"WDGoodChoiceCell";

@implementation WDGoodChoiceColllectionView
{
    NSMutableArray * _nameArr;
    NSMutableArray * _priceArr;
    NSMutableArray * _imageArr;
}


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.adList = [NSMutableArray new];
        self.goodsList = [NSMutableArray new];
        self.backgroundColor = [UIColor whiteColor]; /*kViewControllerBackgroundColor*/;
        [self registerNib:[UINib nibWithNibName:@"WDGoodChoiceCell" bundle:nil] forCellWithReuseIdentifier:string];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHeadImg"];

    }
    return self;
}
- (void)setGoodsData:(NSDictionary *)data{
    _goodsData = data;
    self.adList = data[@"adverts"];
    self.goodsList = data[@"goodsList"];
    [self reloadData];
}
- (void)setDatasArray:(NSMutableArray *)datasArray{
    
    _datasArray = datasArray;
    
    _nameArr = [[NSMutableArray alloc]init];
    _priceArr = [[NSMutableArray alloc]init];
    _imageArr = [[NSMutableArray alloc]init];
    
    for (int i=0; i<self.datasArray.count; i++)
    {
        WDGoodChoiceModel * youXuanGood = self.datasArray[i];
        [_nameArr addObject:youXuanGood.name];
        [_priceArr addObject:youXuanGood.shopprice];
        [_imageArr addObject:youXuanGood.img];
    }
    [self reloadData];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.adList.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *header= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cellHeadImg" forIndexPath:indexPath];
        
        WDAdvertisementModel *adModel = self.adList[indexPath.section];
        UIImageView *imgView = [[UIImageView alloc] init];
        NSLog(@"section img url is %@",adModel.img);
        [imgView sd_setImageWithURL:[NSURL URLWithString:adModel.img]];
        imgView.frame = CGRectMake(0, 0, kScreenWidth, 140);
        [header addSubview:imgView];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        button.tag = indexPath.section;
        [button addTarget:self action:@selector(headerViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:button];
        return header;
        
    }
    return nil;
}
- (void)headerViewClicked:(UIButton *)sender{
    WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
     WDAdvertisementModel *adModel = self.adList[sender.tag];
    NSString *storeId = adModel.url;
    nearVC.storeId = storeId;
    [WDAppInitManeger saveStrData:storeId withStr:@"shopID"];
    [_goodsInfoVC.navigationController pushViewController:nearVC animated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableArray *goodsArray = self.goodsList[section];
    return goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WDGoodChoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    NSMutableArray *goodsArray = self.goodsList[indexPath.section];
    WDGoodChoiceModel *model = goodsArray[indexPath.row];
    NSURL *imageUrl = [NSURL URLWithString:model.img];
    [cell.shopImageView sd_setImageWithURL:imageUrl];
    cell.shopInfo.text = [NSString stringWithFormat:@"%@",model.name];
    cell.shopPrice.text = [NSString stringWithFormat:@"￥%@",model.shopprice];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WDGoodsInfoViewController *infoVC = [[WDGoodsInfoViewController alloc]init];
    NSMutableArray *goodsArray = self.goodsList[indexPath.section];
    WDGoodChoiceModel * youXuanGood = goodsArray[indexPath.row];
    NSString *goodsID = youXuanGood.pid;
    infoVC.goodsID = goodsID;
    infoVC.goodsImage = youXuanGood.img;
    [WDAppInitManeger saveStrData:goodsID withStr:@"goodID"];
    [_goodsInfoVC.navigationController pushViewController:infoVC animated:YES];
    
    
    
}

@end
