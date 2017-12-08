//
//  WDNearDetailsViewController.h
//  WuDou
//
//  Created by huahua on 16/8/8.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDAppInitManeger.h"
#import "WDNearStoreManager.h"
#import "WDMainRequestManager.h"

@interface WDNearDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;
- (IBAction)shopBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *shopCarImage;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;
@property (weak, nonatomic) IBOutlet UIView *oldView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *getCoupon;
@property (weak, nonatomic) IBOutlet UIView *hejiView;

// 顶部店铺信息
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogo;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storePriceMsg;
@property (weak, nonatomic) IBOutlet UILabel *storeGoodsMsg;


/** 店铺ID*/
@property(nonatomic, copy)NSString *storeId;
/** 店铺详情（底部分类）*/
@property(nonatomic, strong)NSMutableArray *bottomDetailsArr;


@end
