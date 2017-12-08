//
//  WDSpeakViewController.h
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSpeakCategoriesManager.h"

@interface WDSpeakViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *leftCollectionView;


@property (weak, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)searchBtnClick:(UIButton *)sender;

/** 左侧列表数组*/
@property(nonatomic,strong)NSMutableArray *leftArray;

/** 右侧列表头部数组*/
@property(nonatomic, strong)NSMutableArray *headerArray;

/** 右侧列表单元格数组*/
@property(nonatomic, strong)NSMutableArray *cellArray;

/** 大数组*/
@property(nonatomic, strong)NSMutableArray *allDatasArray;

@end


