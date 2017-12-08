//
//  WDNearViewController.h
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDOrderListView.h"
#import "WDAppInitManeger.h"
#import "WDNearStoreManager.h"

@interface WDNearViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (weak, nonatomic) IBOutlet WDOrderListView *lefBtn;
@property (weak, nonatomic) IBOutlet WDOrderListView *rightBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSString *navTitle;

/** 左边分类code*/
@property(nonatomic, copy)NSString *leftCode;

/** 附近店铺数组*/
@property(nonatomic, strong)NSMutableArray *nearStoreArr;

@end
