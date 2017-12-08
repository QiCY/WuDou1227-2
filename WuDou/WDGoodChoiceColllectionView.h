//
//  WDGoodChoiceColllectionView.h
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDAppInitManeger.h"
#import "WDGoodChoiceModel.h"

@interface WDGoodChoiceColllectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* 数据源数组 **/
@property (nonatomic,strong)NSMutableArray * datasArray;

@property (nonatomic,weak)UIViewController * goodsInfoVC;
@property(nonatomic,strong)NSDictionary *goodsData;
@property(nonatomic,strong)NSMutableArray *goodsList;
@property(nonatomic,strong)NSMutableArray *adList;
@end
