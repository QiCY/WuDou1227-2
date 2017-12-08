//
//  WDUsedGoodsViewController.h
//  WuDou
//
//  Created by huahua on 16/8/16.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMainRequestManager.h"

@interface WDUsedGoodsViewController : UIViewController

/* 二手品专区搜索框 **/
@property (weak, nonatomic) IBOutlet UISearchBar *usedGoodsSearchBar;
/* 二手品专区轮播图 **/
@property (weak, nonatomic) IBOutlet UIView *usedGoodsLunbo;
/* 二手品专区下拉列表按钮视图 **/
@property (weak, nonatomic) IBOutlet UIView *usedGoodsBtnView;
/* 二手品专区tableView **/
@property (weak, nonatomic) IBOutlet UITableView *usedGoodsTableView;



@end
