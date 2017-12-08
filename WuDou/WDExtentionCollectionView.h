//
//  WDExtentionCollectionView.h
//  WuDou
//
//  Created by huahua on 16/8/4.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDExtentionCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* 数据源 **/
@property (nonatomic,strong)NSArray *dataImageArray;

@property (nonatomic,strong)NSArray *dataTitleArray;

/** 父控制器*/
@property (nonatomic,strong)UIViewController *superVC;

@end
