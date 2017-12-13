//
//  WDExtentionCollectionView.m
//  WuDou
//
//  Created by huahua on 16/8/4.
//  Copyright © 2016年 os1. All rights reserved.
//  首页 分类按钮 CollectionView

#import "WDExtentionCollectionView.h"
#import "WDExtentionCell.h"
#import "WDNearViewController.h"
#import "WDNavigationController.h"
//#import "WDBianmingViewControllers.h"
#import "WDBMViewController.h"
#import "WDUsedGoodsViewController.h"
#import "WDJifenStoreViewController.h"
#import "WDNearDetailsViewController.h"
#import "WDTabbarViewController.h"
#import "WDFruitsVegetablesViewController.h"
#import "WDStoreDetailViewController.h"

@interface WDExtentionCollectionView ()
{
    UIView *_jifenView;  //积分视图
}
@end

static NSString *string = @"WDExtentionCell";

@implementation WDExtentionCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        
        // 注册
        [self registerNib:[UINib nibWithNibName:@"WDExtentionCell" bundle:nil] forCellWithReuseIdentifier:string];
    }
    
    return self;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WDExtentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:string forIndexPath:indexPath];
    
    NSString *image = _dataImageArray[indexPath.item];
    NSString *title = _dataTitleArray[indexPath.item];
    
    cell.extentionImageView.image = [UIImage imageNamed:image];
    cell.extentionLabel.text = title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == 0) {
        
        WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc] init];
        nearVC.storeId = @"14";
//        nearVC.normalBtnClicked = @"0";
        nearVC.type = 0;
        [WDAppInitManeger saveStrData:nearVC.storeId withStr:@"shopID"];
        [_superVC.navigationController pushViewController:nearVC animated:YES];
        
    }
    if (indexPath.item == 1) {
        
        WDNearViewController *nearVC = [[WDNearViewController alloc] init];
        nearVC.navTitle = _dataTitleArray[indexPath.item];
        nearVC.leftCode = @"01";
        WDNavigationController * navVc = [[WDNavigationController alloc] initWithRootViewController:nearVC];
        [_superVC presentViewController:navVc animated:YES completion:nil];
    }
    if (indexPath.item == 2) {
        
        WDNearViewController *nearVC = [[WDNearViewController alloc] init];
        nearVC.navTitle = _dataTitleArray[indexPath.item];
        nearVC.leftCode = @"02";
        WDNavigationController * navVc = [[WDNavigationController alloc] initWithRootViewController:nearVC];
        [_superVC presentViewController:navVc animated:YES completion:nil];
    }
    if (indexPath.item == 3) {
//        超市便利
        WDNearViewController *nearVC = [[WDNearViewController alloc] init];
        nearVC.navTitle = _dataTitleArray[indexPath.item];
        nearVC.leftCode = @"05";
        WDNavigationController * navVc = [[WDNavigationController alloc] initWithRootViewController:nearVC];
        [_superVC presentViewController:navVc animated:YES completion:nil];
        
//        WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
//        nearVC.storeId = @"27";
//        [WDAppInitManeger saveStrData:nearVC.storeId withStr:@"shopID"];
//        [_superVC.navigationController pushViewController:nearVC animated:YES];
    }
//    if (indexPath.item == 4) {
//        
//        WDTabbarViewController *tabbar = [[WDTabbarViewController alloc]init];
//        tabbar.selectedIndex = 1;
//        UIWindow * window = [[UIApplication sharedApplication].delegate window];
//        window.rootViewController = tabbar;
//    }
    
//    if (indexPath.item == 5) {
//        
//        WDNearViewController *nearVC = [[WDNearViewController alloc] init];
//        nearVC.navTitle = _dataTitleArray[indexPath.item];
//        nearVC.leftCode = @"03";
//        WDNavigationController * navVc = [[WDNavigationController alloc] initWithRootViewController:nearVC];
//        [_superVC presentViewController:navVc animated:YES completion:nil];
//    }
//    if (indexPath.item == 6) {
//        
//        WDNearViewController *nearVC = [[WDNearViewController alloc] init];
//        nearVC.navTitle = _dataTitleArray[indexPath.item];
//        nearVC.leftCode = @"04";
//        WDNavigationController * navVc = [[WDNavigationController alloc] initWithRootViewController:nearVC];
//        [_superVC presentViewController:navVc animated:YES completion:nil];
//    }
//    if (indexPath.item == 7)
//    {
//        
//        WDJifenStoreViewController *scoreShopVC = [[WDJifenStoreViewController alloc]init];
//        [_superVC.navigationController pushViewController:scoreShopVC animated:YES];
//    }
//    if (indexPath.item == 8) {
//        
//        WDUsedGoodsViewController *usedGoodsVC = [[WDUsedGoodsViewController alloc]init];
//        [_superVC.navigationController pushViewController:usedGoodsVC animated:YES];
//        
//    }
    if (indexPath.item == 4) {
        
//        WDBMViewController *convenienceServicesVC = [[WDBMViewController alloc]init];
//        [_superVC.navigationController pushViewController:convenienceServicesVC animated:YES];

        WDJifenStoreViewController *scoreShopVC = [[WDJifenStoreViewController alloc]init];
        [_superVC.navigationController pushViewController:scoreShopVC animated:YES];
    }
}

@end
